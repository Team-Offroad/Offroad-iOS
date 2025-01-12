//
//  ORBTouchFeedback.swift
//  Offroad-iOS
//
//  Created by 김민성 on 1/5/25.
//

import UIKit

protocol ORBTouchFeedback {
    
    var shrinkingAnimator: UIViewPropertyAnimator { get }
    
    func shrink(scale: CGFloat)
    func restore()
    
}

extension ORBTouchFeedback where Self: UIView {
    
    func shrink(scale: CGFloat) {
        shrinkingAnimator.stopAnimation(true)
        shrinkingAnimator.addAnimations { [weak self] in
            guard let self else { return }
            let transform = CGAffineTransform(scaleX: scale, y: scale)
            self.transform = transform
        }
        shrinkingAnimator.startAnimation()
    }
    
    func restore() {
        shrinkingAnimator.stopAnimation(true)
        shrinkingAnimator.addAnimations { [weak self] in
            guard let self else { return }
            self.transform = CGAffineTransform.identity
        }
        shrinkingAnimator.startAnimation()
    }
    
}
