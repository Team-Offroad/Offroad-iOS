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
    /// > 사용 예시 : `label.setLineSpacing(spacing: 15.0)`
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
        // 왜인진 모르겠는데, 상단 attributes 상수에서 딕셔너리의 .font 키에 값을 할당하면 아래 강제언래핑이 되어도 충돌이 없음.
        // (.font 키에 값 할당 안하면 강제언래핑 충돌) -> 나중에 공부하기
        attributedString.addAttribute(.font, value: self.font!, range: NSRange(location: 0, length: attributedString.length))
        self.attributedText = attributedString
//        self.layoutManager.ensureLayout(for: self.textContainer)
    }
    
    /// 피그마에서 폰트를 표현할 때 Line Height가 설정된 경우 행간을 구현
    /// - Parameter percentage: 피그마상에서 폰트의 Line Height 값. 백분율로 표시된다.
    ///
    /// 피그마상에서 라벨의 높이를 지정한 경우, UILabel에서도 높이를 명시적으로 설정해야 함.
    func setLineHeight(percentage: CGFloat) {
        print(#function)
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