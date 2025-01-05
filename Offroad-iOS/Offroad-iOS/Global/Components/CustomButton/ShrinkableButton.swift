//
//  ShrinkableButton.swift
//  Offroad-iOS
//
//  Created by 김민성 on 1/5/25.
//

import UIKit

class ShrinkableButton: UIButton, ORBTouchFeedback {
    
    //MARK: - Properties
    
    var shrinkScale: CGFloat = 0.9
    let animator: UIViewPropertyAnimator = .init(duration: 0.3, dampingRatio: 1)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(shrinkScale: CGFloat) {
        super.init(frame: .zero)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
