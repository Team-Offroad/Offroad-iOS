//
//  BirthViewController.swift
//  Offroad-iOS
//
//  Created by  정지원 on 7/9/24.
//

import UIKit

import SnapKit
import Then

final class BirthViewController: UIViewController, UITextFieldDelegate {
    
    private let mainLabel = UILabel().then {
        $0.text = "모험가 프로필 작성"
        $0.textAlignment = .center
        $0.textColor = UIColor.main(.main2)
        $0.font = UIFont.offroad(style: .iosProfileTitle)
    }
    
    private let subLabel = UILabel().then {
        $0.text = "나이를 알려주세요."
        $0.textAlignment = .center
        $0.textColor = UIColor.main(.main2)
        $0.font = UIFont.offroad(style: .iosSubtitleReg)
    }
    
    private let birthLabel = UILabel().then {
        $0.text = "생년월일 입력"
        $0.textAlignment = .center
        $0.textColor = UIColor.main(.main2)
        $0.font = UIFont.offroad(style: .iosSubtitle2Semibold)
    }
    
    private let yearTextField = UITextField().then {
        $0.keyboardType = .numberPad
        $0.backgroundColor = UIColor.main(.main3)
        $0.layer.borderWidth = 1.0
        $0.layer.cornerRadius = 5
        $0.layer.borderColor = UIColor.grayscale(.gray100).cgColor
        $0.textAlignment = .center
        $0.attributedPlaceholder = NSAttributedString(
            string: "YYYY",
            attributes: [NSAttributedString.Key.font: UIFont.offroad(style: .iosTextAuto), NSAttributedString.Key.foregroundColor: UIColor.grayscale(.gray300)]
        )
    }
    
    private let monthTextField = UITextField().then {
        $0.keyboardType = .numberPad
        $0.backgroundColor = UIColor.main(.main3)
        $0.layer.borderWidth = 1.0
        $0.layer.cornerRadius = 5
        $0.layer.borderColor = UIColor.grayscale(.gray100).cgColor
        $0.textAlignment = .center
        $0.attributedPlaceholder = NSAttributedString(
            string: "MM",
            attributes: [NSAttributedString.Key.font: UIFont.offroad(style: .iosTextAuto), NSAttributedString.Key.foregroundColor: UIColor.grayscale(.gray300)]
        )
    }
    
    private let dayTextField = UITextField().then {
        $0.keyboardType = .numberPad
        $0.backgroundColor = UIColor.main(.main3)
        $0.layer.borderWidth = 1.0
        $0.layer.cornerRadius = 5
        $0.layer.borderColor = UIColor.grayscale(.gray100).cgColor
        $0.textAlignment = .center
        $0.attributedPlaceholder = NSAttributedString(
            string: "DD",
            attributes: [NSAttributedString.Key.font: UIFont.offroad(style: .iosTextAuto), NSAttributedString.Key.foregroundColor: UIColor.grayscale(.gray300)]
        )
    }
    
    private let yearLabel = UILabel().then {
        $0.text = "년"
        $0.textColor = UIColor.main(.main2)
        $0.font = UIFont.offroad(style: .iosSubtitleReg)
    }
    
    private let monthLabel = UILabel().then {
        $0.text = "월"
        $0.textColor = UIColor.main(.main2)
        $0.font = UIFont.offroad(style: .iosSubtitleReg)
    }
    
    private let dayLabel = UILabel().then {
        $0.text = "일"
        $0.textColor = UIColor.main(.main2)
        $0.font = UIFont.offroad(style: .iosSubtitleReg)
    }
    
