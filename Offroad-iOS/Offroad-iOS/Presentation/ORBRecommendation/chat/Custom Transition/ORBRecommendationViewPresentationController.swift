//
//  ORBRecommendationViewPresentationController.swift
//  ORB_Dev
//
//  Created by 김민성 on 5/4/25.
//

import UIKit

final class ORBRecommendationViewPresentationController: UIPresentationController {
    
    // MARK: - UI Properties
    
    private let blurView = UIVisualEffectView(effect: nil)
    
    // MARK: - Properties
    
    private weak var sourceViewController: ORBRecommendationMainViewController?
    
    // MARK: - Life Cycle
    
    init(
        presentedViewController: ORBRecommendationChatViewController,
        presenting presentingViewController: UIViewController?,
        sourceViewController: ORBRecommendationMainViewController
    ) {
        self.sourceViewController = sourceViewController
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }
    
    override func presentationTransitionWillBegin() {
        guard let containerView else {
            assertionFailure("containerView is nil")
            return
        }
        
        guard let presentedView else {
            assertionFailure("presentedView is nil")
            return
        }
        
        sourceViewController?.hideORBMessageButtonBeforePresent()
        containerView.addSubviews(blurView, presentedView)
        blurView.frame = containerView.bounds
        presentedView.frame = containerView.bounds
        
        // 블러 효과를 보다 자연스럽게(천천히) 주기 위해 블러 애니메이션을 transition시간보다 약간 더 길게 설정.
        // (블러 정도를 직접 조절하는 것은 쉽지 않음.)
        UIView.animate(withDuration: 0.7) { [weak self] in
            self?.blurView.effect = UIBlurEffect(style: .light)
        }
    }
    
    override func dismissalTransitionWillBegin() {
        sourceViewController?.showORBMessageButtonBeformDismiss()
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { [weak self] _ in
            self?.blurView.effect = nil
        }, completion: nil)
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        blurView.removeFromSuperview()
    }
    
}
