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
    
    private(set) var isChatTextInputViewShown: Bool = false
    
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
        setupChatTextActions()
        setupChatBox()
    }
    
}

extension ORBCharacterChatViewController {
    
    //MARK: - @objc Func
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        // 키보드가 올라올 때 다음 메서드 호출해야 채팅창이 올라올 때 애니메이션 적용됨.
        rootView.layoutIfNeeded()
    }
    
    //MARK: - Private Func
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
    }
    
    private func bindData() {
        rootView.endChatButton.rx.tap.bind { [weak self] in
            guard let self else { return }
            self.endChat()
            self.hideCharacterChatBox()
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
    }
    
    private func postCharacterChat(characterId: Int? = nil, message: String) {
        isCharacterResponding.accept(true)
        rootView.chatTextInputView.isSendingAllowed = false
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
            self.rootView.chatTextInputView.isSendingAllowed = true
        }
    }
    
}

//MARK: - 채팅창 입력 관련 함수

extension ORBCharacterChatViewController {
    
    //MARK: - Private Func
    
    private func setupChatTextActions() {
        rootView.chatTextInputView.onTextInput.subscribe(onNext: { [weak self] inputText in
            guard let self else { return }
            if !inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                self.rootView.chatTextDisplayView.startDisplayLoading()
            } else {
                self.rootView.chatTextDisplayView.stopDisplayLoading()
            }
        }).disposed(by: disposeBag)
        
        rootView.chatTextInputView.onSendingText.subscribe(onNext: { [weak self] sendingText in
            guard let self else { return }
            self.postCharacterChat(message: sendingText)
            // 캐릭터 응답 로티 뜨도록 구현
            self.characterChatBox.configureContents(
                character: MyInfoManager.shared.representativeCharacterName ?? "",
                message: "",
                mode: .loading,
                animated: true
            )
            self.showCharacterChatBox(isAutoDismiss: false)
            self.rootView.chatTextDisplayView.display(text: sendingText.trimmingCharacters(in: .whitespacesAndNewlines))
        }).disposed(by: disposeBag)
    }
    
    //MARK: - Func
    
    func startChat() {
        rootView.characterChatBox.isHidden = false
        rootView.endChatButton.isHidden = false
        rootView.chatTextInputView.startChat()
        rootView.chatTextDisplayView.show()
        isChatTextInputViewShown = true
        panGesture.isEnabled = true
    }
    
    func endChat() {
        rootView.endChatButton.isHidden = true
        rootView.chatTextInputView.endChat(erase: true)
        rootView.chatTextDisplayView.hide(erase: true)
        isChatTextInputViewShown = false
        panGesture.isEnabled = false
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
            self.startChat()
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
        let chatBoxHeight = characterChatBox.frame.height
        panGesture.isEnabled = false
        isCharacterChatBoxShown = false
        characterChatBoxPositionAnimator.stopAnimation(true)
        characterChatBoxPositionAnimator.addAnimations { [weak self] in
            guard let self else { return }
            // pagGesture로 변경된 (세로)위치 원상복구
            self.characterChatBox.transform = CGAffineTransform.identity
            self.rootView.characterChatBoxTopConstraint.constant = -max(60, chatBoxHeight)
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
