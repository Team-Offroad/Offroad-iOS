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
    /// - 해당 함수를 불러오기 전에 popupView(or 적용할 View).alpha = 0 으로 설정할 경우 비교적 부드러운 팝업이 가능함.
    /// > 사용 예시 : `popupView.excutePresentPopupAnimation()`
    func executePresentPopupAnimation(
        initialAlpha: CGFloat = 0,
        initialScale: CGFloat = 0.5,
        duration: CGFloat = 0.4,
        delay: CGFloat = 0,
        dampingRatio: CGFloat = 1,
        anchorPoint: CGPoint = CGPoint(x: 0.5, y: 0.5),
        completion: ((Bool) -> Void)? = nil
    ) {
        self.alpha = initialAlpha
        transform = CGAffineTransform(scaleX: initialScale, y: initialScale)
        self.layer.anchorPoint = anchorPoint
        UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: dampingRatio, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.transform = CGAffineTransform.identity
            self.alpha = 1
        }, completion: completion)
    }
    
    /// view의 pop up 효과가 사라지는 animation 설정
    /// > 사용 예시 : `popupView.excuteDismissPopupAnimation()`
    func executeDismissPopupAnimation(
        destinationAlpha: CGFloat = 0,
        destinationScale: CGFloat = 0.1,
        duration: CGFloat = 0.4,
        delay: CGFloat = 0,
        dampingRatio: CGFloat = 1,
        anchorPoint: CGPoint = CGPoint(x: 0.5, y: 0.5),
        completion: ((Bool) -> Void)? = nil
    ) {
        self.alpha = 1
        self.layer.anchorPoint = anchorPoint
        UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: dampingRatio, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.transform = CGAffineTransform(scaleX: destinationScale, y: destinationScale)
            self.alpha = destinationAlpha
        }, completion: completion)
    }
    
    
    func startLoading(withoutShading: Bool = false) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
        // 이미 로딩중인 경우, 추가 로딩 뷰 띄우는 것 방지
            for subView in subviews {
                if subView is LoadingView { return }
            }
            let loadingView = LoadingView()
            loadingView.shadeView.isHidden = withoutShading
            loadingView.isHidden = true
            self.addSubview(loadingView)
            loadingView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            UIView.animate(withDuration: 0.2) {
                loadingView.isHidden = false
            }
        }
    }
    
    func stopLoading() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            for subview in self.subviews {
                guard let loadingView = subview as? LoadingView else { continue }
                UIView.animate(withDuration: 0.2, animations: {
                    loadingView.isHidden = true
                }) { isFinished in
                    loadingView.removeFromSuperview()
                }
            }
        }
    }
}
