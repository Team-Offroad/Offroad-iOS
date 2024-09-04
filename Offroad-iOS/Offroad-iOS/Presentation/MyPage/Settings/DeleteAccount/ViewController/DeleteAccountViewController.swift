//
//  DeleteAccountViewController.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 9/3/24.
//

import UIKit

final class DeleteAccountViewController: UIViewController {
    
    //MARK: - Properties
    
    private let rootView = DeleteAccountView()
    
    private var isKeyboardVisible: Bool = false
    
    // MARK: - Life Cycle
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAddTarget()
        setupDelegate()
        setupKeyboard()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        rootView.presentPopupView()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        rootView.endEditing(true)
    }
}

extension DeleteAccountViewController {
    
    // MARK: - Private Method
    
    private func setupAddTarget() {
        rootView.cancleButton.addTarget(self, action: #selector(cancleButtonTapped), for: .touchUpInside)
        rootView.withdrawalButton.addTarget(self, action: #selector(withdrawalButtonTapped), for: .touchUpInside)
    }
    
    private func setupDelegate() {
        rootView.withdrawalMassageTextField.delegate = self
    }
    
    private func setupKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    //MARK: - @Objc Func
    
    @objc private func cancleButtonTapped() {
        if !isKeyboardVisible {
            self.rootView.dismissPopupView {
                self.dismiss(animated: false)
            }
        }
        else {
            rootView.endEditing(true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3){
                self.rootView.dismissPopupView {
                    self.dismiss(animated: false)
                }
            }
        }
    }
    
    @objc private func withdrawalButtonTapped() {
        rootView.endEditing(true)
    }
    
    @objc func keyboardWillShow(_ sender: Notification) {
        isKeyboardVisible = true

        if let keyboardSize = (sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.rootView.popupView.transform = CGAffineTransform(translationX: 0, y: -(keyboardSize.height - (self.rootView.popupView.frame.origin.y - 24)))
        }
    }
    
    @objc func keyboardWillHide(_ sender: Notification) {
        isKeyboardVisible = false

        self.rootView.popupView.transform = .identity
    }
}

extension DeleteAccountViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField.text == rootView.withdrawalMessageLabel.text {
            rootView.withdrawalButton.changeState(forState: .isEnabled)
        } else {
            rootView.withdrawalButton.changeState(forState: .isDisabled)
        }
    }
}
