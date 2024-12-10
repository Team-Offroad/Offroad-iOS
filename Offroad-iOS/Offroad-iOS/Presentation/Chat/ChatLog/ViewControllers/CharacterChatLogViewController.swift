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
        didSet { chatLogDataSource = viewModel.groupChatsByDate(chats: chatLogDataList) }
    }
    private var chatLogDataSource: [[ChatDataModel]] = [[]]
    private var isChatButtonHidden: Bool = true
    /// 채팅 중에 채팅 로그 뷰 진입 시 키보드가 내려가는데, 이때 keyboardWillHide() 메서드가 불리지 않게 하기 위해 사용하는 flag.
    ///
    /// 채팅 중에 채팅 로그 뷰에 진입하면 키보드가 내려가는 경우 `keyboardWillHide()`가 불리게 되는데, 이때
    /// `rootView.safeAreaInsets.bottom` 와 `rootView.userChatView.frame.height`가 0 이어서 사용자 입력창이 보이게 되는 현상 발생함.
    private var isKeyboardShown: Bool = false
    private var lastCursor: Int? = nil
    private var isScrollLoading: Bool = false
    private var didGetAllChatLog: Bool = false
    private var isScrollingToTop: Bool = false
    
    // userChatInputView의 textInputView의 height를 전달
    let userChatInputViewTextInputViewHeightRelay = PublishRelay<CGFloat>()
    let userChatInputViewHeightAnimator = UIViewPropertyAnimator(duration: 0.3, dampingRatio: 1)
    let isCharacterResponding = BehaviorRelay<Bool>(value: false)
    let isTextViewEmpty = BehaviorRelay<Bool>(value: true)
    
    var disposeBag = DisposeBag()
    var characterId: Int?
    var characterName: String {
        guard let representativeCharacterId = MyInfoManager.shared.representativeCharacterID else { return "" }
        return MyInfoManager.shared.characterInfo[characterId ?? representativeCharacterId] ?? ""
    }
    
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
        
        bindData()
        setupNotifications()
        setupGestureRecognizers()
        updateChatLogDataSource(characterId: characterId, limit: 28, cursor: nil) { [weak self] in
            guard let self else { return }
            self.didGetAllChatLog = false
            self.showChatButton()
            self.rootView.chatLogCollectionView.reloadData()
            self.scrollToBottom(animated: false)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.view.isUserInteractionEnabled = false
        guard let tabBarController = tabBarController as? OffroadTabBarController else { return }
        tabBarController.showTabBarAnimation()
        rootView.backgroundView.isHidden = false
        ORBCharacterChatManager.shared.endChat()
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
        rootView.userChatInputView.resignFirstResponder()
    }
    
}

extension CharacterChatLogViewController {
    
