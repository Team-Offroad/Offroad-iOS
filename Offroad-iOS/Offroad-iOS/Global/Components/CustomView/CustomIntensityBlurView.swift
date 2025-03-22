//
//  CustomIntensityBlurView.swift
//  Offroad-iOS
//
//  Created by 김민성 on 12/31/24.
//

import UIKit

class CustomIntensityBlurView: UIVisualEffectView {
    
    //MARK: - Properties
    
    private var animator = UIViewPropertyAnimator(duration: 1, curve: .linear)
    
    //MARK: - Life Cycle
    
    /// 원하는 세기의 블러를 적용한 UIVisualEffectView 생성
    /// - Parameters:
    ///   - style: blur의 style. UIBlurEffect.Style 타입
    ///   - intensity: 적용할 블러의 세기 0에서 1 사이의 값을 가지며 0은 블러 전혀 없음, 1은 UIKit의 기본 블러 세기를 의미
    init(blurStyle style: UIBlurEffect.Style, intensity: CGFloat) {
        super.init(effect: nil)
        
        animator.addAnimations { [weak self] in
            guard let self else { return }
            self.effect = UIBlurEffect(style: style)
        }
        animator.fractionComplete = intensity
        animator.pausesOnCompletion = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}

extension CustomIntensityBlurView {
    
    //MARK: - Func
    
    func applyBlurEffectAsync() {
        DispatchQueue.main.async {
            self.animator.startAnimation()
        }
    }
}
