//
//  BirthViewController.swift
//  Offroad-iOS
//
//  Created by  정지원 on 7/9/24.
//

import UIKit

import SnapKit
import Then

final class BirthViewController: UIViewController {
    
    //MARK: - Properties
    
    private let birthView = BirthView()
    private var nickname: String = ""
    
    //MARK: - Life Cycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init(nickname: String) {
        self.init(nibName: nil, bundle: nil)
        
        self.nickname = nickname
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = birthView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDelegate()
        setupAddTarget()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        birthView.nextButton.changeState(forState: .isDisabled)
    }
    
    //MARK: - Private Method
    
    private func setupAddTarget() {
        birthView.yearTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingDidBegin)
        birthView.monthTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingDidBegin)
        birthView.dayTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingDidBegin)
        
        birthView.yearTextField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        birthView.monthTextField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        birthView.dayTextField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        
        birthView.yearTextField.addTarget(self, action: #selector(textFieldDidEndEditing(_:)), for: .editingDidEnd)
        birthView.monthTextField.addTarget(self, action: #selector(textFieldDidEndEditing(_:)), for: .editingDidEnd)
        birthView.dayTextField.addTarget(self, action: #selector(textFieldDidEndEditing(_:)), for: .editingDidEnd)
        
        birthView.nextButton.addTarget(self, action: #selector(buttonToGenderVC), for: .touchUpInside)
        birthView.skipButton.addTarget(self, action: #selector(skipButtonTapped), for: .touchUpInside)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: birthView.skipButton)
    }
    
    private func validateYear() -> Bool {
        guard let yearText = birthView.yearTextField.text, let year = Int(yearText), year >= 1920 else {
            birthView.notionLabel.text = "다시 한 번 확인해주세요."
            return false
        }
        birthView.notionLabel.text = ""
        return true
    }
    
    private func validateMonth() -> Bool {
        guard let monthText = birthView.monthTextField.text, monthText.count == 2, let month = Int(monthText), month >= 1 && month <= 12 else {
            birthView.notionLabel.text = "다시 한 번 확인해주세요."
            return false
        }
        birthView.notionLabel.text = ""
        return true
    }
    
    private func validateDay() -> Bool {
        guard let yearText = birthView.yearTextField.text, let year = Int(yearText),
              let monthText = birthView.monthTextField.text, let month = Int(monthText),
              let dayText = birthView.dayTextField.text, let day = Int(dayText) else {
            return false
        }
        
        if month < 1 || month > 12 || day < 1 || day > 31 {
            return false
        }
        
        switch month {
        case 4, 6, 9, 11:
            return day <= 30
        case 2:
            if isLeapYear(year) {
                return day <= 29
            } else {
                return day <= 28
            }
        default:
            return day <= 31
        }
    }
    
    private func isLeapYear(_ year: Int) -> Bool {
        return (year % 4 == 0 && year % 100 != 0) || year % 400 == 0
    }
    
    private func validateInputs() -> Bool {
        return validateYear() && validateMonth() && validateDay()
    }
}

extension BirthViewController {
    
    //MARK: - @objc Method
    
    @objc private func textFieldDidChange(_ sender: UITextField) {
        [birthView.yearTextField, birthView.monthTextField, birthView.dayTextField].forEach {
            $0.layer.borderColor = UIColor.grayscale(.gray100).cgColor
        }
        sender.layer.borderColor = UIColor.sub(.sub).cgColor
    }

    
    @objc private func textFieldEditingChanged(_ textField: UITextField) {
        let maxLength: Int
        if textField == birthView.yearTextField {
            maxLength = 4
        } else {
            maxLength = 2
        }
        if let text = textField.text, text.count > maxLength {
            textField.text = String(text.prefix(maxLength))
        }
        // 텍스트필드 자동 이동 구현
        if textField == birthView.yearTextField {
            if validateYear() && textField.text?.count == 4 {
                birthView.monthTextField.becomeFirstResponder()
            }
        } else if textField == birthView.monthTextField {
            if validateMonth() && textField.text?.count == 2 {
                birthView.dayTextField.becomeFirstResponder()
            }
        }
        if validateInputs() {
            birthView.nextButton.changeState(forState: .isEnabled)
        } else {
            birthView.nextButton.changeState(forState: .isDisabled)
        }
    }
    
    // 1자리수를 2자리수로 자동 변환
    @objc internal func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == birthView.monthTextField {
            if let monthText = birthView.monthTextField.text, monthText.count == 1 {
                birthView.monthTextField.text = "0\(monthText)"
            }
        } else if textField == birthView.dayTextField {
            if let dayText = birthView.dayTextField.text, dayText.count == 1 {
                birthView.dayTextField.text = "0\(dayText)"
            }
        }
        if validateInputs() {
            birthView.nextButton.changeState(forState: .isEnabled)
        } else {
            birthView.nextButton.changeState(forState: .isDisabled)
        }
        [birthView.yearTextField, birthView.monthTextField, birthView.dayTextField].forEach {
            $0.layer.borderColor = UIColor.grayscale(.gray100).cgColor
        }
    }
    
    @objc func buttonToGenderVC(sender: UIButton) {
        if validateDay() {
            let nextVC = GenderViewController(
                nickname: nickname,
                birthYear: birthView.yearTextField.text ?? "",
                birthMonth: birthView.monthTextField.text ?? "",
                birthDay: birthView.dayTextField.text ?? ""
            )
            let button = UIButton().then { button in
                button.setImage(.backBarButton, for: .normal)
                button.addTarget(self, action: #selector(executePop), for: .touchUpInside)
                button.imageView?.contentMode = .scaleAspectFill
                button.snp.makeConstraints { make in
                    make.width.equalTo(30)
                    make.height.equalTo(44)
                }
            }
            
            let customBackBarButton = UIBarButtonItem(customView: button)
            nextVC.navigationItem.leftBarButtonItem = customBackBarButton
            
            self.navigationController?.pushViewController(nextVC, animated: true)
        } else {
            birthView.notionLabel.text = "다시 한 번 확인해주세요."
        }
    }
    
    @objc private func executePop() {
        navigationController?.popViewController(animated: true)
    }
    
    
    @objc func skipButtonTapped() {
        let genderViewController = GenderViewController(nickname: nickname, birthYear: nil, birthMonth: nil, birthDay: nil)
        
        let button = UIButton().then { button in
            button.setImage(.backBarButton, for: .normal)
            button.addTarget(self, action: #selector(executePop), for: .touchUpInside)
            button.imageView?.contentMode = .scaleAspectFill
            button.snp.makeConstraints { make in
                make.width.equalTo(30)
                make.height.equalTo(44)
            }
        }
        
        let customBackBarButton = UIBarButtonItem(customView: button)
        customBackBarButton.tintColor = .black
        genderViewController.navigationItem.leftBarButtonItem = customBackBarButton
        
        self.navigationController?.pushViewController(genderViewController, animated: true)
    }
    
    
    // 텍스트 필드 글자 수 제한
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    //MARK: - Private Func
    
    private func setupTarget() {
        birthView.yearTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        birthView.monthTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        birthView.dayTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        birthView.nextButton.addTarget(self, action: #selector(buttonToGenderVC), for: .touchUpInside)
        birthView.skipButton.addTarget(self, action: #selector(buttonToGenderVC), for: .touchUpInside)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: birthView.skipButton)
    }
}

//MARK: - UITextFieldDelegate

extension BirthViewController: UITextFieldDelegate {
    
    func setupDelegate() {
        birthView.yearTextField.delegate = self
        birthView.monthTextField.delegate = self
        birthView.dayTextField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension BirthViewController {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
