//
//  ShrinkableButton.swift
//  Offroad-iOS
//
//  Created by 김민성 on 1/5/25.
//

import UIKit

class ShrinkableButton: UIButton, ORBTouchFeedback {
    
    //MARK: - Properties
    
    var shrinkScale: CGFloat
    
    private(set) var shrinkingAnimator: UIViewPropertyAnimator = .init(duration: 0.3, dampingRatio: 1)
    
    //MARK: - Life Cycle
    
    /// shrinkScale을 0.9로 설정
    ///
    /// `shrinkScale` 속성을 임의로 초기화하고 싶은 경우, 다른 지정생성자인 `init(shrinkScale:)`를 사용하세요.
    override init(frame: CGRect) {
        self.shrinkScale = 0.9
        super.init(frame: frame)
        
        setupTargets()
    }
    
    /// `shrinkScale` 속성을 임의의 값으로 초기화하는 지정생성자
    /// - Parameter shrinkScale: 손가락이 버튼에 닿을 때 축소될 비율에 해당하는 속성. 다른 지정생성자인 `init(frame:)`를 사용하는 경우 0.9로 설정됨.
    init(shrinkScale: CGFloat) {
        self.shrinkScale = shrinkScale
        super.init(frame: .zero)
        
        setupTargets()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ShrinkableButton {
    
    //MARK: - objc Func
    
    @objc private func touchDown() {
        shrink(scale: shrinkScale)
    }
    
    @objc private func touchDragExit() {
        restore()
        cancelTracking(with: nil)
    }
    
    @objc private func touchUpInside() {
        restore()
    }
    
    //MARK: - Private Func
    
    private func setupTargets() {
        addTarget(self, action: #selector(touchDown), for: .touchDown)
        addTarget(self, action: #selector(touchDragExit), for: .touchDragExit)
        addTarget(self, action: #selector(touchUpInside), for: .touchUpInside)
    }
    
}
