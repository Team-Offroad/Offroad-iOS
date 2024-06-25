//
//  UIScreen+.swift
//  Offroad-iOS
//
//  Created by 김민성 on 2024/06/25.
//

import UIKit

extension UIScreen {
    
    /// 현재 screen을 반환하는 타입 변수
    static var current: UIScreen {
        UIWindow.current.screen
    }
}
