//
//  ChatLogCellUser.swift
//  Offroad-iOS
//
//  Created by 김민성 on 4/17/25.
//

import UIKit

import Lottie
import SnapKit

final class ChatLogCellUser: UICollectionViewCell {
    
    /// 레이아웃 계산용 더미 셀. static func인 `calculatedCellSize` 에서 사용
    static let dummyCell = ChatLogCellUser()
    
    // MARK: - Type Func
    
    static func calculatedCellSize(item: CharacterChatMessageItem, fixedWidth: CGFloat) -> CGSize {
        dummyCell.configure(with: item)
        
        let targetSize = CGSize(width: fixedWidth, height: .greatestFiniteMagnitude)
        return dummyCell.contentView.systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
    }
    
    // MARK: - UI Properties
    
    private let timeLabel = UILabel()
    private let chatBubble = UIView()
    private let messageLabel = UILabel()
    
    private lazy var totalStack = UIStackView(arrangedSubviews: [timeLabel, chatBubble])
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupHierarchy()
        setupStyle()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Private Func

private extension ChatLogCellUser {
    
    func setupHierarchy() {
        contentView.addSubviews(totalStack)
        chatBubble.addSubviews(messageLabel)
    }
    
    func setupStyle() {
        contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
        
        timeLabel.do { label in
            label.font = .offroad(style: .iosTextContentsSmall)
            label.textColor = .primary(.white)
            label.textAlignment = .right
        }
        
        chatBubble.do { view in
            view.backgroundColor = .main(.main3)
            view.roundCorners(cornerRadius: 14)
            view.layer.borderColor = UIColor.neutral(.btnInactive).cgColor
            view.layer.borderWidth = 1
        }
        
        messageLabel.do { label in
            label.font = .offroad(style: .iosText)
            label.textColor = .main(.main2)
            label.numberOfLines = 0
            label.lineBreakStrategy = .pushOut
        }
        
        totalStack.do { stackView in
            stackView.axis = .horizontal
            stackView.spacing = 6
            stackView.alignment = .bottom
            stackView.distribution = .fill
        }
    }
    
    func setupLayout() {
        timeLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        messageLabel.setContentHuggingPriority(.required, for: .horizontal)
        messageLabel.setContentCompressionResistancePriority(.init(999), for: .horizontal)
        messageLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(14)
            make.horizontalEdges.equalToSuperview().inset(14)
        }
        
        totalStack.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.leading.greaterThanOrEqualToSuperview().inset(20)
            make.trailing.equalToSuperview().inset(20)
        }
    }
    
}

extension ChatLogCellUser {
    
    func configure(with item: CharacterChatMessageItem) {
        guard case let .user(content, _, _) = item else {
            fatalError("ChatLogCellUser received incompatible item.")
        }
        messageLabel.text = content
        timeLabel.text = item.formattedTimeString
    }
    
#if DevTarget
    func setRecommendationMode() {
        contentView.transform = .identity
        timeLabel.textColor = .main(.main2)
    }
#endif
    
}
