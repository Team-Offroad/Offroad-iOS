//
//  UIButton+.swift
//  Offroad-iOS
//
//  Created by  정지원 on 7/10/24.
//

import UIKit

extension UIButton {
    
    //UIButton에 background를 상태에 따라 설정하는 함수
    //ex) button.setBackgroundColor(.black, for: .selected)
    /// - Parameter left: 버튼 배경 색상
    /// - Parameter right: 버튼의 상태
    func setBackgroundColor(_ color: UIColor, for state: UIControl.State) {
        UIGraphicsBeginImageContext(CGSize(width: 1.0, height: 1.0))
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.setFillColor(color.cgColor)
        context.fill(CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0))

        let backgroundImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        setBackgroundImage(backgroundImage, for: state)
    }
}

