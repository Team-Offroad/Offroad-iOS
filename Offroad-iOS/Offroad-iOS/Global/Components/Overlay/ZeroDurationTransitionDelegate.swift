//
//  ZeroDurationTransitionDelegate.swift
//  Offroad-iOS
//
//  Created by 김민성 on 9/16/24.
//

import UIKit

class ZeroDurationTransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ZeroDurationAnimator()
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }
}
