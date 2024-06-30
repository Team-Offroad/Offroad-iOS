//
//  UIFont+.swift
//  Offroad-iOS
//
//  Created by 김민성 on 2024/06/30.
//

import UIKit

enum PretendardFontWeight {
    case thin
    case extraLight
    case light
    case regular
    case medium
    case semiBold
    case bold
    case extraBold
    case black
}

enum offroadFontStyle {
    case title
    case subtitle3
    case subtitle2_bold
    case subtitle_reg
    case tooltip_title
    case text
    case textField
    case btn_small
    case hint
    case tooltip_description
    case tooltip_sub
}

extension UIFont {
    
    /// Pretendard 폰트의 특정 weight를 이용해 Pretendard 폰트의 UIFont 인스턴스를 반환 (마치 systemFont처럼)
    /// - Parameters:
    ///   - fontSize: font의 사이즈
    ///   - weight: font의 weight
    /// - Returns: 특정 size와 weight의 UIFont 인스턴스
    static func pretendardFont(ofSize fontSize: CGFloat, weight: PretendardFontWeight) -> UIFont {
        let fontName: String
        switch weight {
        case .thin: fontName = "Pretendard-Thin"
        case .extraLight: fontName = "Pretendard-ExtraLight"
        case .light: fontName = "Pretendard-Light"
        case .regular: fontName = "Pretendard-Regular"
        case .medium: fontName = "Pretendard-Medium"
        case .semiBold: fontName = "Pretendard-SemiBold"
        case .bold: fontName = "Pretendard-Bold"
        case .extraBold: fontName = "Pretendard-ExtraBold"
        case .black: fontName = "Pretendard-Black"
        }
        
        guard let font = UIFont(name: fontName, size: fontSize) else { fatalError("Font not found") }
        return font
        
    }
    
    static func offroad(style: offroadFontStyle) -> UIFont {
        switch style {
        case .title: return UIFont.pretendardFont(ofSize: 24, weight: .bold)
        case .subtitle3: return UIFont.pretendardFont(ofSize: 24, weight: .medium)
        case .subtitle2_bold: return UIFont.pretendardFont(ofSize: 20, weight: .bold)
        case .subtitle_reg: return UIFont.pretendardFont(ofSize: 20, weight: .regular)
        case .tooltip_title:return UIFont.pretendardFont(ofSize: 16, weight: .semiBold)
        case .text: return UIFont.pretendardFont(ofSize: 16, weight: .regular) //lineHeight 135%
        case .textField: return UIFont.pretendardFont(ofSize: 16, weight: .regular)
        case .btn_small: return UIFont.pretendardFont(ofSize: 15, weight: .medium)
        case .hint: return UIFont.pretendardFont(ofSize: 14, weight: .medium)
        case .tooltip_description: return UIFont.pretendardFont(ofSize: 14, weight: .regular)
        case .tooltip_sub: return UIFont.pretendardFont(ofSize: 12, weight: .regular)
        }
    }
    
}
