//
//  UIScrollView+.swift
//  Offroad-iOS
//
//  Created by 김민성 on 11/25/24.
//

import UIKit

import Lottie
import SnapKit

extension UIScrollView {
    
    enum ScrollLoadingPosition {
        case top
        case bottom
    }
    
    func startScrollLoading(lottie: LottieAnimationView, position: ScrollLoadingPosition = .bottom) {
        addSubview(lottie)
        lottie.isHidden = false
        lottie.play()
        switch position {
        case .top:
            return
        case .bottom:
            addSubview(lottie)
            lottie.frame = .init(
                origin: .init(x: (contentSize.width/2 - 19), y: contentSize.height + 18),
                size: .init(width: 38, height: 38)
            )
        }
    }
    
    func stopScrollLoading(lottie: LottieAnimationView) {
        lottie.removeFromSuperview()
        lottie.stop()
        lottie.isHidden = true
    }
    
}
