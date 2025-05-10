//
//  ORBRecommendationChatViewPresentingTransition.swift
//  ORB_Dev
//
//  Created by 김민성 on 5/4/25.
//

import UIKit

final class ORBRecommendationChatViewPresentingTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let duration: TimeInterval = 0.5
    private lazy var transitionAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 0.8)
    private let buttonFrame: CGRect
    
    /// 버튼에서 채팅 말풍선으로 바뀌며 이동하는 요소
    private let floatingView: ORBRecommendationChatPresentationFloatingView
    
    init(buttonFrame: CGRect, buttonText: String) {
        self.buttonFrame = buttonFrame
        self.floatingView = ORBRecommendationChatPresentationFloatingView(text: buttonText)
    }
    
    func transitionDuration(using transitionContext: (any UIViewControllerContextTransitioning)?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: any UIViewControllerContextTransitioning) {
        guard let chatViewController = transitionContext.viewController(forKey: .to) as? ORBRecommendationChatViewController
        else { fatalError() }
        
        // floatingView 초기 위치 섦정
        transitionContext.containerView.addSubviews(floatingView)
        floatingView.frame = buttonFrame
        transitionContext.containerView.layoutIfNeeded()
        
        // alpha값들 초기 설정
        chatViewController.view.alpha = 0
        chatViewController.firstChatBubbleAlpha = 0
        chatViewController.collectionViewAlpha = 0
        
        // animate floatingView
        transitionAnimator.addAnimations { [weak self] in
            chatViewController.view.layoutIfNeeded()
            guard let destinationFrame = chatViewController.firstChatBubbleFrame else {
                transitionContext.completeTransition(false)
                assertionFailure("could not layout collection view before start transition.")
                return
            }
            self?.floatingView.frame = destinationFrame
        }
        
        transitionAnimator.addAnimations({
            chatViewController.view.alpha = 1
            chatViewController.collectionViewAlpha = 1
        }, delayFactor: 0.2)
        
        transitionAnimator.addCompletion { [weak self] position in
            // 애니메이션이 완료된 후 chatBubble 화면에 표시
            chatViewController.firstChatBubbleAlpha = 1
            self?.floatingView.removeFromSuperview()
            transitionContext.completeTransition(true)
        }
        
        transitionAnimator.startAnimation()
    }
    
}
