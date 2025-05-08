//
//  ORBRecommendationChatPresentationFloatingView.swift
//  ORB_Dev
//
//  Created by 김민성 on 5/4/25.
//

import UIKit

/// 오브의 추천소 채팅창을 `present`할 때 버튼이 채팅창으로 이동하는 것처럼 보이기 위해 커스텀 트랜지션 중에 활용되는 뷰
final class ORBRecommendationChatPresentationFloatingView: UIView, ORBRecommendationGradientStyle {
    
    // MARK: - UI Properties
    
    private let characternameLabel = UILabel()
    private let messageLabel = UILabel()
    private lazy var contentStack = UIStackView(arrangedSubviews: [characternameLabel, messageLabel])
    
    // MARK: - Life Cycle
    
    init(text: String) {
        self.messageLabel.text = text
        super.init(frame: .zero)
        
        setupStyle()
        setupHierarchy()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        updateBaseBackgroundCorner()
    }
    
}

// Initial Settings
private extension ORBRecommendationChatPresentationFloatingView {
    
    func setupStyle() {
        roundCorners(cornerRadius: 14)
        layer.cornerCurve = .continuous
        applyGradientStyle(isBackgroundBlurred: false)
        
        characternameLabel.do { label in
            label.text = "오브 :"
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
            stackView.distribution = .fill
        }
    }
    
    func setupHierarchy() {
        addSubview(contentStack)
    }
    
    func setupLayout() {
        characternameLabel.setContentHuggingPriority(.required, for: .horizontal)
        characternameLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        messageLabel.setContentHuggingPriority(.required, for: .horizontal)
        messageLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        contentStack.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(14)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
    }
    
}
