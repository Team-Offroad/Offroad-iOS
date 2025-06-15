//
//  CharacterChatLogViewController.swift
//  Offroad-iOS
//
//  Created by 김민성 on 11/12/24.
//

import UIKit

import RxSwift
import RxCocoa

enum CharacterChatLogError: LocalizedError {
    case serverError
    case invalidResponse
    case invalidChatLogUpdating
    case networkResultError
    case decodingError
    
    var errorDescription: String? {
        switch self {
        case .serverError:
            return "500대 서버 에러"
        case .invalidResponse:
            return "서버의 응답값이 올바른 형식이 아닙니다."
        case .invalidChatLogUpdating:
            return "updateChatLog 메서드가 호출된 시점에 chatLogDataList의 요소가 2개 이하면 안됩니다."
        case .networkResultError:
            return "네트워크 통신에 문제가 있습니다. `NetworkResult` 의 케이스 중 하나입니다."
        case .decodingError:
            return "응답값을 DTO로 변환하는 것을 실패했습니다."
        }
    }
}

class CharacterChatLogViewController: OffroadTabBarViewController {
    
    //MARK: - Properties
    
    private var rootView: CharacterChatLogView!
    private var chatLogDataList: [CharacterChatItem] = [] {
        didSet {
            chatLogDataSourceForSnapshot = groupChatsByDate(items: chatLogDataList)
        }
    }
    private var chatLogDataSourceForSnapshot: [String: [CharacterChatItem]] = [:]
    
    private var isKeyboardShown: Bool = false
    private var lastCursor: Int? = nil
    private var expectedYOffet: CGFloat = 0
    private var isScrollLoading: Bool = false
    private var didGetAllChatLog: Bool = false
    private var isScrollingToTop: Bool = false
    private var keyboardHeight: CGFloat = 0
    
    private let isCharacterResponding = BehaviorRelay<Bool>(value: false)
    private let patchChatReadRelay = PublishRelay<Int?>()
    
    /// 채팅 로그 뷰가 떠 있을 때 캐릭터 채팅 푸시 알림이 오면 캐릭터 채팅 내용을 전달
    let characterChatPushedRelay = PublishRelay<String>()
    
    private var disposeBag = DisposeBag()
    private var characterId: Int?
    private var characterName: String {
        guard let representativeCharacterId = MyInfoManager.shared.representativeCharacterID else { return "" }
        return MyInfoManager.shared.characterInfo[characterId ?? representativeCharacterId] ?? ""
    }
    
    //MARK: - DiffableDataSource
    
    private var dataSource: UICollectionViewDiffableDataSource<String, CharacterChatItem>!
    
    //MARK: - Life Cycle
    