    private let nextButton = UIButton().then {
        $0.setTitle("다음", for: .normal)
        $0.titleLabel?.textAlignment = .center
        $0.titleLabel?.font = UIFont.offroad(style: .iosTextRegular)
        $0.setTitleColor(UIColor.main(.main1), for: .normal)
        $0.backgroundColor = UIColor.main(.main2)
        $0.layer.cornerRadius = 5
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.main(.main1)
        setupViews()
        setupConstraints()
        
        yearTextField.delegate = self
        monthTextField.delegate = self
        dayTextField.delegate = self
        
        yearTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingDidBegin)
        monthTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingDidBegin)
        dayTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingDidBegin)
        
        yearTextField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        monthTextField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        dayTextField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
    }
    
    private func setupViews() {
        view.addSubview(mainLabel)
        view.addSubview(subLabel)
        view.addSubview(birthLabel)
        view.addSubview(yearTextField)
        view.addSubview(monthTextField)
        view.addSubview(dayTextField)
        view.addSubview(yearLabel)
        view.addSubview(monthLabel)
        view.addSubview(dayLabel)
        view.addSubview(nextButton)
    }
    
    private func setupConstraints() {
        
        mainLabel.snp.makeConstraints{ make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(97)
            make.leading.trailing.equalToSuperview().inset(63)
        }
        
        subLabel.snp.makeConstraints{ make in
            make.top.equalTo(mainLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(63)
        }
        
        birthLabel.snp.makeConstraints{ make in
            make.top.equalTo(subLabel.snp.bottom).offset(64)
            make.leading.equalToSuperview().inset(24)
        }
        
        yearTextField.snp.makeConstraints { make in
            make.top.equalTo(birthLabel.snp.bottom).offset(14)
            make.leading.equalToSuperview().inset(24)
            make.height.equalTo(48)
            make.width.equalTo(93)
        }
        
        yearLabel.snp.makeConstraints { make in
            make.top.equalTo(birthLabel.snp.bottom).offset(26)
            make.leading.equalTo(yearTextField.snp.trailing).offset(6)
        }
        
        monthTextField.snp.makeConstraints { make in
            make.top.equalTo(birthLabel.snp.bottom).offset(14)
            make.leading.equalTo(yearLabel.snp.trailing).offset(6)
            make.height.equalTo(48)
            make.width.equalTo(73)
        }
        
        monthLabel.snp.makeConstraints { make in
            make.top.equalTo(birthLabel.snp.bottom).offset(26)
            make.leading.equalTo(monthTextField.snp.trailing).offset(6)
        }
        
        dayTextField.snp.makeConstraints { make in
            make.top.equalTo(birthLabel.snp.bottom).offset(14)
            make.leading.equalTo(monthLabel.snp.trailing).offset(6)
            make.height.equalTo(48)
            make.width.equalTo(73)
        }
        
        dayLabel.snp.makeConstraints { make in
            make.top.equalTo(birthLabel.snp.bottom).offset(26)
            make.leading.equalTo(dayTextField.snp.trailing).offset(6)
        }
        
        nextButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(54)
        }
    }
    
    @objc private func textFieldDidChange(_ sender: UITextField) {
        if sender == yearTextField {
            yearTextField.layer.borderColor = UIColor.sub(.sub).cgColor
            monthTextField.layer.borderColor = UIColor.grayscale(.gray100).cgColor
            dayTextField.layer.borderColor = UIColor.grayscale(.gray100).cgColor
        } else if sender == monthTextField {
            yearTextField.layer.borderColor = UIColor.grayscale(.gray100).cgColor
            monthTextField.layer.borderColor = UIColor.sub(.sub).cgColor
            dayTextField.layer.borderColor = UIColor.grayscale(.gray100).cgColor
        } else if sender == dayTextField {
            yearTextField.layer.borderColor = UIColor.grayscale(.gray100).cgColor
            monthTextField.layer.borderColor = UIColor.grayscale(.gray100).cgColor
            dayTextField.layer.borderColor = UIColor.sub(.sub).cgColor
        }
    }
    
    @objc private func textFieldEditingChanged(_ textField: UITextField) {
        let maxLength: Int
        if textField == yearTextField {
            maxLength = 4
        } else {
            maxLength = 2
        }
        if let text = textField.text, text.count > maxLength {
            textField.text = String(text.prefix(maxLength))
        }
    }
    
    // 텍스트 필드 글자 수 제한
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
}
