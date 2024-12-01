//
//  NicknameSettingViewController.swift
//  Offroad-iOS
//
//  Created by 김민성 on 12/1/24.
//

import UIKit

import RxSwift
import RxCocoa

class NicknameSettingViewController: UIViewController {
    
    //MARK: - Properties
    
    var disposeBag = DisposeBag()
    let viewModel = NicknameSettingViewModel()
    
    //MARK: - UI Properties
    
    let rootView = NicknameSettingView()
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindData()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        rootView.endEditing(true)
    }
    
}

extension NicknameSettingViewController {
    
    private func bindData() {
        viewModel.duplicateCheckResult.subscribe(onNext: { [weak self] isDuplicate in
            guard let self else { return }
            if isDuplicate {
                rootView.nicknameInstructionLabel.text = "중복된 닉네임이에요. 다른 멋진 이름이 있으신가요?"
                rootView.nicknameInstructionLabel.textColor = .primary(.errorNew)
                rootView.nicknameTextField.layer.borderColor = UIColor.primary(.errorNew).cgColor
                rootView.nextButton.isEnabled = false
            } else {
                rootView.nicknameInstructionLabel.text = "좋은 닉네임이에요!"
                rootView.nicknameInstructionLabel.textColor = .grayscale(.gray400)
                rootView.nicknameTextField.layer.borderColor = UIColor.main(.main2).cgColor
                rootView.nextButton.isEnabled = true
                self.cacheCheckedNickname()
            }
        }).disposed(by: disposeBag)
        
        viewModel.networkFail.subscribe(onNext: { [weak self] in
            guard let self else { return }
            self.showToast(message: ErrorMessages.networkError, inset: 66)
        }).disposed(by: disposeBag)
        
        rootView.nicknameTextField.rx.text.orEmpty.bind(onNext: { [weak self] inputText in
            guard let self else { return }
            print("입력값: \(inputText)")
            let trimmedInputText = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
            self.rootView.checkDuplicateButton.isEnabled = trimmedInputText == "" ? false : true
            self.rootView.nextButton.isEnabled = false
            self.deleteCachedNickname()
        }).disposed(by: disposeBag)
        
        rootView.checkDuplicateButton.rx.tap.bind(onNext: { [weak self] in
            guard let self else { return }
            viewModel.checkDuplicate(input: self.rootView.nicknameTextField.text!)
        }).disposed(by: disposeBag)
        
        rootView.nextButton.rx.tap.bind(onNext: { [weak self] in
            guard let self else { return }
            self.navigationController?.pushViewController(UIViewController(), animated: true)
        }).disposed(by: disposeBag)
    }
    
    private func cacheCheckedNickname() {
        guard let onboardingNavigationController
                = self.navigationController as? OnboardingNavigationController else { return }
        onboardingNavigationController.nickname = viewModel.duplicationCheckedNickname
    }
    
    private func deleteCachedNickname() {
        guard let onboardingNavigationController
                = self.navigationController as? OnboardingNavigationController else { return }
        onboardingNavigationController.nickname = nil
    }
    
}
