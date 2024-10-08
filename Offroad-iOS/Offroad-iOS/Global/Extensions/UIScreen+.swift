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
    
    /// 현재 screen의 사이즈를 반환하는 타입 변수
    static var currentScreenSize: CGSize {
        current.bounds.size
    }
    
    /// screen의 긴 변의 길이가 짧은 변의 길이의 두 배가 넘는 지의 여부를 계산하는 변수.
    /// 사용 중인 기기가 홈 버튼이 있는 기종인지 여부를 판단하기 위해 사용할 수 있음.
    var isAspectRatioTall: Bool {
        let (width, height) = (bounds.size.width, bounds.size.height)
        return max(width, height) >= min(width, height) * 2
    }
    
}
