//
//  NicknameViewController.swift
//  Offroad-iOS
//
//  Created by  정지원 on 7/9/24.
//

import UIKit

import SnapKit
import Then

class NicknameViewController: UIViewController {
    
    private let mainLabel = UILabel().then {
        $0.text = "모험가 프로필 작성"
        $0.textAlignment = .center
        $0.textColor = UIColor.main(.main2)
        $0.font = UIFont.offroad(style: .iosProfileTitle)
    }
    
    private let subLabel = UILabel().then {
        $0.text = "어떤 이름으로 불러드릴까요?"
        $0.textAlignment = .center
        $0.textColor = UIColor.main(.main2)
        $0.font = UIFont.offroad(style: .iosSubtitleReg)
    }
    
    private let textField = UITextField().then {
        $0.borderStyle = .roundedRect
        $0.frame.size.height = 48
        $0.backgroundColor = UIColor.main(.main3)
        $0.layer.borderWidth = 1.0
        $0.layer.cornerRadius = 5
        $0.layer.borderColor = UIColor.grayscale(.gray100).cgColor
        $0.attributedPlaceholder = NSAttributedString(
            string: "닉네임을 입력",
            attributes: [NSAttributedString.Key.font: UIFont.offroad(style: .iosTextAuto), NSAttributedString.Key.foregroundColor: UIColor.grayscale(.gray300)]
        )
    }
    
    private let checkButton = UIButton(type: .system).then {
        $0.setTitle("중복확인", for: .normal)
        $0.titleLabel?.textAlignment = .center
        $0.titleLabel?.font = UIFont.offroad(style: .iosBtnSmall)
        $0.setTitleColor(UIColor.grayscale(.gray300), for: .normal)
        $0.backgroundColor = UIColor.main(.main3)
        $0.layer.borderWidth = 1.0
        $0.layer.borderColor = UIColor.grayscale(.gray100).cgColor
        $0.layer.cornerRadius = 5
        $0.isEnabled = false
    }
    
    private let textFieldStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .fill
        $0.distribution = .fillProportionally
    }
    
    private let notionLabel = UILabel().then {
        $0.text = "*한글 2~8자, 영어 2~16자 이내로 작성해주세요."
        $0.textColor = UIColor.grayscale(.gray400)
        $0.font = UIFont.offroad(style: .iosHint)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.main(.main1)
        setupViews()
        setupConstraints()
        
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    private func setupViews() {
        view.addSubview(mainLabel)
        view.addSubview(subLabel)
        view.addSubview(textFieldStackView)
        textFieldStackView.addSubview(textField)
        textFieldStackView.addSubview(checkButton)
        view.addSubview(notionLabel)
        
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
        
        textFieldStackView.snp.makeConstraints { make in
            make.top.equalTo(subLabel.snp.bottom).offset(64)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(48)
        }
        
        textField.snp.makeConstraints { make in
            make.leading.equalTo(textFieldStackView)
            make.height.equalTo(48)
        }
        
        checkButton.snp.makeConstraints { make in
            make.leading.equalTo(textField.snp.trailing).offset(14)
            make.trailing.equalTo(textFieldStackView)
            make.height.equalTo(48)
            make.width.equalTo(90)
        }
        
        notionLabel.snp.makeConstraints { make in
            make.top.equalTo(textFieldStackView.snp.bottom).offset(12)
            make.leading.equalToSuperview().inset(24)
        }
    }
    
    @objc private func textFieldDidChange() {
        let isTextFieldEmpty = textField.text?.isEmpty ?? true
        if textField.isEnabled == true {
            textField.layer.borderColor = UIColor.sub(.sub).cgColor
        }
        checkButton.isEnabled = !isTextFieldEmpty
        checkButton.setTitleColor(isTextFieldEmpty ? UIColor.grayscale(.gray100) : UIColor.primary(.white), for: .normal)
        checkButton.backgroundColor = isTextFieldEmpty ? UIColor.main(.main3) : UIColor.primary(.black)
    }
}

