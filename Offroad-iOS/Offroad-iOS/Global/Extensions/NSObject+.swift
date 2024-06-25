//
//  NSObject+.swift
//  Offroad-iOS
//
//  Created by 김민성 on 2024/06/25.
//

import Foundation


extension NSObject {
    
    /// 클래스의 이름
    static var className: String {
        return String(describing: self)
    }
}
