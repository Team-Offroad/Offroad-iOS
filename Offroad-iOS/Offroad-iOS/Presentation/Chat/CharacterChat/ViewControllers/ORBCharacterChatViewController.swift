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
    
    var disposeBag = DisposeBag()
    let rootView = ORBCharacterChatView()
    let isCharacterResponding = BehaviorRelay<Bool>(value: false)
    let patchChatReadRelay = PublishRelay<Void>()
    
    //MARK: - Properties, 채팅 입력창 관련
    
    var isUserChatInputViewShown: Bool = false
    
    // userChatInputView의 textInputView의 height를 전달
    let userChatInputViewTextInputViewHeightRelay = PublishRelay<CGFloat>()
    // userChatDisplayView의 textInputVie의 height를 전달
    let userChatDisplayViewTextInputViewHeightRelay = PublishRelay<CGFloat>()
    
    let isTextViewEmpty = BehaviorRelay<Bool>(value: true)
    let userChatViewAnimator = UIViewPropertyAnimator(duration: 0.5, dampingRatio: 1)
    let userChatInputViewHeightAnimator = UIViewPropertyAnimator(duration: 0.3, dampingRatio: 1)
    let userChatDisplayViewHeightAnimator = UIViewPropertyAnimator(duration: 0.3, dampingRatio: 1)
    
    //MARK: - Properties, 채팅 박스 관련
    
    var isCharacterChatBoxShown: Bool = false
    let characterChatBoxPositionAnimator = UIViewPropertyAnimator(duration: 0.5, dampingRatio: 1)
    lazy var panGesture = UIPanGestureRecognizer()
    private var hideWorkItem: DispatchWorkItem?
    private var characterChatBox: ORBCharacterChatBox { rootView.characterChatBox }
    
    //MARK: - Life Cycle
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNotifications()
        bindData()
        setupChatInput()
        setupChatBox()
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
        return fittingSize
    }
    
    private func bindData() {
        ORBCharacterChatManager.shared.shouldMakeKeyboardBackgroundTransparent
            .subscribe(onNext: { [weak self] isTransparent in
                guard let self else { return }
                self.rootView.keyboardBackgroundView.isHidden = isTransparent
            }).disposed(by: disposeBag)
        
        rootView.endChatButton.rx.tap.bind { [weak self] in
            guard let self else { return }
            self.rootView.userChatInputView.resignFirstResponder()
            self.hideUserChatInputView()
            self.rootView.userChatInputView.text = ""
            self.rootView.userChatDisplayView.text = ""
            panGesture.isEnabled = false
            hideCharacterChatBox()
        }.disposed(by: disposeBag)
        
        patchChatReadRelay.subscribe(onNext: { [weak self] in
            guard let self else { return }
            NetworkService.shared.characterChatService.patchChatRead { [weak self] networkResult in
                guard let self else { return }
                switch networkResult {
                case .success:
                    ORBCharacterChatManager.shared.didReadLastChat.accept(())
                    return
                default:
                    self.showToast(message: ErrorMessages.networkError, inset: 66)
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
                self.characterChatBox.configureContents(character: MyInfoManager.shared.representativeCharacterName ?? "", message: characterChatResponse, mode: .withoutReplyButtonShrinked, animated: true)
            case .networkFail:
                self.showToast(message: ErrorMessages.networkError, inset: 66)
                self.hideCharacterChatBox()
            case .serverErr:
                self.showToast(message: "오브가 답변하기 힘든 질문이예요.\n다른 이야기를 해볼까요?", inset: 66)
                self.hideCharacterChatBox()
            case .decodeErr:
                self.showToast(message: "decode Error occurred", inset: 66)
                self.hideCharacterChatBox()
            default:
                self.showToast(message: "알 수 없는 에러가 발생했어요. 잠시 후 다시 시도해 주세요.", inset: 66)
                self.hideCharacterChatBox()
            }
            self.isCharacterResponding.accept(false)
        }
    }
    
}

//MARK: - 채팅창 입력 관련 함수

extension ORBCharacterChatViewController {
    
    //MARK: - Private Func
    
    private func setupChatInput() {
        rootView.sendButton.rx.tap.bind { [weak self] in
            guard let self else { return }
            self.postCharacterChat(message: self.rootView.userChatInputView.text)
            // 로티 뜨도록 구현
            self.characterChatBox.configureContents(
                character: MyInfoManager.shared.representativeCharacterName ?? "",
                message: "",
                mode: .loading,
                animated: true
            )
            self.showCharacterChatBox(isAutoDismiss: false)
            self.rootView.userChatDisplayView.text = self.rootView.userChatInputView.text.trimmingCharacters(in: .whitespacesAndNewlines)
            self.rootView.userChatDisplayView.bounds.origin.y = -(self.rootView.userChatDisplayView.bounds.height)
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1) {
                self.rootView.userChatDisplayView.bounds.origin.y = 0
                self.rootView.layoutIfNeeded()
            }
            self.rootView.userChatInputView.text = ""
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
    }
    
    //MARK: - Func
    
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
        userChatInputViewHeightAnimator.stopAnimation(true)
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
    
}

//MARK: - 채팅 박스 관련 함수

extension ORBCharacterChatViewController {
    
    //MARK: - Private Func
    
    private func setupChatBox() {
        setupPanGestures()
        
        characterChatBox.rx.controlEvent([.touchDown]).subscribe(onNext: { [weak self] in
            self?.stopAutoHide()
            self?.characterChatBox.shrink(scale: 0.97)
        }).disposed(by: disposeBag)
        
        characterChatBox.rx.controlEvent([.touchUpOutside, .touchCancel]).subscribe(onNext: { [weak self] in
            self?.characterChatBox.restore()
        }).disposed(by: disposeBag)
        
        characterChatBox.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] in
            guard let self else { return }
            self.characterChatBox.restore()
            guard self.characterChatBox.mode != .loading else { return }
            self.patchChatReadRelay.accept(())
            ORBCharacterChatManager.shared.shouldPushCharacterChatLogViewController
                .onNext(MyInfoManager.shared.representativeCharacterID)
        }).disposed(by: disposeBag)
        
        characterChatBox.chevronImageButton.rx.controlEvent(.touchDown).bind(onNext: { [weak self] in
            guard let self else { return }
            self.stopAutoHide()
        }).disposed(by: disposeBag)
        
        characterChatBox.chevronImageButton.rx.controlEvent([.touchUpInside, .touchUpOutside])
            .bind(onNext: { [weak self] in
                guard let self else { return }
                let hasReplyButton = self.characterChatBox.mode == .withReplyButtonShrinked
                || self.characterChatBox.mode == .withReplyButtonExpanded
                if hasReplyButton {
                    self.startAutoHide()
                }
            }).disposed(by: disposeBag)
        
        characterChatBox.replyButton.rx.tap.bind { [weak self] in
            guard let self else { return }
            self.stopAutoHide()
            self.rootView.window?.makeKeyAndVisible()
            if self.rootView.userChatInputView.becomeFirstResponder() {
                self.patchChatReadRelay.accept(())
            }
            self.characterChatBox.isHidden = false
            self.rootView.userChatView.isHidden = false
            self.rootView.endChatButton.isHidden = false
            self.characterChatBox.changeMode(to: .withoutReplyButtonExpanded, animated: true)
        }.disposed(by: disposeBag)
    }
    
    private func setupPanGestures() {
        characterChatBox.addGestureRecognizer(panGesture)
        panGesture.rx.event.subscribe(onNext: { [weak self] gesture in
            self?.panGestureHandler(sender: gesture)
        }).disposed(by: disposeBag)
    }
    
    private func panGestureHandler(sender: UIPanGestureRecognizer) {
        let hasReplyButton = characterChatBox.mode == .withReplyButtonShrinked
        || characterChatBox.mode == .withReplyButtonExpanded
        switch sender.state {
        case .possible, .began:
            stopAutoHide()
            return
        case .changed:
            let verticalPosition = sender.translation(in: rootView).y
            if verticalPosition < 0, hasReplyButton {
                let transform = CGAffineTransform(translationX: 0, y: verticalPosition)
                characterChatBox.transform = transform
                
            } else if verticalPosition < 0, !hasReplyButton {
                let maximumDragDistance: CGFloat = 15
                let transform = CGAffineTransform(translationX: 0, y: -maximumDragDistance * (1 - exp(-0.5 * -verticalPosition / maximumDragDistance)))
                characterChatBox.transform = transform
                
            } else if verticalPosition > 0 {
                let maximumDragDistance: CGFloat = hasReplyButton ? 60 : 15
                let transform = CGAffineTransform(translationX: 0, y: maximumDragDistance * (1 - exp(-0.5 * verticalPosition / maximumDragDistance)))
                characterChatBox.transform = transform
                
            }
        case .ended, .cancelled, .failed:
            if sender.velocity(in: rootView).y < -100, hasReplyButton {
                hideCharacterChatBox()
            } else {
                showCharacterChatBox(isAutoDismiss: false)
                if hasReplyButton {
                    startAutoHide()
                }
            }
        @unknown default:
            characterChatBox.transform = CGAffineTransform.identity
        }
    }
    
    private func startAutoHide() {
        hideWorkItem?.cancel()
        hideWorkItem = DispatchWorkItem(block: { [weak self] in
            guard let self else { return }
            self.hideCharacterChatBox()
        })
        // 채팅 박스 나타나는 애니메이션 시간: 0.5초
        // 3초 뒤에 사라지도록 구현
        DispatchQueue.main.asyncAfter(deadline: .now() + (3 + 0.5), execute: hideWorkItem!)
    }
    
    private func stopAutoHide() {
        hideWorkItem?.cancel()
    }
    
    //MARK: - Func
    
    func showCharacterChatBox(isAutoDismiss: Bool = true) {
        isCharacterChatBoxShown = true
        characterChatBox.isHidden = false
        panGesture.isEnabled = true
        rootView.layoutIfNeeded()
        characterChatBoxPositionAnimator.stopAnimation(true)
        characterChatBoxPositionAnimator.addAnimations { [weak self] in
            guard let self else { return }
            // pagGesture로 변경된 (세로)위치 원상복구
            self.characterChatBox.transform = CGAffineTransform.identity
            self.rootView.characterChatBoxTopConstraint.constant = view.safeAreaInsets.top + 27
            self.rootView.layoutIfNeeded()
        }
        characterChatBoxPositionAnimator.startAnimation()
        if isAutoDismiss {
            startAutoHide()
        }
    }
    
    func hideCharacterChatBox() {
        panGesture.isEnabled = false
        isCharacterChatBoxShown = false
        characterChatBoxPositionAnimator.stopAnimation(true)
        characterChatBoxPositionAnimator.addAnimations { [weak self] in
            guard let self else { return }
            // pagGesture로 변경된 (세로)위치 원상복구
            self.characterChatBox.transform = CGAffineTransform.identity
            self.rootView.characterChatBoxTopConstraint.constant
            = -self.characterChatBox.frame.height
            self.rootView.layoutIfNeeded()
        }
        characterChatBoxPositionAnimator.addCompletion { [weak self] _ in
            guard let self else { return }
            self.characterChatBox.characterNameLabel.text = ""
            self.characterChatBox.loadingAnimationView.stop()
            self.characterChatBox.loadingAnimationView.isHidden = true
            self.characterChatBox.messageLabel.isHidden = false
            self.characterChatBox.messageLabel.text = ""
        }
        characterChatBoxPositionAnimator.startAnimation()
    }
    
}
