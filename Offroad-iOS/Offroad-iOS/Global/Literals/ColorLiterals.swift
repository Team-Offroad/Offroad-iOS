//
//  ColorLiterals.swift
//  Offroad-iOS
//
//  Created by 김민성 on 2024/07/06.
//

import UIKit

protocol OffroadColor: RawRepresentable where RawValue == String { }

enum Primary: String, OffroadColor {
    case white = "#FFFFFF"
    case black = "#000000"
    case kakao = "#FEE500"
    case error = "#F04452"
    case mapGradi = "#5B5B5B"
    case characterSelectBg1 = "FFF4CC"
    case characterSelectBg2 = "FFE1C5"
    case characterSelectBg3 = "F9E5D2"
    case wall = "452B0F"
    case ground = "685440"
    case listBg = "F6EEDF"
    case boxInfo = "FFF5EA"
    case getCharacter = "FFB141"
}

enum Main: String, OffroadColor {
    // main1_75, alpha = 0.75
    case main175 = "#FEFBF6"
    case main1 = "#FFF7E7"
    case main2 = "#1D1E18"
    case main3 = "#FFFBF4"
}

enum Sub: String, OffroadColor {
    case sub = "#FF901C"
    case sub2 = "#E57A2C"
    case sub3 = "#8B6546"
    case sub4 = "#353028"
}

enum Grayscale: String, OffroadColor {
    case gray100 = "#D9D9D9"
    case gray200 = "#BEBEBE"
    case gray300 = "#B2B2B2"
    case gray400 = "#7E7E7E"
}

enum Neutral: String, OffroadColor {
    // alpha = 0.25
    case bottomBarButtonStroke = "#FEFBF6"
    case btnInactive = "#EBEBEB"
    case bottomBarInactive = "#A4A099"
    case nametagInactive = "#FFEDDB"
}

// 색상 hex code는 qrCamera(#181818)를 제외하고 모두 #000000으로 동일
enum BlackOpacity: String, OffroadColor {
    // alpha = 0.55
    case black15
    // alpha = 0.25
    case black25
    // alpha = 0.55
    case black55
    // alpha = 0.5
    case qrCamera
}

// 색상 hex code는 모두 #FFFFFF으로 동일
enum WhiteOpacity: String, OffroadColor {
    // alpha = 0.75
    case white75
    // alpha = 0.25
    case white25
}

enum Home: String, OffroadColor {
    case homeBg = "#463E32"
    case homeNametagStroke = "#FFD6AB"
    case homeContents1 = "#8B8446"
    case homeContents1GraphMain = "#FED761"
    case homeContents1GraphSub = "#BBAC57"
    case homeContents2 = "#E6CEAA"
    // alpha = 0.25
    case homeCharacterName = "#8B6546"
    case homeNicknameStroke = "#C0B3A2"
}


extension UIColor {
    
    static func primary(_ style: Primary, alpha: CGFloat = 1) -> UIColor {
        guard let color = UIColor(hexCode: style.rawValue, alpha: alpha) else { fatalError("UIColor init failed") }
        return color
    }
    
    static func main(_ style: Main, alpha: CGFloat = 1) -> UIColor {
        let alpha: CGFloat
        switch style {
        case .main175: alpha = 0.75
        default: alpha = 1
        }
        guard let color = UIColor(hexCode: style.rawValue, alpha: alpha) else { fatalError("UIColor init failed") }
        return color
    }
    
    static func sub(_ style: Sub, alpha: CGFloat = 1) -> UIColor {
        guard let color = UIColor(hexCode: style.rawValue, alpha: alpha) else { fatalError("UIColor init failed") }
        return color
    }
    
    static func grayscale(_ style: Grayscale, alpha: CGFloat = 1) -> UIColor {
        guard let color = UIColor(hexCode: style.rawValue, alpha: alpha) else { fatalError("UIColor init failed") }
        return color
    }
    
    static func neutral(_ style: Neutral, alpha: CGFloat = 1) -> UIColor {
        let alpha = style == .bottomBarButtonStroke ? 0.25 : 1
        guard let color = UIColor(hexCode: style.rawValue, alpha: alpha) else { fatalError("UIColor init failed") }
        return color
    }
    
    static func blackOpacity(_ style: BlackOpacity) -> UIColor {
        let alpha: CGFloat
        switch style {
        case .black15: alpha = 0.15
        case .black25: alpha = 0.25
        case .black55: alpha = 0.55
        case .qrCamera: alpha = 0.5
        }
        
        switch style {
        case .black15, .black25, .black55:
            guard let color = UIColor(hexCode: "#000000", alpha: alpha) else { fatalError("UIColor init failed") }
            return color
        case .qrCamera:
            guard let color = UIColor(hexCode: "#181818", alpha: alpha) else { fatalError("UIColor init failed") }
            return color
        }
    }
    
    static func whiteOpacity(_ style: WhiteOpacity) -> UIColor {
        let alpha: CGFloat
        switch style {
        case .white75: alpha = 0.75
        case .white25: alpha = 0.25
        }
        
        guard let color = UIColor(hexCode: "#FFFFFF", alpha: alpha) else { fatalError("UIColor init failed") }
        return color
    }
    
    static func home(_ style: Home, alpha: CGFloat = 1) -> UIColor {
        let alpha: CGFloat
        switch style {
        case .homeCharacterName: alpha = 0.25
        default: alpha = 1
        }
        
        guard let color = UIColor(hexCode: style.rawValue, alpha: alpha) else { fatalError("UIColor init failed") }
        return color
    }
    
    convenience init?(hexCode: String, alpha: CGFloat = 1.0) {
        var hexFormatted: String = hexCode.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        
        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }
        
        guard hexFormatted.isValidHexSixDigits() else { return nil }
        
        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
        
        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                  alpha: alpha)
    }
    
}
