//
//  CharacterChatLogViewController.swift
//  Offroad-iOS
//
//  Created by 김민성 on 11/12/24.
//

import UIKit

import RxSwift
import RxCocoa

class CharacterChatLogViewController: OffroadTabBarViewController {
    
    //MARK: - Properties
    
    private let viewModel = CharacterChatLogViewModel()
    private let chatButtonHidingAnimator = UIViewPropertyAnimator(duration: 0.5, dampingRatio: 1)
    private var rootView: CharacterChatLogView!
    private var chatLogDataList: [ChatDataModel] = [] {
        didSet {
            chatLogDataSource = viewModel.groupChatsByDate(chats: chatLogDataList)
            chatLogDataSourceForSnapshot = viewModel.groupChatsByDateForDiffableDataSource(chats: chatLogDataList)
        }
    }
    private var chatLogDataSource: [[ChatDataModel]] = [[]]
    private var chatLogDataSourceForSnapshot: [String: [ChatDataModel]] = [:]
    private var isChatButtonHidden: Bool = true
    /// 채팅 중에 채팅 로그 뷰 진입 시 키보드가 내려가는데, 이때 keyboardWillHide() 메서드가 불리지 않게 하기 위해 사용하는 flag.
    ///
    /// 채팅 중에 채팅 로그 뷰에 진입하면 키보드가 내려가는 경우 `keyboardWillHide()`가 불리게 되는데, 이때
    /// `rootView.safeAreaInsets.bottom` 와 `rootView.userChatView.frame.height`가 0 이어서 사용자 입력창이 보이게 되는 현상 발생함.
    private var isKeyboardShown: Bool = false
    private var lastCursor: Int? = nil
    private var expectedYOffet: CGFloat = 0
    private var isScrollLoading: Bool = false
    private var didGetAllChatLog: Bool = false
    private var isScrollingToTop: Bool = false
    
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
    
    private var dataSource: UICollectionViewDiffableDataSource<String, ChatDataModel>!
    
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
        bindData()
        setupNotifications()
        setupGestureRecognizers()
        updateChatLogDataSource(characterId: characterId, limit: 28, cursor: nil) { [weak self] in
            guard let self else { return }
            self.showChatButton()
            self.rootView.chatLogCollectionView.contentInset.top = 135 + rootView.safeAreaInsets.bottom
            updateCollectionView(animatingDifferences: false) { [weak self] in
                guard let self else { return }
                self.scrollToFirstCell(at: .centeredVertically, animated: true)
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
        showChatButton()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        rootView.backgroundView.isHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        ORBCharacterChatManager.shared.currentChatLogViewController = nil
    }
    
}

extension CharacterChatLogViewController {
    
    //MARK: - @objc Func
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        rootView.layoutIfNeeded()
        // 키보드가 올라올 때는 두 가지 동작이 필요함.
        // 1. collectionView의 inset을 추가해주어야 함.
        // 2. collectionView의 스크롤 위치를 끝으로 이동 (채팅하기 버튼은 끝까지 스크롤했을 때에만 보이기 때문)
        
        // collectionView의 inset 추가
        rootView.setChatCollectionViewInset(inset: rootView.chatTextInputView.frame.height + 16)
        // collectionView의 contentOffset을 끝으로 이동
        rootView.chatLogCollectionView.setContentOffset(
            .init(x: 0, y: -(rootView.chatTextInputView.frame.height + 16)),
            animated: false
        )
    }
    
    @objc private func keyboardWillHide(notification: Notification) {
        rootView.setChatCollectionViewInset(inset: 135 + rootView.safeAreaInsets.bottom)
    }
    
    @objc private func tapGestureHandler(_ sender: UITapGestureRecognizer) {
        showTabBar()
        rootView.chatTextInputView.endChat()
    }
    
    //MARK: - Private Func
    
