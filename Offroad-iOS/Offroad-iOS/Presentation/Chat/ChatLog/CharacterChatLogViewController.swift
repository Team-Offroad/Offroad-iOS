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
    
    private let chatButtonHidingAnimator = UIViewPropertyAnimator(duration: 0.5, dampingRatio: 1)
    private let rootView: CharacterChatLogView
    private var chatLogDataList: [ChatData] = []
    private var chatLogDataSource: [ChatDataModel] = []
    private var isChatButtonHidden: Bool = true
    var disposeBag = DisposeBag()
    var characterName: String
    
    //MARK: - Life Cycle
    
    init(background: UIView, characterName: String) {
        self.rootView = CharacterChatLogView(background: background)
        self.characterName = characterName
        super.init(nibName: nil, bundle: nil)
        requestChatLogDataSource()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { }
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
        NetworkService.shared.characterChatService.getChatLog(completion: { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let responseDTO):
                guard let responseDTO else {
                    showToast(message: "responseDTO가 없습니다.", inset: 66)
                    return
                }
                chatLogDataSource = responseDTO.data.map({ ChatDataModel(data: $0) })
                rootView.chatLogCollectionView.reloadData()
                self.scrollToBottom(animated: false)
                rootView.chatLogCollectionView.collectionViewLayout.invalidateLayout()
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
        
        rootView.userChatInputView.rx.text.orEmpty.subscribe { inputText in
            print("inputText: \(inputText)")
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
    
    // UILabel 안에 특정 텍스트가 들어갔을 때, label의 사이즈를 미리 계산하는 식
    // (셀을 직접 그리기 전에 셀의 높이를 동적으로 계산하여 flowLayout에서 이를 바탕으로 layout계산해야 하기 때문.)
    // 채팅 내용에 따라 텍스트의 높이가 달라지기 때문에 특정 텍스트일 때 채팅 버블의 높이를 미리 계산하기 위함.
    private func calculateTextSize(text: String, font: UIFont, maxSize: CGSize) -> CGSize {
        // 텍스트 속성 설정
        let attributes: [NSAttributedString.Key: Any] = [.font: font]
        // 제한된 너비를 설정한 CGRect
        let maxSize = maxSize
        // boundingRect 계산
        let boundingBox = text.boundingRect(
            with: maxSize,
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: attributes,
            context: nil
        )
        return CGSize(width: ceil(boundingBox.width), height: ceil(boundingBox.height))
    }
}

//MARK: - UICollectionViewDataSource

extension CharacterChatLogViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        chatLogDataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterChatLogCell.className, for: indexPath) as? CharacterChatLogCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: chatLogDataSource[indexPath.item], characterName: self.characterName)
        return cell
    }
    
}

//MARK: - UICollectionViewDelegate

extension CharacterChatLogViewController: UICollectionViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView.contentSize.height > 0 else { return }
        let scrollOffsetAtBottomEdge =
        max(scrollView.contentSize.height - (scrollView.bounds.height - rootView.safeAreaInsets.bottom - 135), 0)
        
//        print("contentSize: \(scrollView.contentSize)")
//        print("bottomInset: \(scrollView.contentInset.bottom)")
        print("contentOffset: \(scrollView.contentOffset)")
        print("contentOffsetAtBottomEdge: \(scrollOffsetAtBottomEdge)")
        
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
        
        let characterNameLabelSize: CGSize = calculateTextSize(text: characterName, font: .offroad(style: .iosTextBold), maxSize: .init(width: 200, height: 24))
        let timeLabelSize: CGSize = calculateTextSize(text: chatLogDataSource[indexPath.item].formattedDateString, font: .offroad(style: .iosTextContentsSmall), maxSize: .init(width: 100, height: 14))
        let maxMessageLabelWidth: CGFloat
        
        if chatLogDataSource[indexPath.item].role == "USER" {
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
        let messageLabelSize = calculateTextSize(text: chatLogDataSource[indexPath.item].content, font: .offroad(style: .iosText), maxSize: .init(width: maxMessageLabelWidth, height: 400))
        return CGSize(width: UIScreen.currentScreenSize.width, height: messageLabelSize.height + (14*2))
    }
    
}
