//
//  ChatLogCellCharacterRecommendation.swift
//  ORB_Dev
//
//  Created by 김민성 on 6/15/25.
//

import UIKit

import SnapKit

final class ChatLogCellCharacterRecommendation: UICollectionViewCell {
    
    /// 레이아웃 계산용 더미 셀. static func인 `calculatedCellSize` 에서 사용
    static let dummyCell = ChatLogCellCharacterRecommendation()
    
    // MARK: - Type Func
    
    static func calculatedCellSize(item: CharacterChatMessageItem, characterName: String, fixedWidth: CGFloat) -> CGSize {
        dummyCell.configure(with: item, characterName: characterName)
        
        let targetSize = CGSize(width: fixedWidth, height: .greatestFiniteMagnitude)
        return dummyCell.contentView.systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
    }
    
    // MARK: - UI Properties
    
    final class ChatBubble: UIView, ORBRecommendationGradientStyle { }
    private(set) var chatBubble = ChatBubble()
    
    private let characterNameLabel = UILabel()
    private let messageLabel = UILabel()
    private let timeLabel = UILabel()
    
    private lazy var contentStack = UIStackView(arrangedSubviews: [characterNameLabel, messageLabel])
    let recommendationButton = RecommendationButtonInChatLogCell()
    private lazy var totalStack = UIStackView(arrangedSubviews: [chatBubble, timeLabel])
    
    /// '오브의 추천소' 버튼이 눌렸을 때 실행할 동작. 외부에서 주입 가능.
    var buttonTapAction: (() -> Void)? = nil
    
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

// Initial Settings
private extension ChatLogCellCharacterRecommendation {
    
    func setupHierarchy() {
        contentView.addSubview(totalStack)
        chatBubble.addSubviews(contentStack, recommendationButton)
    }
    
    func setupStyle() {
        contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
        
        chatBubble.do { view in
            view.backgroundColor = .main(.main3)
            view.roundCorners(cornerRadius: 14)
            view.layer.borderColor = UIColor.neutral(.btnInactive).cgColor
            view.layer.borderWidth = 1
        }
        // 추천소 그라데이션 설정은 layer 설정이 끝난 마지막에 추가되어야 함.
        chatBubble.applyGradientStyle(isBackgroundBlurred: true)
        
        characterNameLabel.do { label in
            label.font = .offroad(style: .iosTextBold)
            label.textColor = .sub(.sub4)
        }
        
        messageLabel.do { label in
            label.font = .offroad(style: .iosText)
            label.textColor = .main(.main2)
            label.numberOfLines = 0
            label.lineBreakStrategy = .pushOut
        }
        
        contentStack.do { stackView in
            stackView.axis = .horizontal
            stackView.spacing = 4
            stackView.alignment = .top
            stackView.distribution = .fillProportionally
        }
        
        timeLabel.do { label in
            label.font = .offroad(style: .iosTextContentsSmall)
            label.textColor = .primary(.white)
            label.textAlignment = .left
        }
        
        totalStack.do { stackView in
            stackView.axis = .horizontal
            stackView.spacing = 6
            stackView.alignment = .bottom
            stackView.distribution = .fill
        }
    }
    
    func setupLayout() {
        characterNameLabel.setContentHuggingPriority(.required, for: .horizontal)
        characterNameLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        messageLabel.setContentHuggingPriority(.required, for: .horizontal)
        messageLabel.setContentCompressionResistancePriority(.init(999), for: .horizontal)
        
        contentStack.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(14)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        recommendationButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(contentStack.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(24.5)
            make.bottom.equalToSuperview().inset(15)
            make.height.equalTo(44)
        }
        
        timeLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        totalStack.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.leading.equalToSuperview().inset(20)
            make.trailing.lessThanOrEqualToSuperview().inset(20)
        }
    }
    
}

extension ChatLogCellCharacterRecommendation {
    
    func configure(with item: CharacterChatMessageItem, characterName: String, buttonTapAction: (() -> Void)? = nil) {
        guard case let .orbRecommendation(content, _, _) = item else {
            fatalError("ChatLogCellCharacterRecommendation received incompatible item.")
        }
        characterNameLabel.text = "\(characterName) :"
        messageLabel.text = content
        timeLabel.text = item.formattedTimeString
        
        self.buttonTapAction = buttonTapAction
        recommendationButton.addTarget(self, action: #selector(self.onButtonTapped), for: .touchUpInside)
    }
    
    @objc private func onButtonTapped() {
        buttonTapAction?()
    }
    
}
