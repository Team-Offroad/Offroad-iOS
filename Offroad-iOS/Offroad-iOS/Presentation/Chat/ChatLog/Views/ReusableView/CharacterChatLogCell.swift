//
//  CharacterChatLogCell.swift
//  Offroad-iOS
//
//  Created by 김민성 on 11/13/24.
//

import UIKit

class CharacterChatLogCell: UICollectionViewCell {
    
    enum CellType: String {
        case user =  "USER"
        case character = "ORB_CHARACTER"
    }
    
    //MARK: - Properties
    
    private var role: CellType = .user
    
    //MARK: - UI Properties
    
    private let chatBubbleView = UIView()
    let messageLabel = UILabel()
    private let characternameLabel = UILabel()
    private let timeLabel = UILabel()
    
    //MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setupStyle()
        setupHierarchy()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        NSLayoutConstraint.deactivate(contentView.constraints)
    }
    
}

extension CharacterChatLogCell {
    
    //MARK: - Layout Func
    
    private func setupLayout() {
        characternameLabel.setContentCompressionResistancePriority(.init(999), for: .horizontal)
        timeLabel.setContentCompressionResistancePriority(.init(999), for: .horizontal)
    }
    
    //MARK: - Private Func
    
    private func setupStyle() {
        chatBubbleView.backgroundColor = .main(.main3)
        chatBubbleView.roundCorners(cornerRadius: 14)
        chatBubbleView.layer.borderColor = UIColor.neutral(.btnInactive).cgColor
        chatBubbleView.layer.borderWidth = 1
        
        messageLabel.do { label in
            label.font = .offroad(style: .iosText)
            label.textColor = .main(.main2)
            label.numberOfLines = 0
        }
        
        characternameLabel.do { label in
            label.font = .offroad(style: .iosTextBold)
            label.textColor = .sub(.sub4)
        }
        
        timeLabel.do { label in
            label.font = .offroad(style: .iosTextContentsSmall)
            label.textColor = .primary(.white)
        }
    }
    
    private func setupHierarchy() {
        contentView.addSubviews(chatBubbleView, timeLabel)
        chatBubbleView.addSubviews(characternameLabel, messageLabel)
    }
    
    //MARK: - Func
    
    func configure(with model: ChatDataModel, characterName: String) {
        if model.role == "USER" {
            characternameLabel.text = ""
            characternameLabel.isHidden = true
            messageLabel.snp.remakeConstraints { make in
                make.top.bottom.equalToSuperview().inset(14)
                make.trailing.equalToSuperview().inset(20)
                make.leading.equalToSuperview().inset(20)
            }
            chatBubbleView.snp.remakeConstraints { make in
                make.verticalEdges.equalToSuperview()
                make.trailing.equalToSuperview().inset(20)
            }
            timeLabel.snp.remakeConstraints { make in
                make.leading.greaterThanOrEqualToSuperview().inset(20)
                make.trailing.equalTo(chatBubbleView.snp.leading).offset(-6)
                make.bottom.equalToSuperview()
            }
        // data.role = "ORB_CHARACTER"
        } else {
            characternameLabel.text = "\(characterName) :"
            characternameLabel.isHidden = false
            characternameLabel.snp.remakeConstraints { make in
                make.top.equalToSuperview().inset(14)
                make.leading.equalToSuperview().inset(20)
            }
            messageLabel.snp.remakeConstraints { make in
                make.leading.equalTo(characternameLabel.snp.trailing).offset(4)
                make.top.bottom.equalToSuperview().inset(14)
                make.trailing.equalToSuperview().inset(20)
            }
            chatBubbleView.snp.remakeConstraints { make in
                make.verticalEdges.equalToSuperview()
                make.leading.equalToSuperview().inset(20)
            }
            timeLabel.snp.remakeConstraints { make in
                make.leading.equalTo(chatBubbleView.snp.trailing).offset(6)
                make.trailing.lessThanOrEqualToSuperview().inset(20)
                make.bottom.equalToSuperview()
            }
        }
        
        messageLabel.text = model.content
        timeLabel.text = model.formattedTimeString
        
        updateConstraints()
        layoutIfNeeded()
    }
    
}