    private func setupTargets() {
        rootView.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    private func setupDelegates() {
        rootView.chatLogCollectionView.delegate = self
    }
    
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<CharacterChatLogCell, ChatDataModel>(
            handler: { [weak self] cell, indexPath, item in
                guard let self else { return }
                cell.configure(with: item, characterName: self.characterName)
            })
        
        let footerRegistration = UICollectionView.SupplementaryRegistration<CharacterChatLogFooter>(
            elementKind: UICollectionView.elementKindSectionFooter,
            handler: { [weak self] supplementaryView, elementKind, indexPath in
                guard let self else { return }
                let firstChatDataModelOfDay = self.chatLogDataSourceForSnapshot[self.chatLogDataSourceForSnapshot.keys.sorted(by: { $0 > $1 })[indexPath.section]]?.first
                supplementaryView.dateLabel.text = firstChatDataModelOfDay?.formattedDateString
            })
        
        
        dataSource = UICollectionViewDiffableDataSource<String, ChatDataModel>(
            collectionView: rootView.chatLogCollectionView,
            cellProvider: { collectionView, indexPath, identifier -> UICollectionViewCell? in
                return collectionView.dequeueConfiguredReusableCell(using: cellRegistration,
                                                                    for: indexPath,
                                                                    item: identifier)
            })
        
        dataSource.supplementaryViewProvider = { (collectionView, kind, indexPath) -> UICollectionReusableView? in
            return collectionView.dequeueConfiguredReusableSupplementary(using: footerRegistration,
                                                                         for: indexPath)
        }
    }
    
    private func hideChatButton() {
        guard !isChatButtonHidden else { return }
        isChatButtonHidden = true
        rootView.chatButton.isUserInteractionEnabled = false
        chatButtonHidingAnimator.stopAnimation(true)
        chatButtonHidingAnimator.addAnimations { [weak self] in
            guard let self else { return }
            self.rootView.chatButtonBottomConstraint.constant = rootView.chatButton.frame.height
            self.rootView.layoutIfNeeded()
        }
        chatButtonHidingAnimator.startAnimation()
    }
    
    private func showChatButton() {
        guard isChatButtonHidden else { return }
        isChatButtonHidden = false
        rootView.chatButton.isUserInteractionEnabled = true
        chatButtonHidingAnimator.stopAnimation(true)
        chatButtonHidingAnimator.addAnimations { [weak self] in
            guard let self else { return }
            self.rootView.chatButtonBottomConstraint.constant = -(self.rootView.safeAreaInsets.bottom + 67.3)
            self.rootView.layoutIfNeeded()
        }
        chatButtonHidingAnimator.startAnimation()
    }
    
