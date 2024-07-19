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
    
    /// view의 pop up 효과가 나타나는 animation 설정
    /// - 해당 함수를 불러오기 전에 popupView(or 적용할 View).alpha = 0 으로 설정해줘야 동작함
    /// > 사용 예시 : `popupView.excutePresentPopupAnimation()`
    func excutePresentPopupAnimation(anchorPoint: CGPoint = CGPoint(x: 0.5, y: 0.5)) {
        transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        self.layer.anchorPoint = anchorPoint
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.transform = CGAffineTransform.identity
            self.alpha = 1
        }, completion: nil)
    }
    
    /// view의 pop up 효과가 사라지는 animation 설정
    /// > 사용 예시 : `popupView.excuteDismissPopupAnimation()`
    func excuteDismissPopupAnimation(anchorPoint: CGPoint = CGPoint(x: 0.5, y: 0.5)) {
        self.layer.anchorPoint = anchorPoint
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            self.alpha = 0
        }, completion: nil)
    }
}
