//
//  ORBCharacterChatBox.swift
//  Offroad-iOS
//
//  Created by 김민성 on 11/7/24.
//

import UIKit

enum ChatBoxMode {
    case withReplyButton
    case withoutReplyButton
}

class ORBCharacterChatBox: UIView {
    
    var mode: ChatBoxMode
    
    let characterNameLabel = UILabel()
    let messageLabel = UILabel()
    let replyButton = UIButton()
    
    lazy var messageLabelBottomConstraintToChatBox = messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -18)
    lazy var messageLabelBottomConstraintToReplyButton = messageLabel.bottomAnchor.constraint(
        equalTo: replyButton.topAnchor,
        constant: -10
    )
    lazy var replyButtonBottomConstraint = replyButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -18)
    
    init(mode: ChatBoxMode) {
        self.mode = mode
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
    
    func setupLayout() {
        characterNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(18)
            make.leading.equalToSuperview().inset(24)
            make.bottom.lessThanOrEqualToSuperview().inset(17)
        }
        
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(characterNameLabel)
            make.leading.equalTo(characterNameLabel.snp.trailing).offset(4)
            make.trailing.equalToSuperview().inset(24)
        }
        
        replyButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
        }
        
        messageLabelBottomConstraintToReplyButton.isActive = mode == .withReplyButton ? true : false
        messageLabelBottomConstraintToChatBox.isActive = mode == .withReplyButton ? false : true
        replyButtonBottomConstraint.isActive = mode == .withReplyButton ? true : false
        
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
        
        replyButton.do { button in
            button.setTitle("답장하기", for: .normal)
            button.setTitleColor(.main(.main3), for: .normal)
            button.configureBackgroundColorWhen(normal: .main(.main2), highlighted: .main(.main2).withAlphaComponent(0.7))
            button.configureTitleFontWhen(normal: .offroad(style: .iosTextContents))
            button.roundCorners(cornerRadius: 8)
            switch mode {
            case .withReplyButton: button.isHidden = false
            case .withoutReplyButton: button.isHidden = true
            }
        }
    }
    
    private func setupHierarchy() {
        addSubviews(characterNameLabel, messageLabel, replyButton)
    }
    
}
