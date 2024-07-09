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
    
    private let textField = UITextField().then {
        $0.borderStyle = .roundedRect
        $0.placeholder = "닉네임을 입력하세요"
    }

    private let checkButton = UIButton(type: .system).then {
        $0.setTitle("중복확인", for: .normal)
        $0.setTitleColor(.gray, for: .normal)
        $0.backgroundColor = .lightGray
        $0.isEnabled = false
        $0.layer.cornerRadius = 5
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        setupConstraints()

        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    private func setupViews() {
        view.addSubview(textField)
        view.addSubview(checkButton)
    }
    
    private func setupConstraints() {
        textField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(100)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
        
        checkButton.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(20)
            make.leading.trailing.equalTo(textField)
            make.height.equalTo(40)
        }
    }

    @objc private func textFieldDidChange() {
        let isTextFieldEmpty = textField.text?.isEmpty ?? true
        checkButton.isEnabled = !isTextFieldEmpty
        checkButton.setTitleColor(isTextFieldEmpty ? .gray : .white, for: .normal)
        checkButton.backgroundColor = isTextFieldEmpty ? .lightGray : .black
    }
}

