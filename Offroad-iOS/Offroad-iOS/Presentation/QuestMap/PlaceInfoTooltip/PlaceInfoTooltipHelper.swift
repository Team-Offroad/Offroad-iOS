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
    }
    
}

extension PlaceInfoTooltipHelper {
    
    //MARK: - Func
    
    func showTooltip(completion: (() -> Void)? = nil) {
        tooltip.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
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
            self?.shadingView.isUserInteractionEnabled = false
            completion?()
        }
        isTooltipShown = false
        shadingAnimator.startAnimation()
        tooltipHidingAnimator.startAnimation()
    }
    
}
