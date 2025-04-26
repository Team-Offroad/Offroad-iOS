//
//  ORBRecommendationMessageButton.swift
//  ORB_Dev
//
//  Created by 김민성 on 4/24/25.
//

import UIKit

import SnapKit
import Then

/// 오브의 추천소 메인 화면에서 오브의 메시지를 표시하는 버튼.
final class ORBRecommendationMessageButton: ShrinkableButton, ORBRecommendationGradientStyle {
    
    /// 버튼에 표시될 메시지.
    var message: String = "" {
        didSet {
            orbMessageLabel.text = message
            accessibilityLabel = message
        }
    }
    
    private let orbMessageLabel = UILabel()
    private let chatBubbleImageView = UIImageView(image: .icnOrbRecommendationMainMessage)
    private let rightChevronImageView = UIImageView(image: .icnChatViewChevronDown)
    
    init() {
        super.init(shrinkScale: 0.97)
        
        setupStyle()
        setupHierarchy()
        setupLayout()
        
        roundCorners(cornerRadius: 14)
        layer.cornerCurve = .continuous
        applyGradientStyle()
        layer.allowsEdgeAntialiasing = true
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// Initial Setting
private extension ORBRecommendationMessageButton {
    
    func setupStyle() {
        titleLabel?.isHidden = true
        titleLabel?.text = ""
        
        orbMessageLabel.do { label in
            label.textColor = .main(.main2)
            label.font = .offroad(style: .iosBoxMedi)
            label.numberOfLines = 2
            label.textAlignment = .left
            label.setContentHuggingPriority(.defaultLow, for: .horizontal)
            label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        }
        
        chatBubbleImageView.contentMode = .scaleAspectFit
        rightChevronImageView.contentMode = .scaleAspectFit
        rightChevronImageView.transform = .init(rotationAngle: -.pi/2)
    }
    
    func setupHierarchy() {
        addSubviews(orbMessageLabel, chatBubbleImageView, rightChevronImageView)
    }
    
    func setupLayout() {
        orbMessageLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(20.5)
            make.leading.equalToSuperview().inset(25)
        }
        
        chatBubbleImageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        chatBubbleImageView.snp.makeConstraints { make in
            make.leading.equalTo(orbMessageLabel.snp.trailing).offset(12)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(36)
        }
        
        rightChevronImageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        rightChevronImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
        }
    }
    
}
