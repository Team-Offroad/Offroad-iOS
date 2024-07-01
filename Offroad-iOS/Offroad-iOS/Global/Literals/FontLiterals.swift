//
//  FontLiterals.swift
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
    case subtitle2Bold
    case subtitle2Semibold
    case subtitleReg
    case tooltipTitle
    case text
    case textAuto
    /*
     textBold 케이스의 경우, 폰트 스타일 가이드에, 'text'로 나와있는데, 'text' 이름의 스타일이 이미 존재하기 때문에,
     임시로 textBold로 처리하였음. 추후 폰트 이름이 바뀌거나, 디자인 파트와 논의하여 수정될 가능성 있음.
     */
    case textBold
    case textField
    case btnLogin
    case btnSmall
    case hint
    case tooltipDescription
    case tooltipSub
    case tooltipNumber
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
        case .subtitle2Bold: return UIFont.pretendardFont(ofSize: 20, weight: .bold)
        case .subtitle2Semibold: return UIFont.pretendardFont(ofSize: 18, weight: .semiBold)
        case .subtitleReg: return UIFont.pretendardFont(ofSize: 20, weight: .regular)
        case .tooltipTitle:return UIFont.pretendardFont(ofSize: 18, weight: .bold)
        case .text: return UIFont.pretendardFont(ofSize: 16, weight: .regular) //lineHeight 135%
        case .textAuto: return UIFont.pretendardFont(ofSize: 16, weight: .regular)
        case .textBold: return UIFont.pretendardFont(ofSize: 16, weight: .bold)
        case .textField: return UIFont.pretendardFont(ofSize: 16, weight: .regular)
        case .btnLogin: return UIFont.pretendardFont(ofSize: 15, weight: .semiBold)
        case .btnSmall: return UIFont.pretendardFont(ofSize: 15, weight: .medium)
        case .hint: return UIFont.pretendardFont(ofSize: 14, weight: .medium)
        case .tooltipDescription: return UIFont.pretendardFont(ofSize: 12, weight: .regular)
        case .tooltipSub: return UIFont.pretendardFont(ofSize: 12, weight: .regular)
        case .tooltipNumber: return UIFont.pretendardFont(ofSize: 12, weight: .bold)
        }
    }
    
}
