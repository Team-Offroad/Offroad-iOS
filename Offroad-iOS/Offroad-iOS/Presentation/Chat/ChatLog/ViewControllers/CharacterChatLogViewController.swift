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
    private let rootView: CharacterChatLogView
    private var chatLogDataList: [ChatDataModel] = []
    private var chatLogDataSource: [[ChatDataModel]] = [[]]
    private var isChatButtonHidden: Bool = true
    /// 채팅 중에 채팅 로그 뷰 진입 시 키보드가 내려가는데, 이때 keyboardWillHide() 메서드가 불리지 않게 하기 위해 사용하는 flag.
    ///
    /// 채팅 중에 채팅 로그 뷰에 진입하면 키보드가 내려가는 경우 `keyboardWillHide()`가 불리게 되는데, 이때
    /// `rootView.safeAreaInsets.bottom` 와 `rootView.userChatView.frame.height`가 0 이어서 사용자 입력창이 보이게 되는 현상 발생함.
    private var isKeyboardShown: Bool = false
    
    // userChatInputView의 textInputView의 height를 전달
    let userChatInputViewTextInputViewHeightRelay = PublishRelay<CGFloat>()
    let userChatInputViewHeightAnimator = UIViewPropertyAnimator(duration: 0.3, dampingRatio: 1)
    let isCharacterResponding = BehaviorRelay<Bool>(value: false)
    let isTextViewEmpty = BehaviorRelay<Bool>(value: true)
    
    var disposeBag = DisposeBag()
    var characterName: String
    
    //MARK: - Life Cycle
    
    init(background: UIView, characterName: String) {
        self.rootView = CharacterChatLogView(background: background, characterName: characterName)
        self.characterName = characterName
        super.init(nibName: nil, bundle: nil)
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
        requestChatLogDataSource()
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
    
    private func requestChatLogDataSource() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.view.startLoading()
        }
        NetworkService.shared.characterChatService.getChatLog(completion: { [weak self] result in
            guard let self else { return }
            self.view.stopLoading()
            switch result {
            case .success(let responseDTO):
                guard let responseDTO else {
                    showToast(message: "responseDTO가 없습니다.", inset: 66)
                    return
                }
                chatLogDataList = responseDTO.data.map({ ChatDataModel(data: $0) })
                chatLogDataSource = viewModel.groupChatsByDate(chats: chatLogDataList)
                rootView.chatLogCollectionView.reloadData()
                self.scrollToBottom(animated: false)
                showChatButton()
            case .networkFail:
                showToast(message: ErrorMessages.networkError, inset: 66)
            case .decodeErr:
                showToast(message: "디코딩 에러.", inset: 66)
            default:
                self.showToast(message: "Something went wrong", inset: 60)
            }
        })
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
                self.postCharacterChat(message: self.rootView.userChatInputView.text)
                self.rootView.sendButton.isEnabled = false
                // 사용자 채팅 버블 추가
                self.sendChatBubble(isUserChat: true, text: self.rootView.userChatInputView.text) { [weak self] isFinished in
                    guard let self else { return }
                    // 캐릭터 셀 추가
                    self.sendChatBubble(isUserChat: false, text: "")
                    // 추가된 캐릭터 셀 로딩 시작
                    makeLastCellLoading()
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
                if isConnected {
                    self.requestChatLogDataSource()
                } else {
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
        let numberOfSections = rootView.chatLogCollectionView.numberOfSections
        let numberOfItemsInLastSection = rootView.chatLogCollectionView.numberOfItems(inSection: numberOfSections-1)
        let lastIndexPath = IndexPath(item: numberOfItemsInLastSection-1, section: numberOfSections-1)
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
    
    private func sendChatBubble(isUserChat: Bool, text: String, completeion: ((Bool) -> Void)? = nil) {
        let currentDate = Date()
        let indexPathToInsert: IndexPath
        var collectionViewUpdateClosure: ( () -> Void )? = nil
        
        // 채팅 로그가 있는 경우
        if let latestChatData = chatLogDataList.last {
            
            // 가장 마지막 채팅이 오늘인 경우 -> 기존 Section에 Item만 추가
            if viewModel.areDatesSameDay(latestChatData.createdDate!, currentDate) {
                // 추가하는 IndexPath: 마지막 섹션에 추가하는 Item
                indexPathToInsert = IndexPath(
                    item: self.chatLogDataSource.last!.count,
                    section: self.chatLogDataSource.count-1
                )
                collectionViewUpdateClosure = { [weak self] in
                    guard let self else { return }
                    self.rootView.chatLogCollectionView.collectionViewLayout.invalidateLayout()
                    self.rootView.chatLogCollectionView.insertItems(at: [indexPathToInsert])
                }
                
            // 가장 마지막 채팅이 오늘이 아닌 경우 -> 새로운 Section 추가 및 추가된 Section에 Item 추가
            } else {
                // 추가하는 IndexPath: 새로 추가되는 Section의 첫 번째 Item
                indexPathToInsert = IndexPath(item: 0, section: self.chatLogDataSource.count)
                collectionViewUpdateClosure = { [weak self] in
                    guard let self else { return }
                    self.rootView.chatLogCollectionView.collectionViewLayout.invalidateLayout()
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
        self.chatLogDataList.append(
            ChatDataModel(role: isUserChat ? "USER" : "ORB_CHARACTER", content: text, createdData: currentDate)
        )
        self.chatLogDataSource = self.viewModel.groupChatsByDate(chats: self.chatLogDataList)
        
        // DataSource 업데이트 후 performBatchUpdates 호출
        self.rootView.chatLogCollectionView.performBatchUpdates(collectionViewUpdateClosure, completion: completeion)
        
        // collection view가 업데이트될 때마다 가징 최신의 채팅(가장 아래의 채팅)이 보여지도록 구현
        self.scrollToBottom(animated: true)
    }
    
    private func makeLastCellLoading() {
        let lastSection = chatLogDataSource.count - 1
        let lastSectionCount = chatLogDataSource[lastSection].count
        let lastIndexPath = IndexPath(
            item: lastSectionCount-1,
            section: lastSection
        )
        chatLogDataSource[lastIndexPath.section][lastIndexPath.item].isLoading = true
        chatLogDataSource[lastIndexPath.section][lastIndexPath.item].content = " "
        rootView.chatLogCollectionView.performBatchUpdates {
            rootView.chatLogCollectionView.reloadItems(at: [lastIndexPath])
            rootView.chatLogCollectionView.collectionViewLayout.invalidateLayout()
        }
    }
    
    private func postCharacterChat(message: String) {
        isCharacterResponding.accept(true)
        let dto = CharacterChatPostRequestDTO(content: message)
        NetworkService.shared.characterChatService.postChat(body: dto) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let dto):
                guard dto != nil else {
                    self.showToast(message: "requestDTO is nil", inset: 66)
                    return
                }                
                self.updateChatLog()
                
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
    
    private func updateChatLog(chatSuccess: Bool = true) {
        NetworkService.shared.characterChatService.getChatLog(completion: { [weak self] result in
            guard let self else { return }
            self.tabBarController?.view.stopLoading()
            switch result {
            case .success(let responseDTO):
                guard let responseDTO else {
                    showToast(message: "responseDTO가 없습니다.", inset: 66)
                    return
                }
                self.chatLogDataList = responseDTO.data.map({ ChatDataModel(data: $0) })
                
                let lastSection = chatLogDataSource.count - 1
                let lastSectionCount = chatLogDataSource[lastSection].count
                let lastIndexPath = IndexPath(
                    item: lastSectionCount-1,
                    section: lastSection
                )
                let secondLastIndexPath = IndexPath(
                    item: lastSectionCount-2,
                    section: lastSection
                )
                // 채팅이 실패하여 collectionView의 item을 삭제해야 하는 경우,
                // 아래 collectionView에서 performBatchUpdates 시에, dataSource에서 사라진 indexPath를 참조하여 deleteItems 해야 하므로,
                // dataSource 업데이트 전 lastIndexPath와 secondLastIndexPath를 상수로 저장한 후 dataSource 업데이트해야 함.
                self.chatLogDataSource = viewModel.groupChatsByDate(chats: chatLogDataList)
                
                if chatSuccess {
                    self.rootView.chatLogCollectionView.performBatchUpdates {
                        self.rootView.chatLogCollectionView.reloadItems(at: [lastIndexPath])
                    }
                } else {
                    self.rootView.chatLogCollectionView.performBatchUpdates {
                        self.rootView.chatLogCollectionView.deleteItems(at: [lastIndexPath, secondLastIndexPath])
                    }
                }
                self.scrollToBottom(animated: false)
                showChatButton()
            case .networkFail:
                showToast(message: ErrorMessages.networkError, inset: 66)
            case .decodeErr:
                showToast(message: "디코딩 에러.", inset: 66)
            default:
                self.showToast(message: "Something went wrong", inset: 60)
            }
        })
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

//MARK: - UICollectionViewDelegate

extension CharacterChatLogViewController: UICollectionViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView.contentSize.height > 0 else { return }
        let scrollOffsetAtBottomEdge =
        max(scrollView.contentSize.height - (scrollView.bounds.height - rootView.safeAreaInsets.bottom - 135), 0)
        
        if ceil(scrollView.contentOffset.y) >= scrollOffsetAtBottomEdge {
            showChatButton()
        } else {
            hideChatButton()
        }
    }
    
    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        rootView.userChatInputView.resignFirstResponder()
        return true
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
