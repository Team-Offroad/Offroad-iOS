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
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNotifications()
        bindData()
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
        updateChatInputViewPosition(bottomInset: 0)
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
            print("메시지 전송: \(self.rootView.inputTextView.text!)")
        }.disposed(by: disposeBag)
    }
    
    //MARK: - Func
    
    func showCharacterChatBox() {
        rootView.layoutIfNeeded()
        rootView.characterChatBoxHidingAnimator.stopAnimation(true)
        rootView.characterChatBoxShowingAnimator.addAnimations { [weak self] in
            guard let self else { return }
            self.rootView.characterChatBoxTopConstraint.isActive = true
            self.rootView.characterChatBoxBottomConstraint.isActive = false
            self.rootView.layoutIfNeeded()
        }
        rootView.characterChatBoxShowingAnimator.startAnimation()
    }
    
    func hideCharacterChatBox() {
        rootView.characterChatBoxShowingAnimator.stopAnimation(true)
        rootView.characterChatBoxHidingAnimator.addAnimations { [weak self] in
            guard let self else { return }
            self.rootView.characterChatBoxTopConstraint.isActive = false
            self.rootView.characterChatBoxBottomConstraint.isActive = true
            self.rootView.layoutIfNeeded()
        }
        rootView.characterChatBoxHidingAnimator.startAnimation()
    }
    
    func updateChatInputViewPosition(bottomInset: CGFloat) {
        rootView.userChatInputViewAnimator.stopAnimation(true)
        rootView.layoutIfNeeded()
        rootView.userChatInputViewAnimator.addAnimations { [weak self] in
            guard let self else { return }
            self.rootView.userChatInputViewBottomConstraint.constant = -bottomInset
            self.rootView.layoutIfNeeded()
        }
        rootView.userChatInputViewAnimator.startAnimation()
    }
    
    func configureCharacterChatBox(character name: String, message: String) {
        rootView.characterChatBox.characterNameLabel.text = name
        rootView.characterChatBox.messageLabel.text = message
    }
    
}
