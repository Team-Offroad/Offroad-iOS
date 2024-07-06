//
//  UIColor+.swift
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
}

enum Main: String, OffroadColor {
    // main1_75
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
    case bottomBarButtonStroke = "#FEFBF6"
    case btnInactive = "#EBEBEB"
    case bottomBarInactive = "#A4A099"
    case nametagInactive = "#FFEDDB"
}

enum BlackOpacity: String, OffroadColor {
    case black15 = "#000000"
    case black25 = "#000000"
    case black55 = "#000000"
    case qrCamera = "#000000"
}

enum WhiteOpacity: String, OffroadColor {
    case white75 = "#FFFFFF"
    case white25 = "#FFFFFF"
}

enum Home: String, OffroadColor {
    case homeBg = "#463E32"
    case homeNametagStroke = "#FFE2C4"
    case homeContents1 = "#8B8446"
    case homeContents1GraphMain = "#FED761"
    case homeContents1GraphSub = "#BBAC57"
    case homeContents2 = "#E6CEAA"
    case homeCharacterName = "#8B6546"
}


extension UIColor {
    
    static func primary(_ style: Primary, alpha: CGFloat = 1) -> UIColor {
        guard let color = UIColor(hexCode: style.rawValue, alpha: alpha) else { fatalError("UIColor init failed") }
        return color
    }
    
    static func main(_ style: Main, alpha: CGFloat = 1) -> UIColor {
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
        guard let color = UIColor(hexCode: style.rawValue, alpha: alpha) else { fatalError("UIColor init failed") }
        return color
    }
    
    static func blackOpacity(_ style: BlackOpacity, alpha: CGFloat = 1) -> UIColor {
        guard let color = UIColor(hexCode: style.rawValue, alpha: alpha) else { fatalError("UIColor init failed") }
        return color
    }
    
    static func whiteOpacity(_ style: WhiteOpacity, alpha: CGFloat = 1) -> UIColor {
        guard let color = UIColor(hexCode: style.rawValue, alpha: alpha) else { fatalError("UIColor init failed") }
        return color
    }
    
    static func home(_ style: Home, alpha: CGFloat = 1) -> UIColor {
        guard let color = UIColor(hexCode: style.rawValue, alpha: alpha) else { fatalError("UIColor init failed") }
        return color
    }
    
    /// 위의 함수들이 너무 반복되는 코드같아 보여서 제네릭 형식으로도 만들어 보았음.
    ///
    /// 실제 사용되지는 않음. (논의 필요)
    /// 아마 사용될 경우, 다음과 같이 사용될 듯.
    /// `let color = UIColor.offroad(Main.main1)`
    static func offroad<T: OffroadColor>(_ style: T, alpha: CGFloat = 1) -> UIColor {
        guard let color = UIColor(hexCode: style.rawValue, alpha: alpha) else { fatalError("UIColor init failed") }
        return color
    }
    
    // 코드 출처: https://www.hackingwithswift.com/example-code/uicolor/how-to-convert-a-hex-color-to-a-uicolor
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
