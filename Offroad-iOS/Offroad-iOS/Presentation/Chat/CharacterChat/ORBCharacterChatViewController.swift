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
    
    var disposeBag = DisposeBag()
    let rootView = ORBCharacterChatView()
    
    // userChatInputView의 textInputView의 height를 전달
    let userChatInputViewTextInputViewHeightRelay = PublishRelay<CGFloat>()
    // userChatDisplayView의 textInputVie의 height를 전달
    let userChatDisplayViewTextInputViewHeightRelay = PublishRelay<CGFloat>()
    
    lazy var panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureHandler))
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNotifications()
        bindData()
        setupGestures()
    }
    
}

extension ORBCharacterChatViewController {
    
    //MARK: - @objc Func
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        rootView.layoutIfNeeded()
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRect = keyboardFrame.cgRectValue
            updateChatInputViewPosition(bottomInset: keyboardRect.height)
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        rootView.layoutIfNeeded()
        let inputViewHeight = rootView.userChatView.frame.height
        updateChatInputViewPosition(bottomInset: -(48 + inputViewHeight))
    }
    
    @objc private func panGestureHandler(sender: UIPanGestureRecognizer) {
        print(#function)
        
        switch sender.state {
        case .possible, .began:
            return
        case .changed:
            let verticalPosition = sender.translation(in: rootView).y
            print(verticalPosition)
            if verticalPosition < 0 {
                let transform = CGAffineTransform(translationX: 0, y: verticalPosition)
                rootView.characterChatBox.transform = transform
            }
        case .ended, .cancelled, .failed:
            if sender.velocity(in: rootView).y < -100 {
                hideCharacterChatBox()
            } else {
                showCharacterChatBox()
            }
        @unknown default:
            rootView.characterChatBox.transform = CGAffineTransform.identity
        }
        
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
    
    private func bindData() {
        rootView.sendButton.rx.tap.bind { [weak self] in
            guard let self else { return }
            print("메시지 전송: \(self.rootView.userChatInputView.text!)")
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
            rootView.userChatInputView.text = ""
            rootView.userChatDisplayView.text = ""
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
                    self.rootView.sendButton.isEnabled = true
                    self.updateChatDisplayViewHeight(height: 20)
                } else {
                    print("입력된 텍스트 없음")
                    userChatDisplayViewTextInputViewHeightRelay.accept(rootView.userChatDisplayView.textInputView.frame.height)
                    self.rootView.userChatDisplayView.isHidden = false
                    self.rootView.loadingAnimationView.currentProgress = 0
                    self.rootView.loadingAnimationView.pause()
                    self.rootView.loadingAnimationView.isHidden = true
                    self.rootView.sendButton.isEnabled = false
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
    
    private func setupGestures() {
        rootView.characterChatBox.addGestureRecognizer(panGesture)
    }
    
    //MARK: - Func
    
    func showCharacterChatBox() {
        rootView.layoutIfNeeded()
        rootView.characterChatBoxAnimator.stopAnimation(true)
        rootView.characterChatBoxAnimator.addAnimations { [weak self] in
            guard let self else { return }
            self.rootView.characterChatBox.transform = CGAffineTransform.identity
            self.rootView.characterChatBoxTopConstraint.isActive = true
            self.rootView.characterChatBoxBottomConstraint.isActive = false
            self.rootView.layoutIfNeeded()
        }
        rootView.characterChatBoxAnimator.startAnimation()
    }
    
    func hideCharacterChatBox() {
        rootView.characterChatBoxAnimator.stopAnimation(true)
        rootView.characterChatBoxAnimator.addAnimations { [weak self] in
            guard let self else { return }
            self.rootView.characterChatBox.transform = CGAffineTransform.identity
            self.rootView.characterChatBoxTopConstraint.isActive = false
            self.rootView.characterChatBoxBottomConstraint.isActive = true
            self.rootView.layoutIfNeeded()
        }
        rootView.characterChatBoxAnimator.startAnimation()
    }
    
    func updateChatInputViewPosition(bottomInset: CGFloat) {
        rootView.userChatViewAnimator.stopAnimation(true)
        rootView.layoutIfNeeded()
        rootView.userChatViewAnimator.addAnimations { [weak self] in
            guard let self else { return }
            self.rootView.userChatViewBottomConstraint.constant = -bottomInset
            self.rootView.layoutIfNeeded()
        }
        rootView.userChatViewAnimator.startAnimation()
    }
    
    func updateChatInputViewHeight(height: CGFloat) {
        print(#function)
        rootView.userChatInputViewHeightAnimator.addAnimations { [weak self] in
            guard let self else { return }
            self.rootView.userChatInputViewHeightConstraint.constant = height
            self.rootView.layoutIfNeeded()
        }
        rootView.userChatInputViewHeightAnimator.startAnimation()
    }
    
    func updateChatDisplayViewHeight(height: CGFloat) {
        rootView.userChatDisplayViewHeightAnimator.addAnimations { [weak self] in
            guard let self else { return }
            self.rootView.userChatDisplayViewHeightConstraint.constant = height
            self.rootView.layoutIfNeeded()
        }
        rootView.userChatDisplayViewHeightAnimator.startAnimation()
    }
    
    func configureCharacterChatBox(character name: String, message: String) {
        rootView.characterChatBox.characterNameLabel.text = name + " :"
        rootView.characterChatBox.messageLabel.text = message
    }
    
}
