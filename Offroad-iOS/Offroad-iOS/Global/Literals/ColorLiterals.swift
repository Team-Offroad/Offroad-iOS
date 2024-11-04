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
    case errorNew = "#F72585"
//    case mapGradi = "#5B5B5B"
    case characterSelectBg1 = "#D8D6FF"
    case characterSelectBg2 = "#FFE1C5"
    case characterSelectBg3 = "#F9E5D2"
    case getCharacter002 = "#FFB141"
    case getCharacterBg001 = "#FFF0BC"
    case wall = "#452B0F"
    case ground = "#685440"
    // 그래디언트 효과임.
//    case chatGradient = "#FF"
    case listBg = "#EAE9F6"
    case boxInfo = "#EFEFFF"
    case stroke = "#C7C5FF"
}

enum Main: String, OffroadColor {
    // main1_75, alpha = 0.75
    case main175 = "#FFF7E7BF"
    case main1 = "#F6F4FF"
    case main2 = "#1D1E18"
    case main3 = "#FFFFFF"
}

enum Sub: String, OffroadColor {
    case sub = "#5E59FF"
    // sub, alpha = 0.55
    case sub55 = "#5E59FF8C"
    // 열거형의 원시값이 unique 해야 하는데, sub과 sub2의 값이 같아 sub2에 임시로 투명도 100%를 의미하는 FF를 뒤에 붙여놓은 상태.
    case sub2 = "#E57A2CFF"
//    case sub3 = "#8B6546"
    case sub4 = "#282C75"
    case sub480 = "#282C75CC"
}

enum Grayscale: String, OffroadColor {
    case gray100 = "#D9D9D9"
    case gray200 = "#BEBEBE"
    case gray300 = "#B2B2B2"
    case gray400 = "#7E7E7E"
}

enum Neutral: String, OffroadColor {
    // alpha = 0.25
    case bottomBarButtonStroke = "#FEFBF640"
    case btnInactive = "#EBEBEB"
    case bottomBarInactive = "#A4A099"
    case nametagInactive = "#E5E4FF"
}

// 색상 hex code는 qrCamera(#181818)를 제외하고 모두 #000000으로 동일
enum BlackOpacity: String, OffroadColor {
    // alpha = 0.55
    case black15 = "#00000026"
    // alpha = 0.25
    case black25 = "#00000040"
    // alpha = 0.55
    case black55 = "#0000008C"
    // alpha = 0.5
    case qrCamera = "18181880"
}

// 색상 hex code는 모두 #FFFFFF으로 동일
enum WhiteOpacity: String, OffroadColor {
    // alpha = 0.75
    case white75 = "#FFFFFFBF"
    // alpha = 0.25
    case white25 = "#FFFFFF40"
}

enum Home: String, OffroadColor {
//    case homeBg = "#463E32"
//    case homeNametagStroke = "#FFD6AB"
    case homeContents1 = "#382D93B2"
    case homeContents1GraphMain = "#F477A1"
    case homeContents1GraphSub = "#9B429D"
    case homeContents2 = "#4437A1B2"
    // alpha = 0.25
    case homeCharacterName = "#00000040"
//    case homeNicknameStroke = "#C0B3A2"
}

enum Setting: String, OffroadColor {
    case settingCoupon = "#FFDED8"
    case settingCharacter = "#FFF7D1"
    case settingSetting = "#D2E0FF"
    case settingNametag = "FBDAED"
}

extension UIColor {
    
    static func primary(_ style: Primary, alpha: CGFloat = 1) -> UIColor {
        guard let color = UIColor(hexCode: style.rawValue) else { fatalError("UIColor init failed") }
        return color
    }
    
    static func main(_ style: Main, alpha: CGFloat = 1) -> UIColor {
//        let alpha: CGFloat
//        switch style {
//        case .main175: alpha = 0.75
//        default: alpha = 1
//        }
        guard let color = UIColor(hexCode: style.rawValue) else { fatalError("UIColor init failed") }
        return color
    }
    
    static func sub(_ style: Sub, alpha: CGFloat = 1) -> UIColor {
        guard let color = UIColor(hexCode: style.rawValue) else { fatalError("UIColor init failed") }
        return color
    }
    
    static func grayscale(_ style: Grayscale, alpha: CGFloat = 1) -> UIColor {
        guard let color = UIColor(hexCode: style.rawValue) else { fatalError("UIColor init failed") }
        return color
    }
    
    static func neutral(_ style: Neutral, alpha: CGFloat = 1) -> UIColor {
//        let alpha = style == .bottomBarButtonStroke ? 0.25 : 1
        guard let color = UIColor(hexCode: style.rawValue) else { fatalError("UIColor init failed") }
        return color
    }
    
    static func blackOpacity(_ style: BlackOpacity) -> UIColor {
//        let alpha: CGFloat
//        switch style {
//        case .black15: alpha = 0.15
//        case .black25: alpha = 0.25
//        case .black55: alpha = 0.55
//        case .qrCamera: alpha = 0.5
//        }
//        
//        switch style {
//        case .black15, .black25, .black55:
//            guard let color = UIColor(hexCode: "#000000", alpha: alpha) else { fatalError("UIColor init failed") }
//            return color
//        case .qrCamera:
//            guard let color = UIColor(hexCode: "#181818", alpha: alpha) else { fatalError("UIColor init failed") }
//            return color
//        }
        
        guard let color = UIColor(hexCode: style.rawValue) else { fatalError("UIColor init failed") }
        return color
    }
    
    static func whiteOpacity(_ style: WhiteOpacity) -> UIColor {
//        let alpha: CGFloat
//        switch style {
//        case .white75: alpha = 0.75
//        case .white25: alpha = 0.25
//        }
        
        guard let color = UIColor(hexCode: "#FFFFFF") else { fatalError("UIColor init failed") }
        return color
    }
    
    static func home(_ style: Home) -> UIColor {
//        let alpha: CGFloat
//        switch style {
//        case .homeCharacterName: alpha = 0.25
//        default: alpha = 1
//        }
//        
        guard let color = UIColor(hexCode: style.rawValue) else { fatalError("UIColor init failed") }
        return color
    }
    
//    convenience init?(hexCode: String, alpha: CGFloat = 1.0) {
//        var hexFormatted: String = hexCode.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
//        
//        if hexFormatted.hasPrefix("#") {
//            hexFormatted = String(hexFormatted.dropFirst())
//        }
//        
//        guard hexFormatted.isValidHexSixDigits() else { return nil }
//        
//        var rgbValue: UInt64 = 0
//        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
//        
//        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
//                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
//                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
//                  alpha: alpha)
//    }
    
    convenience init?(hexCode: String) {
        var hexFormatted: String = hexCode.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        
        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }
        
        guard let validHexCodeCount = hexFormatted.getValidHexDigits() else {
            fatalError("Invalid hex code: \(hexFormatted)")
        }
        
        var rgbValue: UInt64 = 0
        var alpha: UInt64 = 255
        if validHexCodeCount == 6 {
            Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
        } else if validHexCodeCount == 8 {
            Scanner(string: String(hexFormatted.prefix(6))).scanHexInt64(&rgbValue)
            Scanner(string: String(hexFormatted.suffix(2))).scanHexInt64(&alpha)
        }
        
        print("alpha 값은 \(CGFloat((alpha & 0xFF)) / 255.0)")
        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                  alpha: CGFloat((alpha & 0xFF)) / 255.0)
    }
    
}
