//
//  UILabel+.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 7/9/24.
//

import UIKit

extension UILabel {
    
    /// 특정 text의 속성(폰트, 색상)을 바꿔주는 함수
    /// - Parameter targetText: 변경할 String 값
    /// - Parameter font: 적용할 font
    /// - Parameter color: 적용할 color
    /// > 사용 예시 : label.highlightText(targetText: nicknameString, font: .offroad(style: .iosSubtitle2Bold))
    func highlightText(targetText: String, font: UIFont? = nil, color: UIColor? = nil) {
        guard let labelText = self.text else { return }
        
        let attributedString = NSMutableAttributedString(string: labelText)
        
        let range = (labelText as NSString).range(of: targetText)
        
        if let font {
            attributedString.addAttribute(.font, value: font, range: range)
        }
        
        if let color {
            attributedString.addAttribute(.foregroundColor, value: color, range: range)
        }
        
        self.attributedText = attributedString
    }
}
