//
//  UIColor+.swift
//  Offroad-iOS
//
//  Created by  정지원 on 9/8/24.
//

import UIKit

extension UIColor {
    
    // 16진수 색상 코드를 받아 UIColor로 변환
    convenience init?(hexCode: String) {
        var hexString = hexCode.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        // # 기호가 없으면 추가
        if hexString.hasPrefix("#") == false {
            hexString = "#" + hexString
        }
        
        // 색상 코드가 7자리가 아니라면 (예: #FFFFFF 혹은 #FFF9E5D2)
        guard hexString.count == 7 || hexString.count == 9 else {
            return nil
        }
        
        var rgbValue: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&rgbValue)
        
        if hexString.count == 7 {
            // 6자리 색상 코드 (#RRGGBB)
            let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
            let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
            let blue = CGFloat(rgbValue & 0x0000FF) / 255.0
            
            self.init(red: red, green: green, blue: blue, alpha: 1.0)
        } else if hexString.count == 9 {
            // 8자리 색상 코드 (#AARRGGBB)
            let alpha = CGFloat((rgbValue & 0xFF000000) >> 24) / 255.0
            let red = CGFloat((rgbValue & 0x00FF0000) >> 16) / 255.0
            let green = CGFloat((rgbValue & 0x0000FF00) >> 8) / 255.0
            let blue = CGFloat(rgbValue & 0x000000FF) / 255.0
            
            self.init(red: red, green: green, blue: blue, alpha: alpha)
        } else {
            return nil
        }
    }
}

