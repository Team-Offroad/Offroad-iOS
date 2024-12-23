//
//  ZeroDurationAnimator.swift
//  Offroad-iOS
//
//  Created by 김민성 on 9/16/24.
//

import UIKit

class ZeroDurationAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toViewController = transitionContext.viewController(forKey: .to) else { return }
        let containerView = transitionContext.containerView
        
        containerView.addSubview(toViewController.view)
        toViewController.view.frame = containerView.bounds
        
        transitionContext.completeTransition(true)
    }
}
