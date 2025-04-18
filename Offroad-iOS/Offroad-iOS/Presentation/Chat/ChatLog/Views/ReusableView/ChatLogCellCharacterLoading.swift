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
    
    // MARK: - Static Func
    
    static func calculatedCellSize(item: CharacterChatItem, characterName: String, horizontalFixedSize: CGFloat) -> CGSize {
        let cell = ChatLogCellCharacterLoading()
        cell.configure(with: item, characterName: characterName)
        
        let targetSize = CGSize(width: horizontalFixedSize, height: .greatestFiniteMagnitude)
        return cell.contentView.systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
    }
    
    // MARK: - UI Properties
    
    private let chatBubble = UIView()
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
    
    private func setupStyle() {
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
    
    private func setupHierarchy() {
        contentView.addSubview(totalStack)
        chatBubble.addSubview(contentStack)
    }
    
    private func setupLayout() {
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
            assertionFailure("ChatLogCellUser received incompatible item.")
            return
        }
        characternameLabel.text = "\(characterName) :"
        timeLabel.text = item.formattedTimeString
    }
    
}
