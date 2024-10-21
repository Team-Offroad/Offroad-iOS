//
//  ORBAlertViewTextField.swift
//  Offroad-iOS
//
//  Created by 김민성 on 10/19/24.
//

import UIKit

final class ORBAlertViewTextField: ORBAlertBaseView, ORBAlertViewBaseUI {
    
    let type: OFRAlertType = .textField
    let contentView = UIView()
    let defaultTextField = UITextField()
    
    override func setupStyle() {
        super.setupStyle()
        
        defaultTextField.do { textField in
            textField.font = .offroad(style: .iosHint)
            textField.textColor = .primary(.black)
            textField.backgroundColor = .main(.main3)
            textField.layer.borderColor = UIColor.grayscale(.gray200).cgColor
            textField.layer.borderWidth = 1
            textField.clipsToBounds = true
            textField.roundCorners(cornerRadius: 5)
            textField.addPadding(left: 12, right: 12)
        }
    }
    
    override func setupHierarchy() {        
        addSubviews(contentView, closeButton)
        contentView.addSubviews(
            titleLabel,
            messageLabel,
            defaultTextField,
            buttonStackView
        )
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        contentView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(topInset)
            make.leading.equalToSuperview().inset(leftInset)
            make.trailing.equalToSuperview().inset(rightInset)
            make.bottom.equalToSuperview().inset(bottomInset)
            make.height.greaterThanOrEqualTo(182)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }
        titleLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(18)
            make.horizontalEdges.equalToSuperview()
        }
        
        defaultTextField.snp.makeConstraints { make in
            make.top.equalTo(messageLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(43)
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(defaultTextField.snp.bottom).offset(18)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }
    
}
