//
//  ORBTouchFeedback.swift
//  Offroad-iOS
//
//  Created by 김민성 on 1/5/25.
//

import UIKit

protocol ORBTouchFeedback {
    
    var animator: UIViewPropertyAnimator { get }
    
    func shrink(scale: CGFloat)
    func expand()
    
}
