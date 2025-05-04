//
//  ORBRecommendationChatBackgroundView.swift
//  ORB_Dev
//
//  Created by 김민성 on 5/4/25.
//

import UIKit

final class ORBRecommendationChatBackgroundView: UIView {
    
    private(set) var plainLayer: CALayer!
    private(set) var gradientLayer: CAGradientLayer!
    
    var color1: UIColor = UIColor.init(hex: "62DDFF")!.withAlphaComponent(0.1)
    var color2: UIColor = UIColor.init(hex: "455BFF")!.withAlphaComponent(0.05)
    var color3: UIColor = UIColor.init(hex: "CC01FF")!.withAlphaComponent(0.05)
    var color4: UIColor = UIColor.init(hex: "FF007B")!.withAlphaComponent(0.05)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupGradientLayer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupGradientLayer() {
        plainLayer = CALayer()
        plainLayer.backgroundColor = UIColor.init(hex: "F6F4FF")!.cgColor
        layer.addSublayer(plainLayer)
        
        gradientLayer = CAGradientLayer()
        gradientLayer.type = .axial
        gradientLayer.colors = [color1, color2, color3, color4, color3, color2, color1].map({ $0.cgColor })
        gradientLayer.startPoint = .init(x: 1, y: 0)
        gradientLayer.endPoint = .init(x: 0, y: 1)
        layer.addSublayer(gradientLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        plainLayer.frame = bounds
        gradientLayer.frame = bounds
    }
    
}
