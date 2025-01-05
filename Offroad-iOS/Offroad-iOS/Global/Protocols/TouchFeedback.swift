//
//  TouchFeedback.swift
//  Offroad-iOS
//
//  Created by 김민성 on 1/5/25.
//

import UIKit

protocol TouchFeedback {
    
    var animator: UIViewPropertyAnimator { get }
    
    func shrink(scale: CGFloat)
    func expand()
    
}
