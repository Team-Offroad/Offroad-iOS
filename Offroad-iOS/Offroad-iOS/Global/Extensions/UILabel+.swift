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
    /// > 사용 예시 : `label.highlightText(targetText: nicknameString, font: .offroad(style: .iosSubtitle2Bold))`
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
    
    /// UILabel에서의 줄 간 간격을 설정하는 함수
    /// - Parameter spacing: 행간의 픽셀 값
    /// > 사용 예시 : `label.setLineSpacing(spacing: 15.0)`
    func setLineSpacing(spacing: CGFloat) {
        guard let text = text else { return }
        
        let attributeString = NSMutableAttributedString(string: text)
        let style = NSMutableParagraphStyle()
        style.lineSpacing = spacing
        style.alignment = textAlignment
        style.lineBreakMode = lineBreakMode
        style.lineBreakStrategy = lineBreakStrategy
        attributeString.addAttribute(.paragraphStyle,
                                     value: style,
                                     range: NSRange(location: 0, length: attributeString.length))
        attributedText = attributeString
    }
    
    /// 피그마에서 폰트를 표현할 때 Line Height가 설정된 경우 행간을 구현
    /// - Parameter percentage: 피그마상에서 폰트의 Line Height 값. 백분율로 표시된다.
    ///
    /// 피그마상에서 라벨의 높이를 지정한 경우, UILabel에서도 높이를 명시적으로 설정해야 함.
    func setLineHeight(percentage: CGFloat) {
        guard let text = text else { return }
        
        let attributeString = NSMutableAttributedString(string: text)
        let style = NSMutableParagraphStyle()
        let lineSpacing = font.ascender * ((percentage-100)/100) + font.descender
        style.lineSpacing = lineSpacing
        style.alignment = textAlignment
        style.lineBreakMode = lineBreakMode
        style.lineBreakStrategy = lineBreakStrategy
        attributeString.addAttribute(.paragraphStyle,
                                     value: style,
                                     range: NSRange(location: 0, length: attributeString.length))
        attributedText = attributeString
    }
    
}
