//
//  ORBNavigationController.swift
//  Offroad-iOS
//
//  Created by 김민성 on 11/13/24.
//

import UIKit

class ORBNavigationController: UINavigationController {
    
    var customPopTransition: UIPercentDrivenInteractiveTransition?
    lazy var screenEdgePanGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
    
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
            customPopTransition = UIPercentDrivenInteractiveTransition()
            popViewController(animated: true)
        case .changed:
            customPopTransition?.update(progress)
        case .ended, .cancelled:
            let shouldFinish = progress > 0.5 || gesture.velocity(in: view).x > 0
            if shouldFinish {
                customPopTransition?.finish()
            } else {
                customPopTransition?.cancel()
            }
            customPopTransition = nil
        default:
            break
        }
    }
    
    //MARK: - Private Func
    
    private func setupGestures() {
        screenEdgePanGesture.edges = .left
        view.addGestureRecognizer(screenEdgePanGesture)
    }
    
    private func setupDelegates() {
        delegate = self
        interactivePopGestureRecognizer?.delegate = self
    }
    
}

//MARK: - UINavigationControllerDelegate

extension ORBNavigationController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        guard let tabBarController = tabBarController as? OffroadTabBarController else { return }
        guard !tabBarController.isTabBarShown else { return }
        tabBarController.disableTabBarInteraction()
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        
        if topViewController is CharacterChatLogViewController {
            screenEdgePanGesture.isEnabled = true
            interactivePopGestureRecognizer?.isEnabled = false
        } else {
            screenEdgePanGesture.isEnabled = false
            interactivePopGestureRecognizer?.isEnabled = true
        }
        
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

//MARK: - UIGestureRecognizerDelegate

extension ORBNavigationController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
}