    private func setupGestureRecognizers() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureHandler))
        rootView.chatLogCollectionView.addGestureRecognizer(tapGesture)
    }
    
    private func updateChatLogDataSource(characterId: Int? = nil, limit: Int, cursor: Int?, completion: (() -> Void)? = nil) {
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
                if cursor != nil {
                    self.chatLogDataList.append(contentsOf: responseDTO.data.map({ ChatDataModel(data: $0) }))
                } else {
                    self.chatLogDataList = responseDTO.data.map({ ChatDataModel(data: $0) })
                }
                
                guard chatLogDataList.count > 0 else { return }
                self.lastCursor = chatLogDataList.last!.id
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
    
    private func bindData() {
        rootView.chatButton.rx.tap.bind(onNext: { [weak self] in
            guard let self else { return }
            self.hideTabBar()
            self.rootView.chatTextInputView.startChat()
        }).disposed(by: disposeBag)
        
        rootView.chatTextInputView.onSendingText.subscribe(onNext: { [weak self] sendingText in
            guard let self else { return }
            // 사용자 채팅 버블 추가
            self.sendChatBubble(isUserChat: true, text: sendingText, isLoading: false) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
                    guard let self else { return }
                    // 캐릭터 셀 추가
                    self.sendChatBubble(isUserChat: false, text: "", isLoading: true) { [weak self] in
                        guard let self else { return }
                        self.postCharacterChat(characterId: characterId, message: sendingText)
                    }
                }
            }
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
            self.sendChatBubble(isUserChat: false, text: message, isLoading: false)
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
    
    private func scrollToFirstCell(at scrollPosition: UICollectionView.ScrollPosition = .top, animated: Bool) {
        guard rootView.chatLogCollectionView.cellForItem(
            at: IndexPath(item: 0, section: 0)
        ) != nil else { return }
        rootView.chatLogCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: scrollPosition, animated: animated)
    }
    
    private func sendChatBubble(isUserChat: Bool, text: String, isLoading: Bool, completion: (() -> Void)? = nil) {
        let currentDate = Date()
        let chatDataModelToAppend = ChatDataModel(
            role: isUserChat ? "USER" : "ORB_CHARACTER",
            content: text,
            createdData: currentDate,
            isLoading: isLoading
        )
        
        chatLogDataList.insert(chatDataModelToAppend, at: 0)
        updateCollectionView(animatingDifferences: true, completion: { completion?() })
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) { [weak self] in
            guard let self else { return }
            self.scrollToFirstCell(animated: true)
        }
    }
    
    private func postCharacterChat(characterId: Int?, message: String) {
        isCharacterResponding.accept(true)
        let dto = CharacterChatPostRequestDTO(content: message)
        NetworkService.shared.characterChatService.postChat(characterId: characterId, body: dto) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let dto):
                guard let data = dto?.data else {
                    self.showToast(message: "response data is Empty", inset: 66)
                    return
                }
                let chatDataModel = ChatDataModel(data: data)
                self.updateChatLog(chatSuccess: true, characterResponse: chatDataModel)
                
            case .requestErr:
                self.showToast(message: "requestError occurred", inset: 66)
            case .unAuthentication:
                self.showToast(message: "unAuthentication Error occurred", inset: 66)
            case .unAuthorization:
                self.showToast(message: "unAuthorized Error occurred", inset: 66)
            case .apiArr:
                self.showToast(message: "api Error occurred", inset: 66)
            case .pathErr:
                self.showToast(message: "path Error occurred", inset: 66)
            case .registerErr:
                self.showToast(message: "register Error occurred", inset: 66)
            case .networkFail:
                self.showToast(message: ErrorMessages.networkError, inset: 66)
            case .serverErr:
                self.showToast(message: "오브가 답변하기 힘든 질문이예요.\n다른 이야기를 해볼까요?", inset: 66)
                self.updateChatLog(chatSuccess: false)
            case .decodeErr:
                self.showToast(message: "decode Error occurred", inset: 66)
            }
            self.isCharacterResponding.accept(false)
        }
    }
    
    
    /// 채팅의 결과가 나왔을 때, 채팅 로그를 업데이트하는 메서드
    /// - Parameter chatSuccess: 채팅이 성공했는지, 실패했는지 여부
    /// - Parameter characterResponse: 채팅이 성공했을 경우, 받은 캐릭터의 답장. chatSuccess 가 false인 경우, 이 값은 무시됨.
    ///
    /// 채팅이 성공했을 경우, 로딩 중이던 캐릭터의 말풍선이 캐릭터가 답변한 내용으로 변경됨.
    ///
    /// 채팅이 실패했을 경우, 로딩 중이던 캐릭터의 말풍선과 직전에 내가 했던 말풍선을 지움.
    ///
    /// 지우려는 말풍선의 indexPath를 구할 수 없는 경우, 채팅 로그 뷰컨트롤러를 nagivation stack에서 pop 하며 에러 메시지 토스트 표시
    private func updateChatLog(chatSuccess: Bool, characterResponse: ChatDataModel? = nil) {
        let dataSourceSectionCount = chatLogDataSource.count
        let dataSourceLastSectionItemCount = chatLogDataSource.last?.count ?? 0
        
        guard dataSourceSectionCount > 0, dataSourceLastSectionItemCount > 1 else { return }
        
        guard
            let lastIndexPath = self.rootView.chatLogCollectionView.getIndexPathFromLast(index: 1),
            let secondLastIndexPath = self.rootView.chatLogCollectionView.getIndexPathFromLast(index: 2) else {
            self.showToast(message: "알 수 없는 오류가 발생했어요. 채팅을 다시 시도해 주세요.", inset: 66)
            self.rootView.chatLogCollectionView.reloadData()
            self.scrollToFirstCell(animated: true)
            return
        }
        
        if chatSuccess {
            if let characterResponse, chatLogDataList.count > 0 {
                chatLogDataList[0] = characterResponse
            }
            updateCollectionView(animatingDifferences: true) { [weak self] in
                guard let self else { return }
                self.scrollToFirstCell(animated: true)
                self.patchChatReadRelay.accept(characterId)
                self.showChatButton()
            }
        } else {
            chatLogDataList.removeFirst(2)
            updateCollectionView(animatingDifferences: true) { [weak self] in
                guard let self else { return }
                self.scrollToFirstCell(animated: true)
                self.patchChatReadRelay.accept(characterId)
                self.showChatButton()
            }
        }
    }
    
    private func updateCollectionView(animatingDifferences animating: Bool, completion: (() -> Void)? = nil) {
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            guard let self else { return }
            var snapshot = NSDiffableDataSourceSnapshot<String, ChatDataModel>()
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
        self.updateChatLogDataSource(characterId: characterId, limit: 14, cursor: lastCursor) { [weak self] in
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
    
    // customScrollToTop 의 completion handler 역할
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
                showChatButton()
            } else {
                hideChatButton()
            }
        } else {
            showChatButton()
        }
    }
    
}

