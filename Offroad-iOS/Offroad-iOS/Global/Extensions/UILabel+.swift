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
        guard let attributedText else { return }
        
        let attributedString = NSMutableAttributedString(attributedString: attributedText)
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
        guard let attributedText else { return }
        
        let attributedString = NSMutableAttributedString(attributedString: attributedText)
        let style = NSMutableParagraphStyle()
        
        style.lineSpacing = spacing
        style.alignment = textAlignment
        style.lineBreakMode = lineBreakMode
        style.lineBreakStrategy = lineBreakStrategy
        attributedString.addAttribute(.paragraphStyle,
                                     value: style,
                                     range: NSRange(location: 0, length: attributedString.length))
        self.attributedText = attributedString
    }
    
    /// 피그마에서 폰트를 표현할 때 Line Height가 설정된 경우 행간을 구현
    /// - Parameter percentage: 피그마상에서 폰트의 Line Height 값. 백분율로 표시된다.
    ///
    /// 피그마상에서 라벨의 높이를 지정한 경우, UILabel에서도 높이를 명시적으로 설정해야 함.
    func setLineHeight(percentage: CGFloat) {
        guard let attributedText else { return }
        
        let attributedString = NSMutableAttributedString(attributedString: attributedText)
        let style = NSMutableParagraphStyle()
        let lineSpacing = font.ascender * ((percentage-100)/100) + font.descender
        
        style.lineSpacing = lineSpacing
        style.alignment = textAlignment
        style.lineBreakMode = lineBreakMode
        style.lineBreakStrategy = lineBreakStrategy
        attributedString.addAttribute(.paragraphStyle,
                                     value: style,
                                     range: NSRange(location: 0, length: attributedString.length))
        self.attributedText = attributedString
    }
    
    /// UILabel에서 실행 기기에 대응하여 자동으로 폰트 크기를 조절하도록 하는 함수
    /// 라벨의 폰트를 적용한 이후에 호출해야함
    /// > 사용 예시 : `label.resizeFontForDevice()`
    func resizeFontForDevice() {
        let screenHeight = UIScreen.main.bounds.height
        let currentFontSize = font?.pointSize
        var calculatedSize: CGFloat?
        
        switch screenHeight {
        case 568.0, 667.0, 736.0: // iPhone SE, iPhone 6, 6s, 7, 8, 6+, 6s+, 7+, 8+
            calculatedSize = 0.86
        case 812.0: // iPhone X, XS, 11 Pro
            calculatedSize = 0.95
        case 844.0: // iPhone 12, 12 Pro, 13, 13 Pro, 14
            calculatedSize = 0.99
        case 852.0: // iPhone 15, 15 Pro, 16
            calculatedSize = 1
        case 874.0: // iPhone 16 Pro
            calculatedSize = 1.03
        case 896.0: // iPhone XR, 11, XS Max
            calculatedSize = 1.05
        case 926.0: // iPhone 12 Pro Max, 13 Pro Max, 14 Plus
            calculatedSize = 1.09
        case 932.0: // iPhone 15 Pro Max, 16 Plus
            calculatedSize = 1.09
        case 956.0: // iPhone 16 Pro Max
            calculatedSize = 1.12
        default:
            print("디바이스 기종을 찾을 수 없습니다.")
            calculatedSize = 1
        }
        
        if let currentFontSize, let calculatedSize {
            font = font?.withSize(currentFontSize * calculatedSize)
        }
    }
}
