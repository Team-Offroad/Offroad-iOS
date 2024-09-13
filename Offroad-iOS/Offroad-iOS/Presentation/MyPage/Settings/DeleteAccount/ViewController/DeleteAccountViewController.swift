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
        rootView.deleteAccountButton.addTarget(self, action: #selector(deleteAccountButtonTapped), for: .touchUpInside)
    }
    
    private func setupDelegate() {
        rootView.deleteAccountMessageTextField.delegate = self
    }
    
    private func setupKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    private func postDeleteAccount(deleteAccountRequestDTO: DeleteAccountRequestDTO) {
        NetworkService.shared.profileService.postDeleteAccount(body: deleteAccountRequestDTO) { response in
            switch response {
            case .success:
                KeychainManager.shared.deleteAccessToken()
                KeychainManager.shared.deleteRefreshToken()
                UserDefaults.standard.set(false, forKey: "isLoggedIn")
                
                let splashViewController = SplashViewController()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    UIWindow.current.rootViewController = splashViewController
                }
            default:
                break
            }
        }
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
    
    @objc private func deleteAccountButtonTapped() {
        rootView.endEditing(true)
        
        self.postDeleteAccount(deleteAccountRequestDTO: DeleteAccountRequestDTO(deleteCode: self.rootView.deleteAccountMessageLabel.text ?? ""))

    }
    
    @objc func keyboardWillShow(_ sender: Notification) {
        isKeyboardVisible = true

        if let keyboardSize = (sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.rootView.popupView.transform = CGAffineTransform(translationX: 0, y: -(keyboardSize.height - self.rootView.popupView.frame.origin.y + 24))
        }
    }
    
    @objc func keyboardWillHide() {
        isKeyboardVisible = false

        self.rootView.popupView.transform = .identity
    }
}

extension DeleteAccountViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField.text == rootView.deleteAccountMessageLabel.text {
            rootView.deleteAccountButton.changeState(forState: .isEnabled)
        } else {
            rootView.deleteAccountButton.changeState(forState: .isDisabled)
        }
    }
}
