//
//  ORBCharacterChatViewController.swift
//  Offroad-iOS
//
//  Created by 김민성 on 11/7/24.
//

import UIKit

import RxSwift
import RxCocoa

class ORBCharacterChatViewController: UIViewController {
    
    //MARK: - Properties
    
    var isCharacterChatBoxShown: Bool = false
    var isUserChatInputViewShown: Bool = false
    
    var disposeBag = DisposeBag()
    let rootView = ORBCharacterChatView()
    
    // userChatInputView의 textInputView의 height를 전달
    let userChatInputViewTextInputViewHeightRelay = PublishRelay<CGFloat>()
    // userChatDisplayView의 textInputVie의 height를 전달
    let userChatDisplayViewTextInputViewHeightRelay = PublishRelay<CGFloat>()
    let isCharacterResponding = BehaviorRelay<Bool>(value: false)
    let isTextViewEmpty = BehaviorRelay<Bool>(value: true)
    let patchChatReadRelay = PublishRelay<Void>()
    
    let characterChatBoxPositionAnimator = UIViewPropertyAnimator(duration: 0.5, dampingRatio: 1)
    let characterChatBoxModeChangingAnimator = UIViewPropertyAnimator(duration: 0.4, dampingRatio: 1)
    let userChatViewAnimator = UIViewPropertyAnimator(duration: 0.5, dampingRatio: 1)
    let userChatInputViewHeightAnimator = UIViewPropertyAnimator(duration: 0.3, dampingRatio: 1)
    let userChatDisplayViewHeightAnimator = UIViewPropertyAnimator(duration: 0.3, dampingRatio: 1)
    
    lazy var panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureHandler))
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNotifications()
        bindData()
        setupGestures()
        setupTargets()
    }
    
}

extension ORBCharacterChatViewController {
    
