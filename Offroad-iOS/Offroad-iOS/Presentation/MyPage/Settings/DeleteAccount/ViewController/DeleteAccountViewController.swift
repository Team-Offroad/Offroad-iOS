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
    
    // MARK: - Life Cycle
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAddTarget()
        setupDelegate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        rootView.presentPopupView()
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
    
    //MARK: - @Objc Func
    
    @objc private func cancleButtonTapped() {
        rootView.dismissPopupView()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4){
            self.dismiss(animated: false)
        }
    }
    
    @objc private func withdrawalButtonTapped() {

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
