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
    
    // userChatInputView의 textInputView의 height를 전달
    let userChatInputViewTextInputViewHeightRelay = PublishRelay<CGFloat>()
    let userChatInputViewHeightAnimator = UIViewPropertyAnimator(duration: 0.3, dampingRatio: 1)
    
    var disposeBag = DisposeBag()
    var characterName: String
    
    //MARK: - Life Cycle
    
    init(background: UIView, characterName: String) {
        self.rootView = CharacterChatLogView(background: background)
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
        requestChatLogDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let tabBarController = tabBarController as? OffroadTabBarController else { return }
        tabBarController.showTabBarAnimation()
        rootView.backgroundView.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        rootView.backgroundView.isHidden = false
        guard let tabBarController = tabBarController as? OffroadTabBarController else { return }
        tabBarController.enableTabBarInteraction()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        rootView.backgroundView.isHidden = true
        rootView.endEditing(true)
    }
    
}

extension CharacterChatLogViewController {
    
    //MARK: - @objc Func
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        guard rootView.userChatInputView.isFirstResponder else { return }
        rootView.userChatBoundsView.isUserInteractionEnabled = true
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
        rootView.userChatBoundsView.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.5) { [weak self] in
            guard let self else { return }
            rootView.userChatBoundsView.bounds.origin.y = -(rootView.safeAreaInsets.bottom + rootView.userChatView.frame.height)
            rootView.chatLogCollectionViewBottomConstraint.constant = 0
            rootView.chatLogCollectionView.contentInsetAdjustmentBehavior = .automatic
            rootView.chatLogCollectionView.contentInset.bottom = 135
            rootView.layoutIfNeeded()
        }
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
    
    private func requestChatLogDataSource() {
        tabBarController?.view.startLoading()
        NetworkService.shared.characterChatService.getChatLog(completion: { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let responseDTO):
                guard let responseDTO else {
                    showToast(message: "responseDTO가 없습니다.", inset: 66)
                    return
                }
                self.tabBarController?.view.stopLoading()
                chatLogDataList = responseDTO.data.map({ ChatDataModel(data: $0) })
                chatLogDataSource = viewModel.groupChatsByDate(chats: chatLogDataList)
                rootView.chatLogCollectionView.reloadData()
                self.scrollToBottom(animated: false)
                showChatButton()
            case .networkFail:
                showToast(message: "네트워크 연결 상태를 확인해주세요.", inset: 66)
            case .decodeErr:
                showToast(message: "디코딩 에러.", inset: 66)
            default:
                self.showToast(message: "Something went wrong", inset: 60)
            }
        })
    }
    
    private func bindData() {
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
                    self.rootView.sendButton.isEnabled = true
                } else {
                    print("입력된 텍스트 없음")
                    self.rootView.loadingAnimationView.currentProgress = 0
                    self.rootView.loadingAnimationView.pause()
                    self.rootView.loadingAnimationView.isHidden = true
                    self.rootView.sendButton.isEnabled = false
                }
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
}

//MARK: - UICollectionViewDataSource

extension CharacterChatLogViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        chatLogDataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        chatLogDataList.count
        chatLogDataSource[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterChatLogCell.className, for: indexPath) as? CharacterChatLogCell else {
            return UICollectionViewCell()
        }
//        cell.configure(with: chatLogDataList[indexPath.item], characterName: self.characterName)
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
        
        if scrollView.contentOffset.y >= scrollOffsetAtBottomEdge {
            showChatButton()
        } else {
            hideChatButton()
        }
    }
    
    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        rootView.endEditing(true)
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
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        .init(width: UIScreen.currentScreenSize.width, height: 50)
//    }
    
}