    //MARK: - @objc Func
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard rootView.userChatInputView.isFirstResponder, !isUserChatInputViewShown else { return }
        rootView.layoutIfNeeded()
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRect = keyboardFrame.cgRectValue
            isUserChatInputViewShown = true
            updateChatInputViewPosition(bottomInset: keyboardRect.height)
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        hideUserChatInputView()
    }
    
    @objc private func panGestureHandler(sender: UIPanGestureRecognizer) {
        let hasReplyButton = rootView.characterChatBox.mode == .withReplyButtonShrinked
        || rootView.characterChatBox.mode == .withReplyButtonExpanded
        switch sender.state {
        case .possible, .began:
            return
        case .changed:
            let verticalPosition = sender.translation(in: rootView).y
            if verticalPosition < 0, hasReplyButton {
                let transform = CGAffineTransform(translationX: 0, y: verticalPosition)
                rootView.characterChatBox.transform = transform
                
            } else if verticalPosition < 0, !hasReplyButton {
                let maximumDragDistance: CGFloat = 15
                let transform = CGAffineTransform(translationX: 0, y: -maximumDragDistance * (1 - exp(-0.5 * -verticalPosition / maximumDragDistance)))
                rootView.characterChatBox.transform = transform
                
            } else if verticalPosition > 0 {
                let maximumDragDistance: CGFloat = hasReplyButton ? 60 : 15
                let transform = CGAffineTransform(translationX: 0, y: maximumDragDistance * (1 - exp(-0.5 * verticalPosition / maximumDragDistance)))
                rootView.characterChatBox.transform = transform
                
            }
        case .ended, .cancelled, .failed:
            if sender.velocity(in: rootView).y < -100, hasReplyButton {
                hideCharacterChatBox()
            } else {
                showCharacterChatBox()
            }
        @unknown default:
            rootView.characterChatBox.transform = CGAffineTransform.identity
        }
    }
    
    @objc private func shrinkChatBox() {
        rootView.characterChatBox.shrink()
    }
    
    @objc private func touchUpOutside(event: UIControl.Event) {
        rootView.characterChatBox.expand()
    }
    
    @objc private func touchUpInside() {
        rootView.characterChatBox.expand()
        guard rootView.characterChatBox.mode != .loading else { return }
        ORBCharacterChatManager.shared.shouldPushCharacterChatLogViewController
            .onNext(MyInfoManager.shared.representativeCharacterID ?? 1)
    }
    
    //MARK: - Private Func
    
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
    
    private func calculateLabelSize(text: String, font: UIFont, maxSize: CGSize) -> CGSize {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = font
        label.text = text
        
        // 너비를 제한한 크기 계산
        let fittingSize = label.sizeThatFits(CGSize(width: maxSize.width, height: maxSize.height))

        // 결과 출력
        return fittingSize
    }
    
    private func bindData() {
        ORBCharacterChatManager.shared.shouldMakeKeyboardBackgroundTransparent
            .subscribe(onNext: { [weak self] isTransparent in
                guard let self else { return }
                self.rootView.keyboardBackgroundView.isHidden = isTransparent
            }).disposed(by: disposeBag)
        
        rootView.characterChatBox.chevronImageButton.rx.tap.bind { [weak self] in
            guard let self else { return }
            if self.rootView.characterChatBox.mode == .withReplyButtonShrinked {
                self.changeChatBoxMode(to: .withReplyButtonExpanded, animated: true)
            } else if self.rootView.characterChatBox.mode == .withReplyButtonExpanded {
                self.changeChatBoxMode(to: .withReplyButtonShrinked, animated: true)
            } else if self.rootView.characterChatBox.mode == .withoutReplyButtonShrinked {
                self.changeChatBoxMode(to: .withoutReplyButtonExpanded, animated: true)
            } else if self.rootView.characterChatBox.mode == .withoutReplyButtonExpanded {
                self.changeChatBoxMode(to: .withoutReplyButtonShrinked, animated: true)
            }
        }.disposed(by: disposeBag)
        
        rootView.characterChatBox.replyButton.rx.tap.bind { [weak self] in
            guard let self else { return }
            self.rootView.window?.makeKeyAndVisible()
            if self.rootView.userChatInputView.becomeFirstResponder() {
                self.patchChatReadRelay.accept(())
            }
            self.rootView.characterChatBox.isHidden = false
            self.rootView.userChatView.isHidden = false
            self.rootView.endChatButton.isHidden = false
            self.changeChatBoxMode(to: .withoutReplyButtonExpanded, animated: true)
        }.disposed(by: disposeBag)
        
        rootView.sendButton.rx.tap.bind { [weak self] in
            guard let self else { return }
            self.postCharacterChat(message: self.rootView.userChatInputView.text)
            // 로티 뜨도록 구현
            self.configureCharacterChatBox(character: MyInfoManager.shared.representativeCharacterName ?? "", message: "", mode: .loading, animated: true)
            self.showCharacterChatBox()
            self.rootView.userChatDisplayView.text = self.rootView.userChatInputView.text.trimmingCharacters(in: .whitespacesAndNewlines)
            self.rootView.userChatDisplayView.bounds.origin.y = -(self.rootView.userChatDisplayView.bounds.height)
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1) {
                self.rootView.userChatDisplayView.bounds.origin.y = 0
                self.rootView.layoutIfNeeded()
            }
            self.rootView.userChatInputView.text = ""
        }.disposed(by: disposeBag)
        
        rootView.endChatButton.rx.tap.bind { [weak self] in
            guard let self else { return }
            print("채팅을 종료합니다.")
            self.rootView.userChatInputView.resignFirstResponder()
            self.hideUserChatInputView()
            self.rootView.userChatInputView.text = ""
            self.rootView.userChatDisplayView.text = ""
            hideCharacterChatBox()
        }.disposed(by: disposeBag)
        
        rootView.userChatInputView.rx.text.orEmpty
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .default))
            .subscribe(onNext: { [weak self] text in
                guard let self else { return }
                self.userChatInputViewTextInputViewHeightRelay.accept(self.rootView.userChatInputView.textInputView.bounds.height)
                if text.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
                    print("입력된 텍스트: \(text)")
                    self.rootView.userChatDisplayView.isHidden = true
                    self.rootView.loadingAnimationView.isHidden = false
                    self.rootView.loadingAnimationView.play()
                    self.isTextViewEmpty.accept(false)
                    self.updateChatDisplayViewHeight(height: 20)
                } else {
                    print("입력된 텍스트 없음")
                    userChatDisplayViewTextInputViewHeightRelay.accept(rootView.userChatDisplayView.textInputView.frame.height)
                    self.rootView.userChatDisplayView.isHidden = false
                    self.rootView.loadingAnimationView.currentProgress = 0
                    self.rootView.loadingAnimationView.pause()
                    self.rootView.loadingAnimationView.isHidden = true
                    self.isTextViewEmpty.accept(true)
                }
            }).disposed(by: disposeBag)
        
        userChatInputViewTextInputViewHeightRelay.subscribe(onNext: { [weak self] textContentHeight in
            guard let self else { return }
            if textContentHeight >= 30 {
                self.updateChatInputViewHeight(height: (19.0*2) + (9.0*2))
            } else {
                self.updateChatInputViewHeight(height: 19.0 + (9*2))
            }
            self.rootView.updateConstraints()
            self.rootView.layoutIfNeeded()
        }).disposed(by: disposeBag)
        
        rootView.userChatDisplayView.rx.text.orEmpty.subscribe(onNext: { [weak self] text in
            guard let self else { return }
            self.userChatDisplayViewTextInputViewHeightRelay.accept(self.rootView.userChatDisplayView.textInputView.frame.height)
        }).disposed(by: disposeBag)
        
        userChatDisplayViewTextInputViewHeightRelay.subscribe(onNext: { [weak self] textContentHeight in
            guard let self else { return }
            if textContentHeight >= 30 {
                self.updateChatDisplayViewHeight(height: 40)
            } else {
                self.updateChatDisplayViewHeight(height: 20)
            }
            self.rootView.updateConstraints()
            self.rootView.layoutIfNeeded()
        }).disposed(by: disposeBag)
        
        patchChatReadRelay.subscribe(onNext: {
            NetworkService.shared.characterChatService.patchChatRead { [weak self] networkResult in
                guard let self else { return }
                switch networkResult {
                case .success: return
                default: self.showToast(message: ErrorMessages.networkError, inset: 66)
                }
            }
        }).disposed(by: disposeBag)
        
        Observable.combineLatest(isCharacterResponding, isTextViewEmpty)
            .map { return (!$0 && !$1) }
            .subscribe { [weak self] shouldEnableSendButton in
                guard let self else { return }
                self.rootView.sendButton.isEnabled = shouldEnableSendButton
            }.disposed(by: disposeBag)
    }
    
    private func setupGestures() {
        panGesture.delegate = self
        rootView.characterChatBox.addGestureRecognizer(panGesture)
    }
    
    private func setupTargets() {
        rootView.characterChatBox.addTarget(self, action: #selector(shrinkChatBox), for: [.touchDown])
        rootView.characterChatBox.addTarget(self, action: #selector(touchUpOutside), for: [.touchUpOutside, .touchCancel])
        rootView.characterChatBox.addTarget(self, action: #selector(touchUpInside), for: .touchUpInside)
    }
    
    private func postCharacterChat(characterId: Int? = nil, message: String) {
        isCharacterResponding.accept(true)
        let dto = CharacterChatPostRequestDTO(content: message)
        NetworkService.shared.characterChatService.postChat(characterId: characterId, body: dto) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let dto):
                guard let dto else {
                    self.showToast(message: "requestDTO is nil", inset: 66)
                    return
                }
                let characterChatResponse = dto.data.content
                self.configureCharacterChatBox(character: MyInfoManager.shared.representativeCharacterName ?? "", message: characterChatResponse, mode: .withoutReplyButtonShrinked, animated: true)
            case .requestErr:
                self.showToast(message: "requestError occurred", inset: 66)
                self.hideCharacterChatBox()
            case .unAuthentication:
                self.showToast(message: "unAuthentication Error occurred", inset: 66)
                self.hideCharacterChatBox()
            case .unAuthorization:
                self.showToast(message: "unAuthorized Error occurred", inset: 66)
                self.hideCharacterChatBox()
            case .apiArr:
                self.showToast(message: "api Error occurred", inset: 66)
                self.hideCharacterChatBox()
            case .pathErr:
                self.showToast(message: "path Error occurred", inset: 66)
                self.hideCharacterChatBox()
            case .registerErr:
                self.showToast(message: "register Error occurred", inset: 66)
                self.hideCharacterChatBox()
            case .networkFail:
                self.showToast(message: ErrorMessages.networkError, inset: 66)
                self.hideCharacterChatBox()
            case .serverErr:
                self.showToast(message: "오브가 답변하기 힘든 질문이예요.\n다른 이야기를 해볼까요?", inset: 66)
                self.hideCharacterChatBox()
            case .decodeErr:
                self.showToast(message: "decode Error occurred", inset: 66)
                self.hideCharacterChatBox()
            }
            self.isCharacterResponding.accept(false)
        }
    }
    
    //MARK: - Func
    
    func showCharacterChatBox() {
        isCharacterChatBoxShown = true
        rootView.layoutIfNeeded()
        characterChatBoxPositionAnimator.stopAnimation(true)
        characterChatBoxPositionAnimator.addAnimations { [weak self] in
            guard let self else { return }
            // pagGesture로 변경된 (세로)위치 원상복구
            self.rootView.characterChatBox.transform = CGAffineTransform.identity
            self.rootView.characterChatBoxTopConstraint.constant = view.safeAreaInsets.top + 27
            self.rootView.layoutIfNeeded()
        }
        characterChatBoxPositionAnimator.startAnimation()
    }
    
    func hideCharacterChatBox() {
        isCharacterChatBoxShown = false
        characterChatBoxPositionAnimator.stopAnimation(true)
        characterChatBoxPositionAnimator.addAnimations { [weak self] in
            guard let self else { return }
            // pagGesture로 변경된 (세로)위치 원상복구
            self.rootView.characterChatBox.transform = CGAffineTransform.identity
            self.rootView.characterChatBoxTopConstraint.constant
            = -self.rootView.characterChatBox.frame.height
            self.rootView.layoutIfNeeded()
        }
        characterChatBoxPositionAnimator.addCompletion { [weak self] _ in
            guard let self else { return }
            self.rootView.characterChatBox.characterNameLabel.text = ""
            self.rootView.characterChatBox.loadingAnimationView.stop()
            self.rootView.characterChatBox.loadingAnimationView.isHidden = true
            self.rootView.characterChatBox.messageLabel.isHidden = false
            self.rootView.characterChatBox.messageLabel.text = ""
        }
        characterChatBoxPositionAnimator.startAnimation()
    }
    
    func hideUserChatInputView() {
        rootView.layoutIfNeeded()
        guard isUserChatInputViewShown else { return }
        let inputViewHeight = rootView.userChatView.frame.height
        isUserChatInputViewShown = false
        // 48: 채팅 종료 버튼과 그 아래의 padding 값의 합
        updateChatInputViewPosition(bottomInset: -(48 + inputViewHeight))
    }
    
    func updateChatInputViewPosition(bottomInset: CGFloat) {
        userChatViewAnimator.stopAnimation(true)
        rootView.layoutIfNeeded()
        userChatViewAnimator.addAnimations { [weak self] in
            guard let self else { return }
            self.rootView.userChatViewBottomConstraint.constant = -bottomInset
            self.rootView.layoutIfNeeded()
        }
        userChatViewAnimator.startAnimation()
    }
    
    func updateChatInputViewHeight(height: CGFloat) {
        print(#function)
        userChatInputViewHeightAnimator.addAnimations { [weak self] in
            guard let self else { return }
            self.rootView.userChatInputViewHeightConstraint.constant = height
            self.rootView.layoutIfNeeded()
        }
        userChatInputViewHeightAnimator.startAnimation()
    }
    
    func updateChatDisplayViewHeight(height: CGFloat) {
        userChatDisplayViewHeightAnimator.addAnimations { [weak self] in
            guard let self else { return }
            self.rootView.userChatDisplayViewHeightConstraint.constant = height
            self.rootView.layoutIfNeeded()
        }
        userChatDisplayViewHeightAnimator.startAnimation()
    }
    
    func configureCharacterChatBox(character name: String, message: String, mode: ChatBoxMode, animated: Bool) {
        rootView.characterChatBox.characterNameLabel.text = name + " :"
        rootView.characterChatBox.messageLabel.text = message
        changeChatBoxMode(to: mode, animated: animated)
    }
    
    func changeChatBoxMode(to mode: ChatBoxMode, animated: Bool) {
        characterChatBoxModeChangingAnimator.stopAnimation(true)
        rootView.characterChatBox.mode = mode
        rootView.characterChatBox.chevronImageButton.isHidden = (mode == .loading)
        if animated {
            characterChatBoxModeChangingAnimator.addAnimations { [weak self] in
                guard let self else { return }
                switch mode {
                case .withReplyButtonShrinked:
                    self.rootView.characterChatBox.messageLabel.isHidden = false
                    self.rootView.characterChatBox.replyButton.isHidden = false
                    self.rootView.characterChatBox.chevronImageButton.imageView?.transform = .identity
                    self.rootView.characterChatBox.loadingAnimationView.isHidden = true
                    self.rootView.characterChatBox.loadingAnimationView.stop()
                case .withReplyButtonExpanded:
                    self.rootView.characterChatBox.messageLabel.isHidden = false
                    self.rootView.characterChatBox.replyButton.isHidden = false
                    self.rootView.characterChatBox.chevronImageButton.imageView?.transform = .init(rotationAngle: .pi * 0.9999)
                    self.rootView.characterChatBox.loadingAnimationView.isHidden = true
                    self.rootView.characterChatBox.loadingAnimationView.stop()
                case .withoutReplyButtonShrinked:
                    self.rootView.characterChatBox.messageLabel.isHidden = false
                    self.rootView.characterChatBox.replyButton.isHidden = true
                    self.rootView.characterChatBox.chevronImageButton.imageView?.transform = .identity
                    self.rootView.characterChatBox.loadingAnimationView.isHidden = true
                    self.rootView.characterChatBox.loadingAnimationView.stop()
                case .withoutReplyButtonExpanded:
                    self.rootView.characterChatBox.messageLabel.isHidden = false
                    self.rootView.characterChatBox.replyButton.isHidden = true
                    self.rootView.characterChatBox.chevronImageButton.imageView?.transform = .init(rotationAngle: .pi * 0.9999)
                    self.rootView.characterChatBox.loadingAnimationView.isHidden = true
                    self.rootView.characterChatBox.loadingAnimationView.stop()
                case .loading:
                    self.rootView.characterChatBox.messageLabel.isHidden = true
                    self.rootView.characterChatBox.replyButton.isHidden = true
                    self.rootView.characterChatBox.chevronImageButton.imageView?.transform = .identity
                    self.rootView.characterChatBox.loadingAnimationView.isHidden = false
                    self.rootView.characterChatBox.loadingAnimationView.play()
                }
                self.rootView.characterChatBox.setupAdditionalLayout()
                self.rootView.layoutIfNeeded()
            }
            characterChatBoxModeChangingAnimator.startAnimation()
        } else {
            switch mode {
            case .withReplyButtonShrinked:
                self.rootView.characterChatBox.messageLabel.isHidden = false
                self.rootView.characterChatBox.replyButton.isHidden = false
                self.rootView.characterChatBox.chevronImageButton.imageView?.transform = .identity
                self.rootView.characterChatBox.loadingAnimationView.isHidden = true
                self.rootView.characterChatBox.loadingAnimationView.stop()
            case .withReplyButtonExpanded:
                self.rootView.characterChatBox.messageLabel.isHidden = false
                self.rootView.characterChatBox.replyButton.isHidden = false
                self.rootView.characterChatBox.chevronImageButton.imageView?.transform = .init(rotationAngle: .pi * 0.99)
                self.rootView.characterChatBox.loadingAnimationView.isHidden = true
                self.rootView.characterChatBox.loadingAnimationView.stop()
            case .withoutReplyButtonShrinked:
                self.rootView.characterChatBox.messageLabel.isHidden = false
                self.rootView.characterChatBox.replyButton.isHidden = true
                self.rootView.characterChatBox.chevronImageButton.imageView?.transform = .identity
                self.rootView.characterChatBox.loadingAnimationView.isHidden = true
                self.rootView.characterChatBox.loadingAnimationView.stop()
            case .withoutReplyButtonExpanded:
                self.rootView.characterChatBox.messageLabel.isHidden = false
                self.rootView.characterChatBox.replyButton.isHidden = true
                self.rootView.characterChatBox.chevronImageButton.imageView?.transform = .init(rotationAngle: .pi * 0.99)
                self.rootView.characterChatBox.loadingAnimationView.isHidden = true
                self.rootView.characterChatBox.loadingAnimationView.stop()
            case .loading:
                self.rootView.characterChatBox.messageLabel.isHidden = true
                self.rootView.characterChatBox.replyButton.isHidden = true
                self.rootView.characterChatBox.chevronImageButton.imageView?.transform = .identity
                self.rootView.characterChatBox.loadingAnimationView.isHidden = false
                self.rootView.characterChatBox.loadingAnimationView.play()
            }
            rootView.characterChatBox.setupAdditionalLayout()
            rootView.layoutIfNeeded()
        }
    }
    
}

//MARK: - UIGestureRecognizerDelegate

extension ORBCharacterChatViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
}
