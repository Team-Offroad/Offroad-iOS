//
//  ORBCharacterChatBox.swift
//  Offroad-iOS
//
//  Created by 김민성 on 11/7/24.
//

import UIKit

import Lottie

enum ChatBoxMode {
    // 답장하기 버튼이 있고, 접혀 있을 때 - 캐릭터 선톡 왔을 때
    case withReplyButtonShrinked
    // 답장하기 버튼이 있고, 펼쳐 있을 때 - 사용자가 chenvron 버튼 탭했을 때
    case withReplyButtonExpanded
    // 답장하기 버튼이 없고, 접혀 있을 때 - 로딩 로티 띄울 때
    case withoutReplyButtonShrinked
    // 답장하기 버튼이 없고, 펼쳐 있을 때 - 캐릭터와 채팅중일 때
    case withoutReplyButtonExpanded
}

class ORBCharacterChatBox: UIView {
    
    var mode: ChatBoxMode
    
    let characterNameLabel = UILabel()
    let messageLabel = UILabel()
    let loadingAnimationView = LottieAnimationView(name: "loading2")
    let chevronImageButton = UIButton()
    let replyButton = UIButton()
    
    lazy var messageLabelTrailingConstraintToChevronImageButton = messageLabel.trailingAnchor.constraint(
        equalTo: chevronImageButton.leadingAnchor,
        constant: -2
    )
    lazy var messageLabelTrailingConstraintToSuperview = messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24)
    lazy var replyButtonTopConstraint = replyButton.topAnchor.constraint(
        equalTo: messageLabel.bottomAnchor,
        constant: 10
    )
    lazy var replyButtonBottomConstraint = replyButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -18)
    
    init(mode: ChatBoxMode) {
        self.mode = mode
        super.init(frame: .zero)
        
        setupStyle()
        setupHierarchy()
        setupLayout()
        setupAdditionalLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ORBCharacterChatBox {
    
    //MARK: - Layout Func
    
    private func setupLayout() {
        characterNameLabel.setContentCompressionResistancePriority(.init(999), for: .horizontal)
        characterNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(18)
            make.leading.equalToSuperview().inset(24)
            make.bottom.lessThanOrEqualToSuperview().inset(17)
        }
        
        messageLabel.setContentHuggingPriority(.init(0), for: .horizontal)
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(characterNameLabel)
            make.leading.equalTo(characterNameLabel.snp.trailing).offset(4)
            make.bottom.lessThanOrEqualToSuperview().inset(18)
        }
        
        loadingAnimationView.snp.makeConstraints { make in
            make.centerY.equalTo(characterNameLabel)
            make.leading.equalTo(characterNameLabel.snp.trailing).offset(-10)
            make.width.equalTo(80)
            make.height.equalTo(40)
        }
        
        chevronImageButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(19)
            make.trailing.equalToSuperview().inset(24)
            make.width.equalTo(34)
            make.height.equalTo(22)
        }
        
        replyButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
        }
    }
    
    func setupAdditionalLayout() {
        switch mode {
        case .withReplyButtonShrinked:
            messageLabel.numberOfLines = 1
            messageLabelTrailingConstraintToChevronImageButton.isActive = true
            messageLabelTrailingConstraintToSuperview.isActive = false
            replyButtonTopConstraint.isActive = true
            replyButtonBottomConstraint.isActive = true
        case .withReplyButtonExpanded:
            messageLabel.numberOfLines = 0
            messageLabelTrailingConstraintToChevronImageButton.isActive = true
            messageLabelTrailingConstraintToSuperview.isActive = false
            replyButtonTopConstraint.isActive = true
            replyButtonBottomConstraint.isActive = true
        case .withoutReplyButtonShrinked:
            messageLabel.numberOfLines = 1
            messageLabelTrailingConstraintToChevronImageButton.isActive = false
            messageLabelTrailingConstraintToSuperview.isActive = true
            replyButtonTopConstraint.isActive = false
            replyButtonBottomConstraint.isActive = false
        case .withoutReplyButtonExpanded:
            messageLabel.numberOfLines = 0
            messageLabelTrailingConstraintToChevronImageButton.isActive = false
            messageLabelTrailingConstraintToSuperview.isActive = true
            replyButtonTopConstraint.isActive = false
            replyButtonBottomConstraint.isActive = false
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
            label.contentMode = .topLeft
            switch mode {
            case .withReplyButtonShrinked, .withoutReplyButtonShrinked:
                label.numberOfLines = 1
            case .withReplyButtonExpanded, .withoutReplyButtonExpanded:
                label.numberOfLines = 0
            }
        }
        
        loadingAnimationView.do { animationView in
            animationView.loopMode = .loop
            animationView.contentMode = .scaleAspectFit
            animationView.play()
            animationView.isHidden = true
        }
        
        chevronImageButton.do { button in
            button.setImage(.icnChatViewChevronDown, for: .normal)
        }
        
        replyButton.do { button in
            button.setTitle("답장하기", for: .normal)
            button.setTitleColor(.main(.main3), for: .normal)
            button.configureBackgroundColorWhen(normal: .main(.main2), highlighted: .main(.main2).withAlphaComponent(0.7))
            button.configureTitleFontWhen(normal: .offroad(style: .iosTextContents))
            button.roundCorners(cornerRadius: 8)
            switch mode {
            case .withReplyButtonShrinked, .withReplyButtonExpanded: button.isHidden = false
            case .withoutReplyButtonShrinked, .withoutReplyButtonExpanded: button.isHidden = true
            }
        }
    }
    
    private func setupHierarchy() {
        addSubviews(characterNameLabel, messageLabel, loadingAnimationView, chevronImageButton, replyButton)
    }
    
}
