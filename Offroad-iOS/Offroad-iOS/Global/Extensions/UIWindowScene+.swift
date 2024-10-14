//
//  UIWindowScene+.swift
//  Offroad-iOS
//
//  Created by 김민성 on 10/12/24.
//

import UIKit

extension UIWindowScene {
    
    /// 현재 windowScene을 반환해 주는 계산 속성
    static var current: UIWindowScene {
        for scene in UIApplication.shared.connectedScenes {
            guard let windowScene = scene as? UIWindowScene else { continue }
            return windowScene
        }
        fatalError("connected scene not found")
    }
    
}
