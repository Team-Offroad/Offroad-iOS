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
        
        [birthView.yearTextField, birthView.monthTextField, birthView.dayTextField].forEach {
            $0.layer.borderColor = UIColor.grayscale(.gray100).cgColor
        }
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
        guard let yearText = birthView.yearTextField.text, let year = Int(yearText) else {
            return false
        }
        
        let currentYear = Calendar.current.component(.year, from: Date())
        
        if year < 1900 || year > currentYear {
            return false
        }
        birthView.notionLabel.text = ""
        return true
    }
    
    private func validateMonth() -> Bool {
        guard let monthText = birthView.monthTextField.text, let month = Int(monthText), month >= 1 && month <= 12 else {
            return false
        }
        
        let currentYear = Calendar.current.component(.year, from: Date())
        let currentMonth = Calendar.current.component(.month, from: Date())
        
        if let yearText = birthView.yearTextField.text, let year = Int(yearText) {
            if year == currentYear && month > currentMonth {
                return false
            }
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
        
        if day < 1 || day > 31 {
            return false
        }
        
        switch month {
        case 4, 6, 9, 11:
            if day > 30 {
                return false
            }
        case 2:
            if day > (isLeapYear(year) ? 29 : 28) {
                return false
            }
        default:
            if day > 31 {
                return false
            }
        }
        
        let currentYear = Calendar.current.component(.year, from: Date())
        let currentMonth = Calendar.current.component(.month, from: Date())
        let currentDay = Calendar.current.component(.day, from: Date())
        
        if year == currentYear && month == currentMonth && day > currentDay {
            birthView.notionLabel.text = "다시 한 번 확인해주세요."
            return false
        }
        
        birthView.notionLabel.text = ""
        return true
    }
    
    private func isLeapYear(_ year: Int) -> Bool {
        return (year % 4 == 0 && year % 100 != 0) || year % 400 == 0
    }
    
    private func validateInputs() -> Bool {
        if validateYear() && validateMonth() && validateDay() {
            birthView.notionLabel.text = ""
        }
        return validateYear() && validateMonth() && validateDay()
    }
}

extension BirthViewController {
    
    //MARK: - @objc Method
    
    //텍스트 필드에 처음 입력을 시작할 때 호출
    @objc private func textFieldDidChange(_ sender: UITextField) {
        [birthView.yearTextField, birthView.monthTextField, birthView.dayTextField].forEach {
            if $0.layer.borderColor != UIColor.primary(.error).cgColor {
                $0.layer.borderColor = UIColor.grayscale(.gray100).cgColor
            }
            else {
                birthView.notionLabel.text = "다시 한 번 확인해주세요."
            }
        }
        if sender.text?.isEmpty ?? true {
            sender.layer.borderColor = UIColor.main(.main2).cgColor
        }
        else if sender.layer.borderColor != UIColor.primary(.error).cgColor {
            sender.layer.borderColor = UIColor.main(.main2).cgColor
        }
    }
    //텍스트 필드에 입력할 때마다 실시간 호출
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
                birthView.notionLabel.text = ""
                textField.layer.borderColor = UIColor.grayscale(.gray100).cgColor
            }
            else if textField.text?.isEmpty ?? true {
                birthView.notionLabel.text = ""
                textField.layer.borderColor = UIColor.main(.main2).cgColor
            }
            else {
                textField.layer.borderColor = UIColor.primary(.error).cgColor
            }
        }
        if textField == birthView.monthTextField {
            if validateMonth() && textField.text?.count == 2 {
                textField.layer.borderColor = UIColor.main(.main2).cgColor
                birthView.dayTextField.becomeFirstResponder()
                birthView.notionLabel.text = ""
            }
            else if validateMonth() && textField.text?.count == 1 {
                textField.layer.borderColor = UIColor.main(.main2).cgColor
            }
            else if textField.text?.isEmpty ?? true {
                birthView.notionLabel.text = ""
                textField.layer.borderColor = UIColor.main(.main2).cgColor
            }
            else {
                textField.layer.borderColor = UIColor.primary(.error).cgColor
            }
        }
        if textField == birthView.dayTextField {
            if validateDay() && textField.text?.count == 2 {
                textField.layer.borderColor = UIColor.main(.main2).cgColor
            }
            else if validateDay() && textField.text?.count == 1 {
                textField.layer.borderColor = UIColor.main(.main2).cgColor
            }
            else if textField.text?.isEmpty ?? true {
                birthView.notionLabel.text = ""
                textField.layer.borderColor = UIColor.main(.main2).cgColor
            }
            else {
                birthView.nextButton.changeState(forState: .isDisabled)
                textField.layer.borderColor = UIColor.primary(.error).cgColor
            }
        }
        
        if validateInputs() {
            birthView.notionLabel.text = ""
            textField.layer.borderColor = UIColor.main(.main2).cgColor
            birthView.nextButton.changeState(forState: .isEnabled)
        }
        if !validateYear() || !validateMonth() || !validateDay() {
            birthView.nextButton.changeState(forState: .isDisabled)
        }
        
        [birthView.yearTextField, birthView.monthTextField, birthView.dayTextField].forEach {
            if $0.layer.borderColor == UIColor.primary(.error).cgColor {
                birthView.notionLabel.text = "다시 한 번 확인해주세요."
            }
        }
    }
    
    // 텍스트필드 편집 종료 후 다른 곳 눌렀을 때 호출
    @objc internal func textFieldDidEndEditing(_ textField: UITextField) {
        // 1자리수를 2자리수로 자동 변환
        if textField == birthView.monthTextField {
            if let monthText = birthView.monthTextField.text, monthText.count == 1 {
                textField.layer.borderColor = UIColor.main(.main2).cgColor
                birthView.monthTextField.text = "0\(monthText)"
            }
        } else if textField == birthView.dayTextField {
            if let dayText = birthView.dayTextField.text, dayText.count == 1 {
                textField.layer.borderColor = UIColor.main(.main2).cgColor
                birthView.dayTextField.text = "0\(dayText)"
            }
        }
        
        [birthView.yearTextField, birthView.monthTextField, birthView.dayTextField].forEach {
            if $0.layer.borderColor == UIColor.primary(.error).cgColor {
                birthView.notionLabel.text = "다시 한 번 확인해주세요."
            }
        }
        
        if validateInputs() {
            birthView.nextButton.changeState(forState: .isEnabled)
        } else {
            birthView.nextButton.changeState(forState: .isDisabled)
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
    //빈 곳 누르면 키보드 내려가게 함
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        [birthView.yearTextField, birthView.monthTextField, birthView.dayTextField].forEach {
            if $0.layer.borderColor != UIColor.primary(.error).cgColor {
                $0.layer.borderColor = UIColor.grayscale(.gray100).cgColor
            }
            else {
                birthView.notionLabel.text = "다시 한 번 확인해주세요."
            }
        }
    }
}
