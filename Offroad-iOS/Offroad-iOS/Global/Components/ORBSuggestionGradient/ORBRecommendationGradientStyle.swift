//
//  ORBRecommendationGradientStyle.swift
//  ORB_Dev
//
//  Created by 김민성 on 4/15/25.
//

import UIKit

protocol ORBRecommendationGradientStyle: UIView {
    
    var gradientBorderWidth: CGFloat { get set }
    var isBackgroundBlurred: Bool { get set }
    
    func applyGradientStyle(borderWidth: CGFloat, isBackgroundBlurred: Bool)
    func removeGradientStyle()
    
}

fileprivate var orbRecommendationGradientBaseViewKey: UInt8 = 0
fileprivate var isGradientStyleAppliedKey: UInt8 = 1
fileprivate var borderWidthCacheKey: UInt8 = 2
extension ORBRecommendationGradientStyle {
    
    private var orbRecommendationBaseBackgroundView: ORBRecommendationBaseBackground? {
        get { objc_getAssociatedObject(self, &orbRecommendationGradientBaseViewKey) as? ORBRecommendationBaseBackground }
        set { objc_setAssociatedObject(self, &orbRecommendationGradientBaseViewKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    private var isGradientStyleApplied: Bool {
        get { (objc_getAssociatedObject(self, &isGradientStyleAppliedKey) as? Bool) ?? false }
        set { objc_setAssociatedObject(self, &isGradientStyleAppliedKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    private var borderWidthCache: CGFloat {
        get { objc_getAssociatedObject(self, &borderWidthCacheKey) as? CGFloat ?? 0 }
        set { objc_setAssociatedObject(self, &borderWidthCacheKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    /// 그라데이션 효과가 적용될 테두리 두께.
    var gradientBorderWidth: CGFloat {
        get { return orbRecommendationBaseBackgroundView?.gradientBorderWidth ?? 1 }
        set { orbRecommendationBaseBackgroundView?.gradientBorderWidth = newValue }
    }
    
    /// 배경에 (블러가 적용된) 그라데이션 효과를 적용할 지 여부. `true`인 경우 배경에도 연한 블러 그라데이션 효과가 적용됨. `false`인 경우 배경은 흰색 적용.
    var isBackgroundBlurred: Bool {
        get { return orbRecommendationBaseBackgroundView?.isBackgroundBlurred ?? true }
        set { orbRecommendationBaseBackgroundView?.isBackgroundBlurred = newValue }
    }
    
    func applyGradientStyle(borderWidth: CGFloat = 1, isBackgroundBlurred: Bool = true) {
        guard !isGradientStyleApplied else { return }
        
        if let baseBackgroundView = orbRecommendationBaseBackgroundView {
            baseBackgroundView.gradientBorderWidth = borderWidth
            baseBackgroundView.isBackgroundBlurred = isBackgroundBlurred
            insertSubview(baseBackgroundView, at: 0)
        } else {
            orbRecommendationBaseBackgroundView = ORBRecommendationBaseBackground(
                borderWidth: borderWidth,
                isBackgroundBlurred: isBackgroundBlurred
            )
            insertSubview(orbRecommendationBaseBackgroundView!, at: 0)
        }
        orbRecommendationBaseBackgroundView!.snp.makeConstraints { make in
            make.edges.equalToSuperview()//.priority(.init(999))
        }
        layoutIfNeeded()
        orbRecommendationBaseBackgroundView!.clipsToBounds = true
        orbRecommendationBaseBackgroundView!.alpha = 1
        updateBaseBackgroundCorner()
        borderWidthCache = layer.borderWidth
        layer.borderWidth = 0
        
        isGradientStyleApplied = true
    }
    
    func removeGradientStyle() {
        guard isGradientStyleApplied else { return }
        orbRecommendationBaseBackgroundView?.alpha = 0
        layer.borderWidth = borderWidthCache
        isGradientStyleApplied = false
    }
    
    func updateBaseBackgroundCorner() {
        orbRecommendationBaseBackgroundView?.layer.cornerRadius = layer.cornerRadius
        orbRecommendationBaseBackgroundView?.layer.cornerCurve = layer.cornerCurve
        orbRecommendationBaseBackgroundView?.layer.maskedCorners = layer.maskedCorners
    }
    
}
