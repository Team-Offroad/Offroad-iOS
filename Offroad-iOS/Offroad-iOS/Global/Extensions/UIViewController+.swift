//
//  UIViewController+.swift
//  Offroad-iOS
//
//  Created by 김민성 on 10/12/24.
//

import UIKit

extension UIViewController {
    
    func showToast(message: String, inset: CGFloat, withImage image: UIImage? = nil) {
        ORBToastManager.shared.showToast(message: message, inset: inset, withImage: image)
    }
    
    func hideToast() {
        ORBToastManager.shared.hideToast()
    }
    
}
