//
//  ORBCharacterChatBox.swift
//  Offroad-iOS
//
//  Created by 김민성 on 11/7/24.
//

import UIKit

class ORBCharacterChatBox: UIView {
    
    let characterNameLabel = UILabel()
    let messageLabel = UILabel()
    
    init() {
        super.init(frame: .zero)
        
        setupStyle()
        setupHierarchy()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension ORBCharacterChatBox {
    
    //MARK: - Layout Func
    
    private func setupLayout() {
        characterNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(18)
            make.leading.equalToSuperview().inset(24)
            make.bottom.lessThanOrEqualToSuperview().inset(17)
        }
        
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(characterNameLabel)
            make.leading.equalTo(characterNameLabel.snp.trailing).offset(4)
            make.trailing.equalToSuperview().inset(24)
            make.bottom.equalToSuperview().inset(17)
        }
    }
    
    //MARK: - Private Func
    
    private func setupStyle() {
        backgroundColor = .main(.main3)
        roundCorners(cornerRadius: 14)
        layer.borderColor = UIColor.neutral(.btnInactive).cgColor
        layer.borderWidth = 1
        
        characterNameLabel.do { label in
            label.font = .offroad(style: .iosTextBold)
            label.textColor = .sub(.sub4)
        }
        
        messageLabel.do { label in
            label.font = .offroad(style: .iosText)
            label.textColor = .main(.main2)
            label.numberOfLines = 0
        }
    }
    
    private func setupHierarchy() {
        addSubviews(characterNameLabel, messageLabel)
    }
    
}
