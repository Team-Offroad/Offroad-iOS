//
//  RecommendationButtonInChatLogCell.swift
//  ORB_Dev
//
//  Created by 김민성 on 6/15/25.
//

import UIKit

import SnapKit

/// 오브 캐릭터와 채팅 중에, 오브의 추천소로 이동을 유도하는 버튼. 보라색 그라데이션이 적용됨.
final class RecommendationButtonInChatLogCell: ShrinkableButton {
    
    let gradientLayer: CAGradientLayer = {
        let purpleGradientColors: [CGColor] = [
            UIColor.init(hex: "A688F9")!.cgColor,
            UIColor.init(hex: "A58DFA")!.cgColor,
            UIColor.init(hex: "A292FB")!.cgColor,
            UIColor.init(hex: "A198FB")!.cgColor,
            UIColor.init(hex: "AFA7FB")!.cgColor,
            UIColor.init(hex: "C0B0FF")!.cgColor,
            UIColor.init(hex: "C4BAFF")!.cgColor,
        ]
        let layer = CAGradientLayer()
        layer.colors = purpleGradientColors
        layer.startPoint = .init(x: 0, y: 0.5)
        layer.endPoint = .init(x: 1, y: 0.5)
        layer.locations = [0, 0.17, 0.35, 0.52, 0.69, 0.85, 1]
        return layer
    }()
    
    init() {
        super.init(frame: .zero)
        
        self.layer.addSublayer(gradientLayer)
        self.setTitle("오브의 추천소", for: .normal)
        self.setTitleColor(.main(.main1), for: .normal)
        self.titleLabel?.font = .offroad(style: .iosText)
        self.roundCorners(cornerRadius: 5)
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        
        gradientLayer.frame = bounds
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

