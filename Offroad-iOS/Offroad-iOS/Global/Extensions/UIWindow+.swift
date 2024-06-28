//
//  UIWindow+.swift
//  Offroad-iOS
//
//  Created by 김민성 on 2024/06/25.
//

import UIKit

extension UIWindow {
    
    
    /// 현재 window를 반환하는 타입 변수
    static var current: UIWindow {
        for scene in UIApplication.shared.connectedScenes {
            guard let windowScene = scene as? UIWindowScene else { fatalError() }
            for window in windowScene.windows {
                if window.isKeyWindow { return window }
            }
        }
        fatalError()
    }
    
}
