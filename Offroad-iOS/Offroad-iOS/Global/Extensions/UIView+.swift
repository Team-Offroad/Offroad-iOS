//
//  UIView+.swift
//  Offroad-iOS
//
//  Created by 김민성 on 2024/06/25.
//

import UIKit

extension UIView {
    
    /// subview들을 한꺼번에 추가
    /// - Parameter views: 추가할 subview들
    func addSubviews(_ views: UIView...) {
        views.forEach { self.addSubview($0) }
    }
    
    /// view의 코너를 둥글게 설정
    /// - Parameters:
    ///   - cornerRadius: 코너의 곡률 반경
    ///   - maskedCorners: 둥글게 만들 코너 선택
    func roundCorners(cornerRadius: CGFloat, maskedCorners: CACornerMask? = nil) {
        clipsToBounds = true
        layer.cornerRadius = cornerRadius
        
        if let maskedCorners {
            layer.maskedCorners = CACornerMask(arrayLiteral: maskedCorners)
        }
    }
    
    func excutePresentPopupAnimation() {
        transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.transform = CGAffineTransform.identity
            self.alpha = 1
        }, completion: nil)
    }
    
    func excuteDismissPopupAnimation() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            self.alpha = 0
        }, completion: nil)
    }
}
