//
//  ORBRecommendationBaseBackground.swift
//  ORB_Dev
//
//  Created by 김민성 on 4/15/25.
//

import UIKit

/// 오브의 추천소 그라데이션 배경이 되는 뷰. 테두리 포함.
final class ORBRecommendationBaseBackground: UIView {
    
    // MARK: - Private Properties
    
    private let gradient = ORBRecommendationGradientLayer()
    private let blur = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
    
    // MARK: - Properties
    
    var gradientBorderWidth: CGFloat {
        didSet { layoutIfNeeded() }
    }
    
    var isBackgroundBlurred: Bool {
        didSet { blur.contentView.alpha = isBackgroundBlurred ? 0.7 : 1 }
    }
    
    // MARK: - Life Cycle
    
    init(borderWidth: CGFloat = 1, isBackgroundBlurred: Bool = true) {
        self.gradientBorderWidth = borderWidth
        self.isBackgroundBlurred = isBackgroundBlurred
        self.blur.contentView.alpha = isBackgroundBlurred ? 0.7 : 1
        super.init(frame: .zero)
        
        isUserInteractionEnabled = false
        clipsToBounds = true
        blur.clipsToBounds = true
        blur.contentView.backgroundColor = .white
        
        layer.addSublayer(gradient)
        addSubview(blur)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // 뷰의 크기가 작아지는 애니메이션에서 gradient가 잘리는 현상이 없도록 30만큼 여유분 설정
        gradient.frame = bounds.insetBy(dx: -30, dy: -30)
        
        let borderWidth = gradientBorderWidth
        blur.frame = bounds.insetBy(dx: borderWidth, dy: borderWidth)
        blur.layer.cornerRadius = layer.cornerRadius - borderWidth
        blur.layer.cornerCurve = layer.cornerCurve
        blur.layer.maskedCorners = layer.maskedCorners
    }
    
}
