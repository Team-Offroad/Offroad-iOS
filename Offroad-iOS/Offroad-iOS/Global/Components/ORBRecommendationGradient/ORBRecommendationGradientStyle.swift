//
//  ORBRecommendationGradientStyle.swift
//  ORB_Dev
//
//  Created by 김민성 on 4/15/25.
//

import UIKit

/// 오브의 추천소 그라데이션 디자인을 나타낼 수 있는 타입. `UIView`만 채택 가능
protocol ORBRecommendationGradientStyle: UIView {
    
    var gradientBorderWidth: CGFloat { get set }
    var isBackgroundBlurred: Bool { get set }
    
    func applyGradientStyle(borderWidth: CGFloat, isBackgroundBlurred: Bool)
    func removeGradientStyle()
    
}

private var orbRecommendationGradientBaseViewKey: UInt8 = 0
private var isGradientStyleAppliedKey: UInt8 = 1
private var borderWidthCacheKey: UInt8 = 2
extension ORBRecommendationGradientStyle {
    
    private var orbRecommendationBaseBackgroundView: ORBRecommendationBaseBackground? {
        get { objc_getAssociatedObject(self, &orbRecommendationGradientBaseViewKey) as? ORBRecommendationBaseBackground }
        set { objc_setAssociatedObject(self, &orbRecommendationGradientBaseViewKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    private var isGradientStyleApplied: Bool {
        get { (objc_getAssociatedObject(self, &isGradientStyleAppliedKey) as? Bool) ?? false }
        set { objc_setAssociatedObject(self, &isGradientStyleAppliedKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    /// 오브의 추천소 그라데이션 적용 시 `layer.border`를 숨겨야 하므로 `borderWidth`를 0으로 설정함.
    /// 그라데이션을 지울 때 다시 원래의 `borderWidth`로 복원해 주어야 하므로 이를 저장하기 위한 속성.
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
            make.edges.equalToSuperview()
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
    
    /// baseBackground을 뷰의 cornerRaidus에 맞게 조정
    /// corner radius가 바뀌는 경우 `layoutSubviews()` 등에서 이 함수를 호출하여 바뀐 corner radius 반영
    func updateBaseBackgroundCorner() {
        orbRecommendationBaseBackgroundView?.layer.cornerRadius = layer.cornerRadius
        orbRecommendationBaseBackgroundView?.layer.cornerCurve = layer.cornerCurve
        orbRecommendationBaseBackgroundView?.layer.maskedCorners = layer.maskedCorners
    }
    
}
