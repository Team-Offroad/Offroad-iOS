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
    
    // userChatTextView의 textInputView의 height를 전달
    let userChatTextViewTextInputViewHeightRelay = PublishRelay<CGFloat>()
    
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
            print("끝!", sender.velocity(in: rootView).y)
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
            self.rootView.userChatDisplayView.text = self.rootView.userChatInputView.text
            self.rootView.userChatInputView.text = ""
        }.disposed(by: disposeBag)
        
        rootView.endChatButton.rx.tap.bind { [weak self] in
            guard let self else { return }
            print("채팅을 종료합니다.")
            let isFR = self.rootView.userChatInputView.resignFirstResponder()
            print("didResingFirstResponder: \(isFR)")
            hideCharacterChatBox()
        }.disposed(by: disposeBag)
        
        rootView.userChatInputView.rx.text.orEmpty.subscribe { [weak self] text in
            guard let self else { return }
            self.userChatTextViewTextInputViewHeightRelay.accept(self.rootView.userChatInputView.textInputView.bounds.height)
            if text.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
                print("입력된 텍스트: \(text)")
                self.rootView.userChatDisplayView.text = ""
                self.rootView.loadingAnimationView.isHidden = false
                self.rootView.loadingAnimationView.play()
                self.rootView.sendButton.isEnabled = true
            } else {
                print("입력된 텍스트 없음")
                self.rootView.loadingAnimationView.pause()
                self.rootView.loadingAnimationView.isHidden = true
                self.rootView.sendButton.isEnabled = false
            }
        }.disposed(by: disposeBag)
        
        userChatTextViewTextInputViewHeightRelay
            .subscribe(onNext: { textContentHeight in
                if textContentHeight >= 30 {
                    self.updateChatInputViewHeight(height: (20*2) + (9*2))
                } else {
                    self.updateChatInputViewHeight(height: 20 + (9*2))
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
    }
    
    func configureCharacterChatBox(character name: String, message: String) {
        rootView.characterChatBox.characterNameLabel.text = name
        rootView.characterChatBox.messageLabel.text = message
    }
    
}
