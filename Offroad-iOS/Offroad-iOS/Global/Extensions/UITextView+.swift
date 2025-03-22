//
//  UITextView+.swift
//  Offroad-iOS
//
//  Created by 김민성 on 11/10/24.
//

import UIKit

extension UITextView {
    
    /// UITextView에서의 줄 간 간격을 설정하는 함수
    /// - Parameter spacing: 행간의 픽셀 값
    /// > 사용 예시 : `textView.setLineSpacing(spacing: 15.0)`
    func setLineSpacing(spacing: CGFloat) {
        let currentText = self.attributedText ?? NSAttributedString(string: self.text ?? "")
        let attributedString = NSMutableAttributedString(attributedString: currentText)
        let style = NSMutableParagraphStyle()
        
        style.lineSpacing = spacing
        style.alignment = textAlignment
        
        let attributes: [NSAttributedString.Key: Any]
        = [.paragraphStyle: style,
           .font: self.font!,
           .foregroundColor: self.textColor ?? .primary(.black)]
        typingAttributes = attributes
        attributedString.addAttribute(.paragraphStyle,
                                     value: style,
                                     range: NSRange(location: 0, length: attributedString.length))
        // 바로 위 attributes 딕셔너리에서 .font 키에 값을 할당하지 않으면 강제언래핑 충돌
        attributedString.addAttribute(.font, value: self.font!, range: NSRange(location: 0, length: attributedString.length))
        self.attributedText = attributedString
    }
    
    /// 피그마에서 폰트를 표현할 때 Line Height가 설정된 경우 행간을 구현
    /// - Parameter percentage: 피그마상에서 폰트의 Line Height 값. 백분율로 표시된다.
    ///
    /// 피그마상에서 텍스트뷰의 높이를 지정한 경우, UITextView에서도 높이를 명시적으로 설정해야 함.
    func setLineHeight(percentage: CGFloat) {
        let currentOffset = contentOffset
        let currentText = self.attributedText ?? NSAttributedString(string: self.text ?? "")
        let attributedString = NSMutableAttributedString(attributedString: currentText)
        let style = NSMutableParagraphStyle()
        let textViewFont = font ?? .systemFont(ofSize: UIFont.systemFontSize)
        let lineSpacing = textViewFont.ascender * ((percentage-100)/100) + textViewFont.descender
        
        style.lineSpacing = lineSpacing
        style.alignment = textAlignment
        
        let attributes: [NSAttributedString.Key: Any]
        = [.paragraphStyle: style,
           .font: self.font!,
           .foregroundColor: self.textColor ?? .primary(.black)]
        typingAttributes = attributes
        
        attributedString.addAttribute(
            .paragraphStyle,
            value: style,
            range: NSRange(location: 0, length: attributedString.length))
        attributedString.addAttribute(
            .font,
            value: self.font!,
            range: NSRange(location: 0, length: attributedString.length)
        )
        attributedString.addAttribute(
            .foregroundColor,
            value: self.textColor ?? .primary(.black),
            range: NSRange(location: 0, length: attributedString.length)
        )
        self.attributedText = attributedString
        self.contentOffset = currentOffset
    }
    
}
