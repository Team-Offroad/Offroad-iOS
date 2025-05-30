//
//  ORBRecommendationGradientLayer.swift
//  ORB_Dev
//
//  Created by 김민성 on 4/15/25.
//

import UIKit

/// 오브의 추천소 그라데이션을 나타내는 conic 타입의 CAGradientLayer. 무한루프로 애니메이션이 재생됨.
final class ORBRecommendationGradientLayer: CAGradientLayer {
    
    // orbGradient에 사용될 CGColor들
    private let color1: CGColor = UIColor.init(hex: "62DDFF")!.cgColor // 하늘색
    private let color2: CGColor = UIColor.init(hex: "455BFF")!.cgColor // 파란색
    private let color3: CGColor = UIColor.init(hex: "CC01FF")!.cgColor // 보라색
    private let color4: CGColor = UIColor.init(hex: "FF007B")!.cgColor // 자주색
    private lazy var cgColors: [CGColor] = [color1, color2, color3, color4]
    
    // 하나의 colorCombination은 테두리를 따라 표현되는 색의 조합을 의미한다.
    // 자연스러운 색의 연결을 위해서는 colorCombination의 처음과 끝이 같아야 한다.
    private var colorCombination1: [CGColor] { [2, 3, 4, 3, 2, 1, 2].map { cgColors[$0-1] } }
    private var colorCombination2: [CGColor] { [3, 1, 3, 2, 1, 2, 3].map { cgColors[$0-1] } }
    private var colorCombination3: [CGColor] { [4, 1, 2, 3, 1, 3, 4].map { cgColors[$0-1] } }
    private var colorCombination4: [CGColor] { [1, 3, 3, 4, 3, 2, 1].map { cgColors[$0-1] } }
    
    // colorCombinations는 한 사이클(4, 5, 6초 중 랜덤값) 동안 연속으로 표시될 colorCombination들의 조합이다.
    // 실제 애니메이션에는 새로운 사이클이 시작할 때 아래 적힌 4 개의 조합 중 하나를 랜덤으로 선택함.
    private var colorCombinations1: [[CGColor]] {
        [colorCombination1, colorCombination2, colorCombination3, colorCombination4, colorCombination1]
    }
    private var colorCombinations2: [[CGColor]] {
        [colorCombination1, colorCombination4, colorCombination3, colorCombination2, colorCombination1]
    }
    private var colorCombinations3: [[CGColor]] {
        [colorCombination1, colorCombination4, colorCombination2, colorCombination2, colorCombination1]
    }
    private var colorCombinations4: [[CGColor]] {
        [colorCombination1, colorCombination3, colorCombination2, colorCombination4, colorCombination1]
    }
    
    override init() {
        super.init()
        
        type = .conic
        startPoint = CGPoint(x: 0.5, y: 0.5)
        endPoint = CGPoint(x: 0.0, y: 0.0)
        colors = colorCombination1
        startAnimation()
    }
    
    override init(layer: Any) {
        super.init(layer: layer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func startAnimation() {
        let glowAnimation = CAKeyframeAnimation(keyPath: "colors")
        glowAnimation.values = [colorCombinations1, colorCombinations2, colorCombinations3, colorCombinations4].randomElement()
        glowAnimation.keyTimes = [0, 0.25, 0.5, 0.75, 1]
        glowAnimation.duration = Double([4, 5, 6].randomElement()!)
        glowAnimation.repeatCount = .infinity
        glowAnimation.isRemovedOnCompletion = false
        add(glowAnimation, forKey: "glowAnimation")
    }
    
}
