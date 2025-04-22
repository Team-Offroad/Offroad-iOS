//
//  ORBRecommendationMainView.swift
//  ORB
//
//  Created by 김민성 on 4/20/25.
//

import UIKit

final class ORBRecommendationMainView: UIView {
    
    let backButton = NavigationPopButton()
    private let titleLabel = UILabel()
    private let titleImageView = UIImageView(image: .btnChecked)
    private lazy var titleStack = UIStackView(arrangedSubviews: [titleLabel, titleImageView])
    let orbMessageView = OBRRecommendationMessageButton(frame: .zero)
    lazy var recommendedContentView = ORBRecommendedContentView(messageButton: orbMessageView)
    
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

private extension ORBRecommendationMainView {
    
    private func setupStyle() {
        backgroundColor = .main(.main1)
        
        backButton.configureButtonTitle(titleString: "홈")
        
        titleLabel.do { label in
            label.text = "오브의 추천소"
            label.font = .offroad(style: .iosTextTitle)
            label.textColor = .main(.main2)
            label.textAlignment = .left
        }
        
        titleStack.do { stackView in
            stackView.axis = .horizontal
            stackView.spacing = 8
            stackView.alignment = .fill
            stackView.distribution = .fillProportionally
        }
    }
    
    private func setupHierarchy() {
        addSubviews(backButton, titleStack, recommendedContentView)
    }
    
    private func setupLayout() {
        backButton.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(12)
            make.leading.equalToSuperview().inset(14)
        }
        
        titleLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        titleImageView.snp.makeConstraints { make in
            make.size.equalTo(24)
        }
        
        titleStack.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(132.5)
            make.leading.equalToSuperview().inset(24)
            make.trailing.lessThanOrEqualToSuperview().inset(24)
        }
        
        recommendedContentView.snp.makeConstraints { make in
            make.top.equalTo(titleStack.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}



final class OBRRecommendationMessageButton: ShrinkableButton, ORBRecommendationGradientStyle {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemBlue
        roundCorners(cornerRadius: 14)
        layer.cornerCurve = .continuous
        applyGradientStyle()
        layer.allowsEdgeAntialiasing = true
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}