    //MARK: - @objc Func
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        guard !isKeyboardShown else { return }
        isKeyboardShown = true
        guard rootView.userChatInputView.isFirstResponder else { return }
        rootView.userChatBoundsView.isUserInteractionEnabled = true
        rootView.userChatView.isUserInteractionEnabled = true
        UIView.animate(withDuration: 0.5) { [weak self] in
            guard let self else { return }
            rootView.userChatBoundsView.bounds.origin.y = 0
            rootView.chatLogCollectionView.contentInsetAdjustmentBehavior = .never
            rootView.chatLogCollectionView.contentInset.bottom = rootView.keyboardLayoutGuide.layoutFrame.height + rootView.userChatView.frame.height + 16
            self.scrollToBottom(animated: false)
            rootView.layoutIfNeeded()
        }
    }
    
    @objc private func keyboardWillHide(notification: Notification) {
        guard isKeyboardShown else { return }
        isKeyboardShown = false
        rootView.userChatBoundsView.isUserInteractionEnabled = false
        rootView.userChatView.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.5) { [weak self] in
            guard let self else { return }
            rootView.userChatBoundsView.bounds.origin.y = -(rootView.safeAreaInsets.bottom + rootView.userChatView.frame.height)
            rootView.chatLogCollectionView.contentInsetAdjustmentBehavior = .automatic
            rootView.chatLogCollectionView.contentInset.bottom = 135
            rootView.layoutIfNeeded()
        }
    }
    
    @objc private func tapGestureHandler(_ sender: UITapGestureRecognizer) {
        rootView.userChatInputView.resignFirstResponder()
    }
    
    //MARK: - Private Func
    
    private func setupTargets() {
        rootView.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    private func setupDelegates() {
        rootView.chatLogCollectionView.dataSource = self
        rootView.chatLogCollectionView.delegate = self
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
        if cursor != nil { rootView.chatLogCollectionView.startScrollLoading(direction: .top) }
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
                
                if responseDTO.data.count == 0 {
                    self.didGetAllChatLog = true
                    rootView.chatLogCollectionView.stopScrollLoading(direction: .top)
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
        ORBCharacterChatManager.shared.shouldMakeKeyboardBackgroundTransparent
            .subscribe(onNext: { [weak self] isTransparent in
                guard let self else { return }
                guard self.rootView.keyboardBackgroundView.frame.height > rootView.safeAreaInsets.bottom else { return }
                self.rootView.keyboardBackgroundView.isHidden = isTransparent
            }).disposed(by: disposeBag)
        
        rootView.chatButton.rx.tap.bind(onNext: { [weak self] in
            guard let self else { return }
            self.rootView.userChatInputView.becomeFirstResponder()
        }).disposed(by: disposeBag)
        
        rootView.userChatInputView.rx.text.orEmpty
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .default))
            .subscribe(onNext: { [weak self] text in
                guard let self else { return }
                self.userChatInputViewTextInputViewHeightRelay.accept(self.rootView.userChatInputView.textInputView.bounds.height)
                if text.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
                    print("입력된 텍스트: \(text)")
                    self.rootView.loadingAnimationView.isHidden = false
                    self.rootView.loadingAnimationView.play()
                    self.isTextViewEmpty.accept(false)
                } else {
                    print("입력된 텍스트 없음")
                    self.rootView.loadingAnimationView.currentProgress = 0
                    self.rootView.loadingAnimationView.pause()
                    self.rootView.loadingAnimationView.isHidden = true
                    self.isTextViewEmpty.accept(true)
                }
            }).disposed(by: disposeBag)
        
        rootView.sendButton.rx.tap.bind(
            onNext: { [weak self] in
                guard let self else { return }
                let userMessage = self.rootView.userChatInputView.text
                self.rootView.sendButton.isEnabled = false
                // 사용자 채팅 버블 추가
                self.sendChatBubble(isUserChat: true, text: self.rootView.userChatInputView.text, isLoading: false) { [weak self] isFinished in
                    guard let self else { return }
                    // 캐릭터 셀 추가
                    self.sendChatBubble(isUserChat: false, text: "", isLoading: true) { [weak self] isFinished in
                        guard let self else { return }
                        self.postCharacterChat(characterId: characterId, message: userMessage!)
                    }
                }
                self.rootView.userChatInputView.text = ""
                
        }).disposed(by: disposeBag)
        
        userChatInputViewTextInputViewHeightRelay.subscribe(
            onNext: { [weak self] textContentHeight in
                guard let self else { return }
                if textContentHeight >= 30 {
                    self.updateChatInputViewHeight(height: (19.0*2) + (9.0*2))
                    UIView.animate(
                        withDuration: 0.3,
                        delay: 0,
                        usingSpringWithDamping: 1,
                        initialSpringVelocity: 1
                    ) { [weak self] in
                    guard let self else { return }
                    self.rootView.chatLogCollectionView.contentInset.bottom = self.rootView.keyboardLayoutGuide.layoutFrame.height + self.rootView.userChatView.frame.height + 16.0
                    self.scrollToBottom(animated: false)
                }
            } else {
                self.updateChatInputViewHeight(height: 19.0 + (9*2))
                UIView.animate(
                    withDuration: 0.3,
                    delay: 0,
                    usingSpringWithDamping: 1,
                    initialSpringVelocity: 1
                ) { [weak self] in
                    guard let self else { return }
                    self.rootView.chatLogCollectionView.contentInset.bottom = self.rootView.keyboardLayoutGuide.layoutFrame.height + self.rootView.userChatView.frame.height + 16.0
                    self.scrollToBottom(animated: false)
                }
            }
            self.rootView.updateConstraints()
            self.rootView.layoutIfNeeded()
        }).disposed(by: disposeBag)
        
        NetworkMonitoringManager.shared.networkConnectionChanged
            .subscribe(onNext: { [weak self] isConnected in
                guard let self else { return }
                if !isConnected {
                    showToast(message: ErrorMessages.networkError, inset: 66)
                }
            }).disposed(by: disposeBag)
        
        Observable.combineLatest(isCharacterResponding, isTextViewEmpty)
            .map { return (!$0 && !$1) }
            .subscribe { [weak self] shouldEnableSendButton in
                guard let self else { return }
                self.rootView.sendButton.isEnabled = shouldEnableSendButton
            }.disposed(by: disposeBag)
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
    
    private func scrollToBottom(animated: Bool) {
        guard let lastIndexPath = rootView.chatLogCollectionView.getIndexPathFromLast(index: 1) else { return }
        rootView.chatLogCollectionView.scrollToItem(at: lastIndexPath, at: .top, animated: animated)
    }
    
    private func updateChatInputViewHeight(height: CGFloat) {
        print(#function)
        userChatInputViewHeightAnimator.addAnimations { [weak self] in
            guard let self else { return }
            self.rootView.userChatInputViewHeightConstraint.constant = height
            self.rootView.layoutIfNeeded()
        }
        userChatInputViewHeightAnimator.startAnimation()
    }
    
    private func sendChatBubble(isUserChat: Bool, text: String, isLoading: Bool, completeion: ((Bool) -> Void)? = nil) {
        print(#function)
        let currentDate = Date()
        let indexPathToInsert: IndexPath
        var collectionViewUpdateClosure: ( () -> Void )? = nil
        
        // 채팅 로그가 있는 경우 (가장 최근 채팅 내역이 있는 경우)
        if let latestChatData = chatLogDataList.first {
            
            // 가장 마지막 채팅이 오늘인 경우 -> 기존 Section에 Item만 추가
            if viewModel.areDatesSameDay(latestChatData.createdDate!, currentDate) {
                // 추가하는 IndexPath: 마지막 섹션에 추가하는 Item
                indexPathToInsert = IndexPath(
                    item: self.chatLogDataSource.last!.count,
                    section: self.chatLogDataSource.count-1
                )
                collectionViewUpdateClosure = { [weak self] in
                    guard let self else { return }
                    self.rootView.chatLogCollectionView.insertItems(at: [indexPathToInsert])
                }
                
            // 가장 마지막 채팅이 오늘이 아닌 경우 -> 새로운 Section 추가 및 추가된 Section에 Item 추가
            } else {
                // 추가하는 IndexPath: 새로 추가되는 Section의 첫 번째 Item
                indexPathToInsert = IndexPath(item: 0, section: self.chatLogDataSource.count)
                collectionViewUpdateClosure = { [weak self] in
                    guard let self else { return }
                    self.rootView.chatLogCollectionView.insertSections(.init(integer: self.chatLogDataSource.count-1))
                    self.rootView.chatLogCollectionView.insertItems(at: [indexPathToInsert])
                }
            }
            
        } else {
            
            // 채팅 로그가 없는 경우 -> 새로운 Section과 Item 추가(IndexPath는 (0, 0))
            indexPathToInsert = IndexPath(item: 0, section: 0)
            collectionViewUpdateClosure = { [weak self] in
                guard let self else { return }
                self.rootView.chatLogCollectionView.insertSections(.init(integer: 0))
                self.rootView.chatLogCollectionView.insertItems(at: [indexPathToInsert])
            }
        }
        
        // performBatchUpdates 호출하기 전에 DataSource를 먼저 업데이트
        self.chatLogDataList.insert(
            ChatDataModel(role: isUserChat ? "USER" : "ORB_CHARACTER", content: text, createdData: currentDate, isLoading: isLoading),
            at: 0
        )
        
        // DataSource 업데이트 후 performBatchUpdates 호출
        self.rootView.chatLogCollectionView.performBatchUpdates(collectionViewUpdateClosure, completion: completeion)
        
        // collection view가 업데이트될 때마다 가징 최신의 채팅(가장 아래의 채팅)이 보여지도록 구현
        self.scrollToBottom(animated: true)
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
            self.scrollToBottom(animated: true)
            return
        }
        
        if chatSuccess {
            print("변경될 말풍선 내용(비어있어야함): \(chatLogDataSource[dataSourceSectionCount - 1][dataSourceLastSectionItemCount - 1].content)")
            if let characterResponse, chatLogDataList.count > 0 {
                chatLogDataList[0] = characterResponse
            }
            self.rootView.chatLogCollectionView.performBatchUpdates {
                self.rootView.chatLogCollectionView.reloadItems(at: [lastIndexPath])
            }
        } else {
            chatLogDataList.removeFirst(2)
            self.rootView.chatLogCollectionView.performBatchUpdates {
                self.rootView.chatLogCollectionView.deleteItems(at: [lastIndexPath, secondLastIndexPath])
                let lastSection = self.rootView.chatLogCollectionView.numberOfSections - 1
                if self.chatLogDataSource.count == 0 || self.chatLogDataSource.last?.count == 0 {
                    self.rootView.chatLogCollectionView.deleteSections([lastSection])
                }
            }
        }
        self.scrollToBottom(animated: false)
        showChatButton()
    }
    
    private func expandChatLogCollectionView() {
        let previousSectionCount = self.rootView.chatLogCollectionView.numberOfSections
        let previousFirstSectionItemsCount = self.rootView.chatLogCollectionView.numberOfItems(inSection: 0)
        isScrollLoading = true
        self.updateChatLogDataSource(characterId: characterId, limit: 14, cursor: lastCursor) { [weak self] in
            guard let self else { return }
            
            let newSectionCount = self.chatLogDataSource.count
            let sectionCountDifference = newSectionCount - previousSectionCount
            
            var sectionsToInsert: [Int] = []
            var indexPathsToInsert:[IndexPath] = []
            var collectionViewUpdateClosure: ( () -> Void )? = nil
            
            // 추가되는 섹션이 없을 경우
            if sectionCountDifference == 0 {
                // 첫 번째 섹션에서 추가되는 item 수
                let itemDifference = self.chatLogDataSource[0].count - previousFirstSectionItemsCount
                
                for i in 0..<itemDifference {
                    indexPathsToInsert.append(IndexPath(item: i, section: 0))
                }
                collectionViewUpdateClosure = { [weak self] in
                    guard let self else { return }
                    self.rootView.chatLogCollectionView.insertItems(at: indexPathsToInsert)
                }
                
            } else if sectionCountDifference > 0 {
                for sectionIndex in 0...sectionCountDifference {
                    if sectionIndex != sectionCountDifference {
                        sectionsToInsert.append(sectionIndex)
                    }
                    // 기존에 존재하던 Section인 경우 (기존에 존재하던 Section의 item 수의 차이만큼 추가)
                    if sectionIndex == sectionCountDifference {
                        let itemDifferece = self.chatLogDataSource[sectionIndex].count - previousFirstSectionItemsCount
                        for i in 0..<itemDifferece {
                            indexPathsToInsert.append(IndexPath(item: i, section: sectionIndex))
                        }
                    }
                    /*
                     새로 추가되는 Section인 경우 DataSource를 바탕으로 item의 갯수 자동으로 계산됨.
                     (별도 insertItems 작업 필요 없음.)
                     */
                }
                
                collectionViewUpdateClosure = { [weak self] in
                    guard let self else { return }
                    self.rootView.chatLogCollectionView.insertSections(IndexSet(sectionsToInsert))
                    self.rootView.chatLogCollectionView.insertItems(at: indexPathsToInsert)
                }
                
            } else {
                // 인터넷 재접속으로 인해 새로고침 된 경우
                // 별도 조치 없음. (헷갈릴 것 같아 주석으로 남겨놓음.
            }
            
            UIView.animate(withDuration: 0, animations: { [weak self] in
                guard let self else { return }
                self.rootView.chatLogCollectionView.performBatchUpdates(collectionViewUpdateClosure)
            }, completion: { [weak self] isFinished in
                guard let self else { return }
                self.isScrollLoading = false
            })
        }
    }
    
    
}

