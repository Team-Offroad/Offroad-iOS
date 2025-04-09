//
//  PlaceInfoTooltipHelper.swift
//  Offroad-iOS
//
//  Created by 김민성 on 2/6/25.
//

import UIKit

final class PlaceInfoTooltipHelper {
    
    //MARK: - Properties
    
    unowned let tooltip: PlaceInfoTooltip
    let shadingView: UIView
    
    var isTooltipShown: Bool = false
    private let shadingAnimator = UIViewPropertyAnimator(duration: 0.3, dampingRatio: 1)
    private let tooltipTransparencyAnimator = UIViewPropertyAnimator(duration: 0.2, dampingRatio: 1)
    private let tooltipShowingAnimator = UIViewPropertyAnimator(duration: 0.4, dampingRatio: 0.8)
    private let tooltipHidingAnimator = UIViewPropertyAnimator(duration: 0.25, dampingRatio: 1)
    
    //MARK: - Life Cycle
    
    init(tooltip: PlaceInfoTooltip, shadingView: UIView) {
        self.tooltip = tooltip
        self.shadingView = shadingView
        self.shadingView.isUserInteractionEnabled = false
    }
    
}

extension PlaceInfoTooltipHelper {
    
    //MARK: - Func
    
    func showTooltip(completion: (() -> Void)? = nil) {
        tooltip.superview?.bringSubviewToFront(shadingView)
        tooltip.superview?.bringSubviewToFront(tooltip)
        
        tooltip.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        tooltip.isHidden = false
        tooltip.alpha = 0
        tooltip.superview?.layoutIfNeeded()
        tooltipHidingAnimator.stopAnimation(true)
        
        shadingAnimator.addAnimations { [weak self] in
            self?.shadingView.backgroundColor = .blackOpacity(.black25)
        }
        tooltipTransparencyAnimator.addAnimations { [weak self] in
            self?.tooltip.alpha = 1
        }
        tooltipShowingAnimator.addAnimations { [weak self] in
            self?.tooltip.transform = .identity
            self?.tooltip.superview?.layoutIfNeeded()
        }
        tooltipShowingAnimator.addCompletion { _ in
            completion?()
        }
        
        isTooltipShown = true
        shadingView.isUserInteractionEnabled = true
        tooltipTransparencyAnimator.startAnimation()
        shadingAnimator.startAnimation()
        tooltipShowingAnimator.startAnimation()
    }
    
    func hideTooltip(completion: (() -> Void)? = nil) {
        guard isTooltipShown else { return }
        tooltipShowingAnimator.stopAnimation(true)
        
        shadingAnimator.addAnimations { [weak self] in
            self?.shadingView.backgroundColor = .clear
        }
        tooltipHidingAnimator.addAnimations { [weak self] in
            self?.tooltip.transform = CGAffineTransform(scaleX: 0.05, y: 0.05)
        }
        tooltipHidingAnimator.addAnimations({ [weak self] in
            self?.tooltip.alpha = 0
        }, delayFactor: 0.3)
        tooltipHidingAnimator.addCompletion { [weak self] _ in
            self?.tooltip.configure(with: nil)
            self?.tooltip.isHidden = true
            self?.shadingView.isUserInteractionEnabled = false
            completion?()
        }
        isTooltipShown = false
        shadingAnimator.startAnimation()
        tooltipHidingAnimator.startAnimation()
    }
    
    /// 어떤 마커의 위치에서 툴팁이 떴을 때 특정 영역에서 툴팁이 온전히 보이기 위해 화면상에서 마커가 최소한으로 이동해야 하는 거리를 계산하는 함수.
    /// - Parameters:
    ///   - point: 마커의 위치
    ///   - rect: 마커가 존재하는 지도의 frame
    ///   - tooltipSize: 툴팁의 frame의 크기
    ///   - inset: 지도에서 툴팁이 뜰 때 적용될 inset값
    /// - Returns: 툴팁이 온전히 보이기 위해 마커가 최소한으로 이동해야 하는 가로, 세로 point를 각각 x, y 속성으로 갖는 CGPoint
    func caculateDeltaToShowTooltip(point: CGPoint, at mapSize: CGSize, tooltipSize: CGSize, contentInset inset: CGFloat = 0) -> CGPoint {
        var delta: CGPoint = .zero
        
        if point.x < (tooltipSize.width/2 + inset) {
            delta.x = (tooltipSize.width/2 + inset) - point.x
        } else if point.x > mapSize.width - tooltipSize.width/2 - inset {
            delta.x = (mapSize.width - tooltipSize.width/2 - inset) - point.x
        }
        
        // 툴팁의 아래는 마커의 위치로부터 17만큼 위로 떨어져 있음. 마커의 중앙에 툴팁의 꼭짓점이 위치해야 하기 때문.
        if point.y < tooltipSize.height + 17 + inset {
            delta.y = tooltipSize.height + 17 + inset - point.y
        }
        return delta
    }
    
}
