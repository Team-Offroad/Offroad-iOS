//
//  UIStackView+.swift
//  Offroad-iOS
//
//  Created by 김민성 on 2024/06/25.
//

import UIKit

extension UIStackView {
    
    /// arrangedSubviews를 한번에!~
    /// - Parameter views: 추가할 arrangedSubview들
    func addArrangedSubviews(_ views: UIView...) {
        for view in views {
            self.addArrangedSubview(view)
        }
    }
    
}