//MARK: - UICollectionViewDataSource

extension CharacterChatLogViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        chatLogDataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        chatLogDataSource[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterChatLogCell.className, for: indexPath) as? CharacterChatLogCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: chatLogDataSource[indexPath.section][indexPath.item], characterName: self.characterName)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader, let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: CharacterChatLogHeader.className,
            for: indexPath
        ) as? CharacterChatLogHeader else { return UICollectionReusableView() }
        let dateString = chatLogDataSource[indexPath.section].first?.formattedDateString ?? ""
        header.dateLabel.text = dateString
        return header
    }
    
}

//MARK: - UIScrollViewDelegate

extension CharacterChatLogViewController: UIScrollViewDelegate {
    
    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        rootView.userChatInputView.resignFirstResponder()
        isScrollingToTop = true
        return true
    }
    
    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        print(#function)
        isScrollingToTop = false
    }
    
    func scrollViewWillEndDragging(
        _ scrollView: UIScrollView,
        withVelocity velocity: CGPoint,
        targetContentOffset: UnsafeMutablePointer<CGPoint>
    ) {
        // 무한스크롤 발동 조건
        if targetContentOffset.pointee.y <= 0 && !isScrollLoading && !didGetAllChatLog && !isScrollingToTop {
            expandChatLogCollectionView()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 채팅하기 버튼 숨김 여부
        if scrollView.contentSize.height > 0 {
            let scrollOffsetAtBottomEdge =
            max(scrollView.contentSize.height - (scrollView.bounds.height - rootView.safeAreaInsets.bottom - 135), 0)
            
            if ceil(scrollView.contentOffset.y) >= (scrollOffsetAtBottomEdge - 20) {
                showChatButton()
            } else {
                hideChatButton()
            }
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
