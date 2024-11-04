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
    // both
    case bothSubtitle3
    /// 자간 4%
    case bothBottomLabel
    case bothLogin
    
    // both/homeView
    /// 자간 14%
    case bothRecentNumRegular
    /// 자간 14%
    case bothRecentNumBold
    case bothUpcomingNumRegular
    case bothUpcomingNumBold
    
    // ios
    /// 행간 160%
    case iosBoxMedi
    case iosQuestComplete // 새로 추가
    case iosHint
    case iosTabbarMedi
    
    /// 행간 150%
    case iosMarketing
    
    // ios/title
    case iosProfileTitle
    case iosTextTitle
    
    // ios/subtitle
    case iosSubtitle2Semibold
    case iosSubtitleReg
    case iosSubtitle2Bold
    
    // 삭제
//    case iosSubtitle3
    
    // ios/text
    case iosTextContentsSmall
    case iosTextContents
    case iosTextAuto
    /// 행간 150%
    case iosText // iosTextRegular에서 바뀐 듯?
    /// 행간 150%
    case iosTextBold
    
    // ios/btn
    case iosBtnSmall
    
    // ios/tooltip
    case iosTooltipNumber
    case iosTooltipTitle
    
    
    
    
    // iosText로 바뀐 듯?
//    case iosTextRegular
    
    // 삭제
//    case iosBtnLogin
    
    
    
    
    
//    case bothRecentNum
//    case bothUpcomingSmallNum
//    case bothUpcomingBigNum
//    
//    case bothProfileTitle
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
        case .bothSubtitle3: return UIFont.pretendardFont(ofSize: 24, weight: .medium)
        case .bothBottomLabel: return UIFont.opticianSansFont(ofSize: 14)
        case .bothLogin: return UIFont.pretendardFont(ofSize: 15, weight: .semiBold)
        case .bothRecentNumRegular: return UIFont.pretendardFont(ofSize: 20, weight: .regular)
        case .bothRecentNumBold: return UIFont.pretendardFont(ofSize: 20, weight: .bold)
        case .bothUpcomingNumRegular: return UIFont.pretendardFont(ofSize: 28, weight: .regular)
        case .bothUpcomingNumBold: return UIFont.pretendardFont(ofSize: 28, weight: .bold)
        case .iosBoxMedi: return UIFont.pretendardFont(ofSize: 14, weight: .medium)
        case .iosQuestComplete: return UIFont.pretendardFont(ofSize: 14, weight: .bold)
        case .iosHint: return UIFont.pretendardFont(ofSize: 14, weight: .medium)
        case .iosTabbarMedi: return UIFont.pretendardFont(ofSize: 18, weight: .medium)
        case .iosMarketing: return UIFont.pretendardFont(ofSize: 13, weight: .regular)
        case .iosProfileTitle: return UIFont.pretendardFont(ofSize: 26, weight: .bold)
        case .iosTextTitle: return UIFont.pretendardFont(ofSize: 22, weight: .bold)
        case .iosSubtitle2Semibold: return UIFont.pretendardFont(ofSize: 18, weight: .semiBold)
        case .iosSubtitleReg: return UIFont.pretendardFont(ofSize: 20, weight: .regular)
        case .iosSubtitle2Bold: return UIFont.pretendardFont(ofSize: 20, weight: .bold)
        case .iosTextContentsSmall: return .pretendardFont(ofSize: 12, weight: .medium)
        case .iosTextContents: return .pretendardFont(ofSize: 14, weight: .semiBold)
        case .iosTextAuto: return .pretendardFont(ofSize: 16, weight: .regular)
        case .iosText: return .pretendardFont(ofSize: 16, weight: .regular)
        case .iosTextBold: return .pretendardFont(ofSize: 16, weight: .bold)
        case .iosBtnSmall: return .pretendardFont(ofSize: 15, weight: .medium)
        case .iosTooltipNumber: return .pretendardFont(ofSize: 12, weight: .bold)
        case .iosTooltipTitle: return .pretendardFont(ofSize: 18, weight: .bold)
            
//        case .iosSubtitle3: return UIFont.pretendardFont(ofSize: 24, weight: .medium)
//        case .iosTextTitle: return UIFont.pretendardFont(ofSize: 22, weight: .bold)
//        case .iosSubtitle2Bold: return UIFont.pretendardFont(ofSize: 20, weight: .bold)
//        case .iosSubtitleReg: return UIFont.pretendardFont(ofSize: 20, weight: .regular)
//        case .iosSubtitle2Semibold: return UIFont.pretendardFont(ofSize: 18, weight: .semiBold)
//        case .iosTooltipTitle:return UIFont.pretendardFont(ofSize: 18, weight: .bold)
//        case .iosTextBold: return UIFont.pretendardFont(ofSize: 16, weight: .bold) //lineHeight 150%
//        case .iosTextRegular: return UIFont.pretendardFont(ofSize: 16, weight: .regular) //lineHeight 150%
//        case .iosTextAuto: return UIFont.pretendardFont(ofSize: 16, weight: .regular)
//        case .iosBtnLogin: return UIFont.pretendardFont(ofSize: 15, weight: .semiBold)
//        case .iosBtnSmall: return UIFont.pretendardFont(ofSize: 15, weight: .medium)
//        case .iosTextContents: return UIFont.pretendardFont(ofSize: 14, weight: .semiBold)
//        case .iosHint: return UIFont.pretendardFont(ofSize: 14, weight: .medium)
//        case .iosTooltipNumber: return UIFont.pretendardFont(ofSize: 12, weight: .bold)
//        case .iosTextContentsSmall: return UIFont.pretendardFont(ofSize: 12, weight: .medium)
//        case .iosProfileTitle: return UIFont.pretendardFont(ofSize: 26, weight: .bold )
//        case .iosTabbarMedi: return UIFont.pretendardFont(ofSize: 18, weight: .medium)
//        case .iosBoxMedi: return UIFont.pretendardFont(ofSize: 14, weight: .medium)
//        case .iosMarketing: return UIFont.pretendardFont(ofSize: 13, weight: .regular)
//        case .bothLogin: return UIFont.pretendardFont(ofSize: 15, weight: .semiBold )
//        case .bothBottomLabel: return UIFont.opticianSansFont(ofSize: 14)
//        case .bothRecentNum: return UIFont.opticianSansFont(ofSize: 24)
//        case .bothUpcomingSmallNum: return UIFont.opticianSansFont(ofSize: 30)
//        case .bothUpcomingBigNum: return UIFont.opticianSansFont(ofSize: 62)
//        case .bothSubtitle3: return UIFont.pretendardFont(ofSize: 24, weight: .medium)
//        case .bothProfileTitle: return UIFont.pretendardFont(ofSize: 24, weight: .bold)
        
        }
    }
    
}
