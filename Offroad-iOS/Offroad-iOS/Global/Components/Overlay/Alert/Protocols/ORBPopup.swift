//
//  ORBPopup.swift
//  Offroad-iOS
//
//  Created by 김민성 on 10/20/24.
//

import UIKit

protocol ORBPopup: ORBOverlayViewController {
    
    var presentationAnimator: UIViewPropertyAnimator { get }
    var dismissalAnimator: UIViewPropertyAnimator { get }
    
    var rootView: ORBAlertBackgroundView { get }
    
    func showAlertView()
    func hideAlertView(completion: (() -> Void)?)
    
}

extension ORBPopup {
    
    func showAlertView() {
        rootView.alertView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        rootView.layoutIfNeeded()
        
        presentationAnimator.addAnimations { [weak self] in
            self?.rootView.backgroundColor = .blackOpacity(.black25)
            self?.rootView.alertView.alpha = 1
            self?.rootView.alertView.transform = .identity
        }
        presentationAnimator.startAnimation()
    }
    
    func hideAlertView(completion: (() -> Void)? = nil) {
        dismissalAnimator.addAnimations { [weak self] in
            self?.rootView.backgroundColor = .clear
            self?.rootView.alertView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            self?.rootView.alertView.alpha = 0
        }
        dismissalAnimator.addCompletion { _ in completion?() }
        dismissalAnimator.startAnimation()
    }
    
}
