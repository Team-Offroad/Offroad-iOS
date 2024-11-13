//
//  ChatLogNavigationAnimator.swift
//  Offroad-iOS
//
//  Created by 김민성 on 11/13/24.
//

import UIKit

class ChatLogPushAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: (any UIViewControllerContextTransitioning)?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: any UIViewControllerContextTransitioning) {
        guard let toView = transitionContext.view(forKey: .to),
              let fromView = transitionContext.view(forKey: .from) else {
            transitionContext.completeTransition(false)
            return
        }
        
        let containerView = transitionContext.containerView
        containerView.addSubview(toView)
        toView.frame = fromView.frame.offsetBy(dx: fromView.frame.width, dy: 0)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, animations: {
            toView.frame = fromView.frame
        }, completion: { finished in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
    
}

class ChatLogPopAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    var isInteractive = false
    
    func transitionDuration(using transitionContext: (any UIViewControllerContextTransitioning)?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: any UIViewControllerContextTransitioning) {
        guard let toView = transitionContext.view(forKey: .to),
              let fromView = transitionContext.view(forKey: .from) else {
            transitionContext.completeTransition(false)
            return
        }
        
        let containerView = transitionContext.containerView
        let finalFrame = fromView.frame.offsetBy(dx: fromView.frame.width, dy: 0)
        containerView.insertSubview(toView, belowSubview: fromView)
        
        if transitionContext.isInteractive {
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveLinear, animations: {
                fromView.frame = finalFrame
            }, completion: { finished in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
        } else {
            UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, animations: {
                fromView.frame = finalFrame
            }, completion: { finished in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
        }
        
    }
    
}



// 1. Custom Interactive Transitioning for Pop
//class ChatLogInteractiveAnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerInteractiveTransitioning {
//    
//    private var transitionContext: UIViewControllerContextTransitioning?
//    var isInteractive = false
//    var interactionProgress: CGFloat = 0
//    
//    func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
//        self.transitionContext = transitionContext
//    }
//    
//    // Required for UIViewControllerAnimatedTransitioning
//    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
//        return 0.5
//    }
//    
//    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
//        // 이 메서드는 일반적으로 non-interactive 트랜지션에서만 호출됨
//    }
//    
//    // Interactive 트랜지션에 필요한 애니메이션을 정의
//    func updateInteractiveTransition(_ progress: CGFloat) {
//        guard let transitionContext = transitionContext,
//              let fromView = transitionContext.view(forKey: .from),
//              let toView = transitionContext.view(forKey: .to) else { return }
//        
//        interactionProgress = progress
//        let containerView = transitionContext.containerView
//        
//        // 두 뷰를 모두 containerView에 추가
//        containerView.insertSubview(toView, belowSubview: fromView)
//        
//        // fromView를 오른쪽으로 이동시키는 애니메이션 적용
//        fromView.frame.origin.x = fromView.frame.width * progress
//    }
//    
//    func cancelInteractiveTransition() {
//        print(#function)
//        guard let transitionContext = transitionContext,
//              let fromView = transitionContext.view(forKey: .from) else { return }
//        
//        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, animations: {
//            fromView.frame.origin.x = 0
//        }) { _ in
//            transitionContext.completeTransition(false)
//            self.transitionContext = nil
//        }
//    }
//    
//    func finishInteractiveTransition(isFinished: Bool) {
//        print(#function, "isFinished: \(isFinished)")
//        guard let transitionContext = transitionContext,
//              let fromView = transitionContext.view(forKey: .from) else { return }
//        
//        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, animations: {
//            fromView.frame.origin.x = isFinished ? fromView.frame.width : 0
//        }, completion: { _ in
//            transitionContext.completeTransition(isFinished)
//            self.transitionContext = nil
//        })
//    }
//    
//}