    init(background: UIView, characterId: Int? = nil) {
        self.characterId = characterId
        super.init(nibName: nil, bundle: nil)
        
        self.rootView = CharacterChatLogView(background: background, characterName: characterName)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTargets()
        setupDelegates()
        configureDataSource()
        setupRxSubscriptions()
        setupNotifications()
        setupGestureRecognizers()
        fetchChatLogDataSourceFromServer(characterId: characterId, limit: 28, cursor: nil) { [weak self] in
            guard let self else { return }
            self.rootView.showChatButton()
            self.rootView.chatLogCollectionView.contentInset.top = 135 + rootView.safeAreaInsets.bottom
            updateCollectionView(animatingDifferences: false) { [weak self] in
                guard let self else { return }
                self.scrollToFirstCell(animated: true)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.view.isUserInteractionEnabled = false
        guard let tabBarController = tabBarController as? OffroadTabBarController else { return }
        tabBarController.showTabBarAnimation()
        rootView.backgroundView.isHidden = false
        ORBCharacterChatManager.shared.currentChatLogViewController = self
        ORBCharacterChatManager.shared.endChat()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        rootView.chatLogCollectionView.automaticallyAdjustsScrollIndicatorInsets = false
        rootView.chatLogCollectionView.verticalScrollIndicatorInsets =
            .init(top: rootView.safeAreaInsets.bottom, left: 0, bottom: 0, right: 0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.view.isUserInteractionEnabled = true
        rootView.backgroundView.isHidden = false
        guard let tabBarController = tabBarController as? OffroadTabBarController else { return }
        tabBarController.enableTabBarInteraction()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        rootView.backgroundView.isHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        navigationController?.view.isUserInteractionEnabled = true
        ORBCharacterChatManager.shared.currentChatLogViewController = nil
    }
    
}

// MARK: - Initial Settings

private extension CharacterChatLogViewController {
    
    private func setupTargets() {
        rootView.backButton.rx.tap.asDriver().drive(onNext: { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }).disposed(by: disposeBag)
    }
    
    private func setupDelegates() {
        rootView.chatLogCollectionView.delegate = self
    }
    
    private func configureDataSource() {
        let orbCharacterCellRegistration = UICollectionView.CellRegistration<ChatLogCellCharacter, CharacterChatMessageItem>(
            handler: { [weak self] cell, indexPath, item in
                guard let self else { return }
                cell.configure(with: item, characterName: self.characterName)
            }
        )
        
        let userCellRegistration = UICollectionView.CellRegistration<ChatLogCellUser, CharacterChatMessageItem>(
            handler: { cell, indexPath, item in cell.configure(with: item) }
        )
        
#if DevTarget
        let orbRecommendationCellRegistration = UICollectionView.CellRegistration<ChatLogCellCharacterRecommendation, CharacterChatMessageItem>(
            handler: { [weak self] cell, indexPath, item in
                guard let self else { return }
                cell.configure(with: item, characterName: self.characterName, buttonTapAction: { [weak self] in
                    self?.navigationController?.pushViewController(
                        ORBRecommendationMainViewController(),
                        animated: true
                    )
                })
            }
        )
#endif
        
        let orbCharacterLoadingCellRegistration = UICollectionView.CellRegistration<ChatLogCellCharacterLoading, CharacterChatItem>(
            handler: { [weak self] cell, indexPath, item in
                guard let self else { return }
                cell.configure(with: item, characterName: self.characterName)
            }
        )
        
        let footerRegistration = UICollectionView.SupplementaryRegistration<CharacterChatLogFooter>(
            elementKind: UICollectionView.elementKindSectionFooter,
            handler: { [weak self] supplementaryView, elementKind, indexPath in
                guard let self else { return }
                let firstChatItemOfDay = self.chatLogDataSourceForSnapshot[self.chatLogDataSourceForSnapshot.keys.sorted(by: { $0 > $1 })[indexPath.section]]?.first
                switch firstChatItemOfDay {
                case .message(let messageItem):
                    supplementaryView.dateLabel.text = messageItem.formattedDateString
                case .loading, nil:
                    return
                }
            }
        )
        
        dataSource = UICollectionViewDiffableDataSource<String, CharacterChatItem>(
            collectionView: rootView.chatLogCollectionView,
            cellProvider: { collectionView, indexPath, item -> UICollectionViewCell? in
                switch item {
                case .loading:
                    return collectionView.dequeueConfiguredReusableCell(
                        using: orbCharacterLoadingCellRegistration,
                        for: indexPath,
                        item: item
                    )
                    
                case .message(let messageItem):
                    switch messageItem {
                    case .user:
                        return collectionView.dequeueConfiguredReusableCell(
                            using: userCellRegistration,
                            for: indexPath,
                            item: messageItem
                        )
                        
                    case .orbCharacter:
                        return collectionView.dequeueConfiguredReusableCell(
                            using: orbCharacterCellRegistration,
                            for: indexPath,
                            item: messageItem
                        )
#if DevTarget
                    case .orbRecommendation:
                        return collectionView.dequeueConfiguredReusableCell(
                            using: orbRecommendationCellRegistration,
                            for: indexPath,
                            item: messageItem
                        )
#endif
                    }
                }
            }
        )
        
        dataSource.supplementaryViewProvider = { (collectionView, kind, indexPath) -> UICollectionReusableView? in
            return collectionView.dequeueConfiguredReusableSupplementary(
                using: footerRegistration,
                for: indexPath
            )
        }
    }
    
    private func setupRxSubscriptions() {
        rootView.chatButton.rx.tap.bind(onNext: { [weak self] in
            guard let self else { return }
            self.hideTabBar()
            self.rootView.chatTextInputView.startChat()
            self.rootView.keyboardBackgroundView.alpha = 1
        }).disposed(by: disposeBag)
        
        rootView.chatTextInputView.onSendingText.subscribe(onNext: { [weak self] sendingText in
            guard let self else { return }
            // 사용자 채팅 버블 추가한 후 0.3초 후에 로딩 말풍선 띄우기
            self.sendChatBubble(chatItem: .message(.user(content: sendingText, createdDate: Date(), id: nil)), completion: {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: { [weak self] in
                    self?.sendChatBubble(chatItem: .loading(createdDate: Date()), completion: { [weak self] in
                        guard let self else { return }
                        self.postCharacterChat(characterId: characterId, message: sendingText)
                    })
                })
            })
        }).disposed(by: disposeBag)
        
        patchChatReadRelay.subscribe(onNext: { [weak self] characterId in
            guard let self else { return }
            NetworkService.shared.characterChatService.patchChatRead(characterId: characterId) { [weak self] networkResult in
                guard let self else { return }
                switch networkResult {
                case .success: return
                default: self.showToast(message: ErrorMessages.networkError, inset: 66)
                }
            }
        }).disposed(by: disposeBag)
        
        NetworkMonitoringManager.shared.networkConnectionChanged
            .subscribe(onNext: { [weak self] isConnected in
                guard let self else { return }
                if !isConnected {
                    showToast(message: ErrorMessages.networkError, inset: 66)
                }
            }).disposed(by: disposeBag)
        
        isCharacterResponding.subscribe { [weak self] isCharacterResponding in
                self?.rootView.chatTextInputView.isSendingAllowed = !isCharacterResponding
            }.disposed(by: disposeBag)
        
        characterChatPushedRelay.subscribe(onNext: { [weak self] message in
            guard let self else { return }
            self.sendChatBubble(chatItem:
                    .message(.orbCharacter(content: message, createdDate: Date(), id: nil))
            )
        }).disposed(by: disposeBag)
    }
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    private func setupGestureRecognizers() {
        let tapGesture = UITapGestureRecognizer()
        tapGesture.rx.event.subscribe(onNext: { [weak self] _ in
            self?.showTabBar()
            self?.rootView.chatTextInputView.endChat()
            self?.rootView.keyboardBackgroundView.alpha = 0
        }).disposed(by: disposeBag)
        rootView.chatLogCollectionView.addGestureRecognizer(tapGesture)
    }
    
}

// MARK: - Private Func

private extension CharacterChatLogViewController {
    
    //MARK: - @objc Func
    
    @objc private func keyboardWillShow(notification: Notification) {
        rootView.layoutIfNeeded()
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let keyboardHeight = keyboardFrame.height
            self.keyboardHeight = keyboardHeight
            // 키보드가 올라올 때는 두 가지 동작이 필요.
            // 1. collectionView의 inset을 설정해주어야 함.
            // 2. collectionView의 스크롤 위치를 끝으로 이동 (채팅하기 버튼은 끝까지 스크롤했을 때에만 보이기 때문)
            
            // collectionView의 inset 추가
            rootView.chatLogCollectionView.contentInset.top = rootView.chatTextInputView.frame.height + 16 + keyboardHeight
            // collectionView의 contentOffset을 끝으로 이동
            rootView.chatLogCollectionView.setContentOffset(
                .init(x: 0, y: -(rootView.chatTextInputView.frame.height + 16 + keyboardHeight)),
                animated: false
            )
            isKeyboardShown = true
        }
    }
    
    @objc private func keyboardWillHide(notification: Notification) {
        rootView.chatLogCollectionView.contentInset.top = 135 + rootView.safeAreaInsets.bottom
        isKeyboardShown = false
    }
    
    //MARK: - Private Func
    
    private func fetchChatLogDataSourceFromServer(characterId: Int? = nil, limit: Int, cursor: Int?, completion: (() -> Void)? = nil) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            guard cursor == nil else { return }
            self.view.startLoading()
        }
        rootView.chatLogCollectionView.startScrollLoading(direction: .bottom)
        NetworkService.shared.characterChatService.getChatLog(characterId: characterId,
                                                              limit: limit,
                                                              cursor: cursor) { [weak self] result in
            guard let self else { return }
            self.view.stopLoading()
            switch result {
            case .success(let responseDTO):
                guard let responseDTO else {
                    showToast(message: "responseDTO가 없습니다.", inset: 66)
                    return
                }
                
                if responseDTO.data.count < limit {
                    self.didGetAllChatLog = true
                    rootView.chatLogCollectionView.stopScrollLoading(direction: .bottom)
                }
                
                do {
                    let newModels: [CharacterChatItem] = try responseDTO.data.map({ .message(try .from(dto: $0)) })
                    if cursor != nil {
                        self.chatLogDataList.append(contentsOf: newModels)
                    } else {
                        self.chatLogDataList = newModels
                    }
                } catch {
                    assertionFailure("CharacterChatItem 매핑 에러. CharacterChatItem init 실패: \(error.localizedDescription)")
                }
                
                guard chatLogDataList.count > 0, let lastItem = chatLogDataList.last else { return }
                switch lastItem {
                case .message(let messageItem):
                    if let id = messageItem.id {
                        self.lastCursor = id
                    }
                case .loading:
                    return
                }
                completion?()
            case .networkFail:
                return
            case .decodeErr:
                showToast(message: "디코딩 에러.", inset: 66)
            case .serverErr:
                showToast(message: "서버 에러.", inset: 66)
            default:
                self.showToast(message: "Something went wrong", inset: 60)
            }
        }
    }
    
    private func scrollToLastCell(animated: Bool) {
        guard let lastIndexPath = rootView.chatLogCollectionView.getIndexPathFromLast(index: 1) else { return }
        if animated {
            let targetOffset = CGPoint(
                x: 0,
                y: rootView.chatLogCollectionView.contentSize.height - rootView.chatLogCollectionView.bounds.height
            )
            self.rootView.chatLogCollectionView.setContentOffset(targetOffset, animated: true)
            
        } else {
            rootView.chatLogCollectionView.scrollToItem(at: lastIndexPath, at: .top, animated: false)
            isScrollingToTop = false
            if !isScrollLoading && !didGetAllChatLog {
                expandChatLogCollectionView()
            }
        }
        
    }
    
    private func scrollToFirstCell(animated: Bool) {
        if isKeyboardShown {
            rootView.chatLogCollectionView.setContentOffset(
                .init(x: 0, y: -(keyboardHeight + rootView.chatTextInputView.frame.height + 16)),
                animated: true
            )
        } else {
            rootView.chatLogCollectionView.setContentOffset(
                .init(x: 0, y: -(135 + rootView.safeAreaInsets.bottom)),
                animated: true
            )
        }
    }
    
    private func sendChatBubble(chatItem: CharacterChatItem, completion: (() -> Void)? = nil) {
        chatLogDataList.insert(chatItem, at: 0)
        updateCollectionView(animatingDifferences: true, completion: { [weak self] in
            self?.scrollToFirstCell(animated: true)
            completion?()
        })
    }
    
    private func postCharacterChat(characterId: Int?, message: String) {
        isCharacterResponding.accept(true)
        let dto = CharacterChatPostRequestDTO(content: message)
        NetworkService.shared.characterChatService.postChat(characterId: characterId, body: dto) { [weak self] result in
            guard let self else { return }
            do {
                switch result {
                case .success(let dto):
                    guard let data = dto?.data else {
                        self.showToast(message: "response data is Empty", inset: 66)
                        return
                    }
                    let item = try CharacterChatItem.message(.from(dto: data))
                    switch item {
                    case .message(let messageItem):
                        try self.updateChatLog(result: .success(messageItem))
                    case .loading:
                        try self.updateChatLog(result: .failure(.invalidResponse))
                    }
                case .decodeErr:
                    self.showToast(message: "decode Error occurred", inset: 66)
                    try self.updateChatLog(result: .failure(.decodingError))
                case .serverErr:
                    self.showToast(message: "오브가 답변하기 힘든 질문이예요.\n다른 이야기를 해볼까요?", inset: 66)
                    try self.updateChatLog(result: .failure(.networkResultError))
                case .requestErr:
                    self.showToast(message: "requestError occurred", inset: 66)
                    try self.updateChatLog(result: .failure(.networkResultError))
                case .unAuthentication:
                    self.showToast(message: "unAuthentication Error occurred", inset: 66)
                    try self.updateChatLog(result: .failure(.networkResultError))
                case .unAuthorization:
                    self.showToast(message: "unAuthorized Error occurred", inset: 66)
                    try self.updateChatLog(result: .failure(.networkResultError))
                case .apiArr:
                    self.showToast(message: "api Error occurred", inset: 66)
                    try self.updateChatLog(result: .failure(.networkResultError))
                case .pathErr:
                    self.showToast(message: "path Error occurred", inset: 66)
                    try self.updateChatLog(result: .failure(.networkResultError))
                case .registerErr:
                    self.showToast(message: "register Error occurred", inset: 66)
                    try self.updateChatLog(result: .failure(.networkResultError))
                case .networkFail:
                    self.showToast(message: ErrorMessages.networkError, inset: 66)
                    try self.updateChatLog(result: .failure(.networkResultError))
                }
                self.isCharacterResponding.accept(false)
            } catch {
                assertionFailure(error.localizedDescription)
            }
        }
    }
    
    private func updateChatLog(result: Result<CharacterChatMessageItem, CharacterChatLogError>) throws {
        // 이 메서드는 채팅 시도 후 결과를 업데이트하기 위한 것이므로,
        // `chatLogDataList`에 최소 2개(사용자가 보낸 채팅 아이템, 캐릭터 로딩 아이템) 이상의 요소가 존재해야 함.
        guard chatLogDataList.count >= 2 else {
            throw CharacterChatLogError.invalidChatLogUpdating
        }
        switch result {
        case .success(let chatItem):
            switch chatItem {
            case .user:
                throw CharacterChatLogError.invalidResponse
            case .orbCharacter:
                // 로딩 셀이던 가장 최신 셀을 메시지 셀로 교체
                chatLogDataList[0] = .message(chatItem)
#if DevTarget
            case .orbRecommendation:
                // 로딩 셀이던 가장 최신 셀을 메시지 셀로 교체
                chatLogDataList[0] = .message(chatItem)
#endif
                
            }
        case .failure(let error):
            assertionFailure(error.localizedDescription)
            chatLogDataList.removeFirst(2)
        }
        
        updateCollectionView(animatingDifferences: true) { [weak self] in
            guard let self else { return }
            self.scrollToFirstCell(animated: true)
            self.patchChatReadRelay.accept(characterId)
            self.rootView.showChatButton()
        }
    }
    
    private func updateCollectionView(animatingDifferences animating: Bool, completion: (() -> Void)? = nil) {
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            guard let self else { return }
            var snapshot = NSDiffableDataSourceSnapshot<String, CharacterChatItem>()
            snapshot.appendSections(chatLogDataSourceForSnapshot.keys.sorted(by: { $0 > $1 }))
            chatLogDataSourceForSnapshot.keys.sorted { $0 > $1 }.forEach { [weak self] dateInString in
                guard let self else { return }
                snapshot.appendItems(self.chatLogDataSourceForSnapshot[dateInString]!, toSection: dateInString)
            }
            
            self.dataSource.apply(snapshot, animatingDifferences: animating, completion: { [weak self] in
                guard let self else { return }
                self.isScrollLoading = false
                completion?()
            })
        }
    }
    
    private func expandChatLogCollectionView() {
        isScrollLoading = true
        self.fetchChatLogDataSourceFromServer(characterId: characterId, limit: 14, cursor: lastCursor) { [weak self] in
            guard let self else { return }
            self.updateCollectionView(animatingDifferences: true)
        }
    }
    
    private func hideTabBar() {
        guard let tabBarController = tabBarController as? OffroadTabBarController else { return }
        tabBarController.hideTabBarAnimation() {
            self.additionalSafeAreaInsets.bottom -= tabBarController.tabBarHeight
        }
    }
    
    private func showTabBar() {
        guard let tabBarController = tabBarController as? OffroadTabBarController else { return }
        tabBarController.showTabBarAnimation() {
            self.additionalSafeAreaInsets.bottom += tabBarController.tabBarHeight
            tabBarController.enableTabBarInteraction()
        }
    }
    
    private func groupChatsByDate(items: [CharacterChatItem]) -> [String: [CharacterChatItem]] {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return Dictionary(grouping: items, by: { formatter.string(from: $0.createdDate) })
    }
    
}

