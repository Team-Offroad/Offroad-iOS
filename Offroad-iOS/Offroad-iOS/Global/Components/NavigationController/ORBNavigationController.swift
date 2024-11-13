//
//  ORBNavigationController.swift
//  Offroad-iOS
//
//  Created by 김민성 on 11/13/24.
//

import UIKit

class ORBNavigationController: UINavigationController {
    
    var customPopTransition: UIPercentDrivenInteractiveTransition?
//    var customPopTransition: ChatLogInteractiveAnimatedTransitioning?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupGestures()
        setupDelegates()
    }
    
}


extension ORBNavigationController {
    
    //MARK: - @objc Func
    
    @objc func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        let progress = min(max(translation.x / view.bounds.width, 0), 1)
        print("progress: \(progress)")
        
        switch gesture.state {
        case .began:
            guard topViewController is CharacterChatLogViewController else { return }
//            customPopTransition = ChatLogInteractiveAnimatedTransitioning()
            customPopTransition = UIPercentDrivenInteractiveTransition()
            popViewController(animated: true)
        case .changed:
            customPopTransition?.update(progress)
//            customPopTransition?.updateInteractiveTransition(progress)
        case .ended, .cancelled:
            let shouldFinish = progress > 0.5 || gesture.velocity(in: view).x > 0
            if shouldFinish {
                customPopTransition?.finish()
            } else {
                customPopTransition?.cancel()
            }
            customPopTransition = nil
//            customPopTransition?.finishInteractiveTransition(isFinished: shouldCancel)
//            if progress > 0.5 || gesture.velocity(in: view).x > 0 {
////                customPopTransition?.finish()
//                customPopTransition?.finishInteractiveTransition(isFinished: true)
//            } else {
////                customPopTransition?.cancel()
//                customPopTransition?.cancelInteractiveTransition()
//            }
////            customPopTransition = nil
        default:
            break
        }
    }
    
    //MARK: - Private Func
    
    private func setupGestures() {
        let edgePanGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        edgePanGesture.edges = .left
        view.addGestureRecognizer(edgePanGesture)
    }
    
    private func setupDelegates() {
        delegate = self
    }
    
}

extension ORBNavigationController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        guard let tabBarController = tabBarController as? OffroadTabBarController else { return }
        guard !tabBarController.isTabBarShown else { return }
        tabBarController.disableTabBarInteraction()
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let tabBarController = tabBarController as? OffroadTabBarController else { return }
        tabBarController.enableTabBarInteraction()
    }
    
    func navigationController(_ navigationController: UINavigationController,
                              animationControllerFor operation: UINavigationController.Operation,
                              from fromVC: UIViewController,
                              to toVC: UIViewController
    ) -> (any UIViewControllerAnimatedTransitioning)? {
        if operation == .push && toVC is CharacterChatLogViewController {
            return ChatLogPushAnimator()
        } else if operation == .pop && fromVC is CharacterChatLogViewController {
            return ChatLogPopAnimator()
        }
        return nil
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: any UIViewControllerAnimatedTransitioning) -> (any UIViewControllerInteractiveTransitioning)? {
        return customPopTransition
    }
    
}
