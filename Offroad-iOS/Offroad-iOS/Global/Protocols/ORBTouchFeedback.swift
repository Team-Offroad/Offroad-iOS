//
//  ORBTouchFeedback.swift
//  Offroad-iOS
//
//  Created by 김민성 on 1/5/25.
//

import UIKit

protocol ORBTouchFeedback {
    
    var animator: UIViewPropertyAnimator { get }
    
    func shrink(scale: CGFloat)
    func restore()
    
}

extension ORBTouchFeedback where Self: UIView {
    
    func shrink(scale: CGFloat) {
        animator.stopAnimation(true)
        animator.addAnimations { [weak self] in
            guard let self else { return }
            let transform = CGAffineTransform(scaleX: scale, y: scale)
            self.transform = transform
        }
        animator.startAnimation()
    }
    
    func restore() {
        animator.stopAnimation(true)
        animator.addAnimations { [weak self] in
            guard let self else { return }
            self.transform = CGAffineTransform.identity
        }
        animator.startAnimation()
    }
    
}