//MARK: - UIScrollViewDelegate

extension CharacterChatLogViewController: UIScrollViewDelegate {
    
    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        showTabBar()
        rootView.chatTextInputView.endChat()
        isScrollingToTop = true
        // custom ScrollToTop 동작
        scrollToLastCell(animated: true)
        return false
    }
    
    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        isScrollingToTop = false
        if !isScrollLoading && !didGetAllChatLog {
            expandChatLogCollectionView()
        }
    }
    
    // setContentOffset(_:animated:)/scrollRectToVisible(_:animated:) 이 끝나면 호출됨. 애니메이션이 없으면 호출되지 않음.
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        self.isScrollingToTop = false
        if !self.isScrollLoading && !self.didGetAllChatLog {
            self.expandChatLogCollectionView()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 무한스크롤 발동 조건
        if scrollView.contentOffset.y > (scrollView.contentSize.height - scrollView.bounds.height)
            && scrollView.isDecelerating
            && !isScrollLoading
            && !didGetAllChatLog {
            expandChatLogCollectionView()
        }
        
        // 채팅하기 버튼 숨김 여부
        if scrollView.contentSize.height > 0 {
            let scrollOffsetAtBottomEdge =
            -(rootView.safeAreaInsets.bottom + 135)
            
            if floor(scrollView.contentOffset.y) <= (scrollOffsetAtBottomEdge) {
                rootView.showChatButton()
            } else {
                rootView.hideChatButton()
            }
        } else {
            rootView.showChatButton()
        }
    }
    
}

//MARK: - UICollectionViewDelegateFlowLayout

extension CharacterChatLogViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return .zero }
        switch item {
        case .message(let messageItem):
            switch messageItem {
            case .user:
                return ChatLogCellUser.calculatedCellSize(
                    item: messageItem,
                    fixedWidth: collectionView.bounds.width
                )
            case .orbCharacter:
                return ChatLogCellCharacter.calculatedCellSize(
                    item: messageItem,
                    characterName: characterName,
                    fixedWidth: collectionView.bounds.width
                )
#if DevTarget
            case .orbRecommendation:
                return ChatLogCellCharacterRecommendation.calculatedCellSize(
                    item: messageItem,
                    characterName: characterName,
                    fixedWidth: collectionView.bounds.width
                )
#endif
            }
        case .loading:
            return ChatLogCellCharacterLoading.calculatedCellSize(
                item: .loading(createdDate: Date()),
                characterName: characterName,
                fixedWidth: collectionView.bounds.width
            )
        }
    }
    
}
