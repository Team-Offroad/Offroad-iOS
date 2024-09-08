//
//  UIColor+.swift
//  Offroad-iOS
//
//  Created by  정지원 on 9/8/24.
//

import UIKit

//UIColor(hex: String(hexColorCode.suffix(6)))
extension UIColor {
    // 8자리 또는 6자리 Hex String을 UIColor로 변환하는 함수
    convenience init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        var length = 0
        
        // Hex 코드를 UInt64로 변환
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        length = hexSanitized.count

        // 8자리일 경우 앞의 두 자리를 Alpha로 처리
        if length == 8 {
            let r = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            let g = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
            let b = CGFloat(rgb & 0x000000FF) / 255.0
            let a = CGFloat((rgb & 0xFF000000) >> 24) / 255.0

            self.init(red: r, green: g, blue: b, alpha: a)
        } else {
            return nil
        }
    }
}
