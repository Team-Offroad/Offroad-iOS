//
//  ORBRecommendationChatViewDismissingTransition.swift
//  ORB_Dev
//
//  Created by 김민성 on 5/4/25.
//

import UIKit

final class ORBRecommendationChatViewDismissingTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    let duration: TimeInterval = 0.5
    lazy var animator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1)
    
    func transitionDuration(using transitionContext: (any UIViewControllerContextTransitioning)?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: any UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.view(forKey: .from) else {
            transitionContext.completeTransition(true)
            return
        }
        animator.addAnimations {
            fromView.alpha = 0
        }
        animator.addCompletion { _ in
            transitionContext.completeTransition(true)
        }
        animator.startAnimation()
    }
    
}