//MARK: - UICollectionViewDelegateFlowLayout

extension CharacterChatLogViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let characterNameLabelSize: CGSize = viewModel.calculateLabelSize(
            text: characterName,
            font: .offroad(style: .iosTextBold),
            maxSize: .init(width: 200, height: 24)
        )
        let timeLabelSize: CGSize = viewModel.calculateLabelSize(
            text: chatLogDataSource[indexPath.section][indexPath.item].formattedTimeString,
            font: .offroad(style: .iosTextContentsSmall),
            maxSize: .init(width: 100, height: 14)
        )
        let maxMessageLabelWidth: CGFloat
        
        if chatLogDataSource[indexPath.section][indexPath.item].role == "USER" {
            maxMessageLabelWidth =
            UIScreen.currentScreenSize.width
            // timeLabelSize의 너비 및 chatBubble과의 offset
            - (timeLabelSize.width + 6.0)
            // cell 안의 콘텐츠에 적용되는 수평 inset(collectionView의 수평 contentInset 별도로 안 설정함)
            - (24.0 * 2)
            // chatBubble 안의 콘텐츠 inset
            - (20.0 * 2)
        // role == "ORB_CHARACTER"
        } else {
            maxMessageLabelWidth =
            UIScreen.currentScreenSize.width
            // timeLabelSize의 너비 및 chatBubble과의 offset
            - (timeLabelSize.width + 6.0)
            // cell 안의 콘텐츠에 적용되는 수평 inset(collectionView의 수평 contentInset 별도로 안 설정함)
            - (24.0 * 2)
            // chatBubble 안의 콘텐츠 inset
            - (20.0 * 2)
            // 캐릭터 이름 라벨 너비 및 메시지 라벨과의 offset
            - (characterNameLabelSize.width + 4.0)
        }
        let messageLabelSize = viewModel.calculateLabelSize(text: chatLogDataSource[indexPath.section][indexPath.item].content, font: .offroad(style: .iosText), maxSize: .init(width: maxMessageLabelWidth, height: 400))
        return CGSize(width: UIScreen.currentScreenSize.width, height: messageLabelSize.height + (14*2))
    }
    
}
