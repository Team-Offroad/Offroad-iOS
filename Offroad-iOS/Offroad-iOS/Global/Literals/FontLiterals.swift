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
    case iosSubtitle3
    case iosTextTitle
    case iosSubtitle2Bold
    case iosSubtitleReg
    case iosSubtitle2Semibold
    case iosTooltipTitle
    case iosTextBold
    case iosTextRegular
    case iosTextAuto
    case iosBtnLogin
    case iosBtnSmall
    case iosTextContents
    case iosHint
    case iosTooltipNumber
    case iosTextContentsSmall
    case iosProfileTitle
    case iosTabbarMedi
    case iosBoxMedi
    case iosMarketing
    case bothLogin
    case bothBottomLabel
    case bothRecentNum
    case bothUpcomingSmallNum
    case bothUpcomingBigNum
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
    
    static func opticianSansFont(ofSize fontSize: CGFloat) -> UIFont {
        guard let font = UIFont(name: "OpticianSans-Regular", size: fontSize) else { fatalError("Font not found") }
        return font
    }
    
    static func offroad(style: offroadFontStyle) -> UIFont {
        switch style {
        case .iosSubtitle3: return UIFont.pretendardFont(ofSize: 24, weight: .medium)
        case .iosTextTitle: return UIFont.pretendardFont(ofSize: 22, weight: .bold)
        case .iosSubtitle2Bold: return UIFont.pretendardFont(ofSize: 20, weight: .bold)
        case .iosSubtitleReg: return UIFont.pretendardFont(ofSize: 20, weight: .regular)
        case .iosSubtitle2Semibold: return UIFont.pretendardFont(ofSize: 18, weight: .semiBold)
        case .iosTooltipTitle:return UIFont.pretendardFont(ofSize: 18, weight: .bold)
        case .iosTextBold: return UIFont.pretendardFont(ofSize: 16, weight: .bold) //lineHeight 150%
        case .iosTextRegular: return UIFont.pretendardFont(ofSize: 16, weight: .regular) //lineHeight 150%
        case .iosTextAuto: return UIFont.pretendardFont(ofSize: 16, weight: .regular)
        case .iosBtnLogin: return UIFont.pretendardFont(ofSize: 15, weight: .semiBold)
        case .iosBtnSmall: return UIFont.pretendardFont(ofSize: 15, weight: .medium)
        case .iosTextContents: return UIFont.pretendardFont(ofSize: 14, weight: .semiBold)
        case .iosHint: return UIFont.pretendardFont(ofSize: 14, weight: .medium)
        case .iosTooltipNumber: return UIFont.pretendardFont(ofSize: 12, weight: .bold)
        case .iosTextContentsSmall: return UIFont.pretendardFont(ofSize: 12, weight: .medium)
        case .iosProfileTitle: return UIFont.pretendardFont(ofSize: 26, weight: .bold )
        case .iosTabbarMedi: return UIFont.pretendardFont(ofSize: 18, weight: .medium)
        case .iosBoxMedi: return UIFont.pretendardFont(ofSize: 14, weight: .medium)
        case .iosMarketing: return UIFont.pretendardFont(ofSize: 13, weight: .regular)
        case .bothLogin: return UIFont.pretendardFont(ofSize: 15, weight: .semiBold )
        case .bothBottomLabel: return UIFont.opticianSansFont(ofSize: 14)
        case .bothRecentNum: return UIFont.opticianSansFont(ofSize: 24)
        case .bothUpcomingSmallNum: return UIFont.opticianSansFont(ofSize: 30)
        case .bothUpcomingBigNum: return UIFont.opticianSansFont(ofSize: 62)
        }
    }
    
}
