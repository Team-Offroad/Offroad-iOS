//
//  ChatLogCellCharacterLoading.swift
//  Offroad-iOS
//
//  Created by 김민성 on 4/17/25.
//

import UIKit

import Lottie
import SnapKit

final class ChatLogCellCharacterLoading: UICollectionViewCell {
    
    /// 레이아웃 계산용 더미 셀. static func인 `calculatedCellSize` 에서 사용
    static let dummyCell = ChatLogCellCharacterLoading()
    
    // MARK: - Static Func
    
    static func calculatedCellSize(item: CharacterChatItem, characterName: String, fixedWidth: CGFloat) -> CGSize {
        dummyCell.configure(with: item, characterName: characterName)
        
        let targetSize = CGSize(width: fixedWidth, height: .greatestFiniteMagnitude)
        return dummyCell.contentView.systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
    }
    
    // MARK: - UI Properties
    
#if DevTarget
    final class ChatBubble: UIView, ORBRecommendationGradientStyle { }
    private let chatBubble = ChatBubble()
#else
    private let chatBubble = UIView()
#endif
    private let characternameLabel = UILabel()
    private let loadingAnimationView = LottieAnimationView(name: "loading2")
    private let timeLabel = UILabel()
    
    private lazy var contentStack = UIStackView(arrangedSubviews: [characternameLabel, loadingAnimationView])
    private lazy var totalStack = UIStackView(arrangedSubviews: [chatBubble, timeLabel])
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupStyle()
        setupHierarchy()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Private Func

private extension ChatLogCellCharacterLoading {
    
    func setupStyle() {
        contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
        
        chatBubble.do { view in
            view.backgroundColor = .main(.main3)
            view.roundCorners(cornerRadius: 14)
            view.layer.borderColor = UIColor.neutral(.btnInactive).cgColor
            view.layer.borderWidth = 1
        }
        
        characternameLabel.do { label in
            label.font = .offroad(style: .iosTextBold)
            label.textColor = .sub(.sub4)
        }
        
        loadingAnimationView.do { animationView in
            animationView.loopMode = .loop
            animationView.contentMode = .scaleAspectFit
            animationView.play()
        }
        
        contentStack.do { stackView in
            stackView.axis = .horizontal
            stackView.alignment = .center
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
            stackView.distribution = .fillProportionally
        }
    }
    
    func setupHierarchy() {
        contentView.addSubview(totalStack)
        chatBubble.addSubview(contentStack)
    }
    
    func setupLayout() {
        characternameLabel.setContentHuggingPriority(.required, for: .vertical)
        characternameLabel.setContentHuggingPriority(.required, for: .horizontal)
        characternameLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        loadingAnimationView.setContentCompressionResistancePriority(.required, for: .horizontal)
        loadingAnimationView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        loadingAnimationView.snp.makeConstraints { make in
            make.width.equalTo(80)
            make.height.equalTo(40)
        }
        
        contentStack.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(4)
            make.leading.equalToSuperview().inset(20)
            make.trailing.equalToSuperview()
        }
        
        timeLabel.setContentHuggingPriority(.init(1), for: .horizontal)
        timeLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        totalStack.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(20)
        }
    }
    
}

extension ChatLogCellCharacterLoading {
    
    func configure(with item: CharacterChatItem, characterName: String) {
        guard case .loading = item else {
            fatalError("ChatLogCellCharacterLoading received incompatible item.")
        }
        characternameLabel.text = "\(characterName) :"
        timeLabel.text = item.formattedTimeString
    }
    
#if DevTarget
    func setRecommendationMode() {
        chatBubble.applyGradientStyle(isBackgroundBlurred: false)
        contentView.transform = .identity
        timeLabel.textColor = .main(.main2)
    }
#endif
    
}
