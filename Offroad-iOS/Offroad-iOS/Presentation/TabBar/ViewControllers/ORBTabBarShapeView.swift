//
//  ORBTabBarShapeView.swift
//  Offroad-iOS
//
//  Created by 김민성 on 10/6/24.
//

import UIKit

final class ORBTabBarShapeView: UIView {
    
    //MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        isUserInteractionEnabled = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath()
        path.move(to: .zero)
        path.addLine(to: .init(x: center.x - 55.4, y: 0))
        path.addCurve(
            to: .init(x: center.x - 44.75, y: 8.2),
            controlPoint1: .init(x: center.x - 50.5, y: 0),
            controlPoint2: .init(x: center.x - 46.5, y: 3.6)
        )
        path.addCurve(
            to: .init(x: center.x, y: 38.2),
            controlPoint1: .init(x: center.x - 38.2, y: 26),
            controlPoint2: .init(x: center.x - 21.2, y: 38.2)
        )
        path.addCurve(
            to: .init(x: center.x + 44.75, y: 8.2),
            controlPoint1: .init(x: center.x + 21.2, y: 38.2),
            controlPoint2: .init(x: center.x + 38.2, y: 26)
        )
        path.addCurve(
            to: .init(x: center.x + 55.4, y: 0),
            controlPoint1: .init(x: center.x + 46.5, y: 3.6),
            controlPoint2: .init(x: center.x + 50.5, y: 0)
        )
        path.addLine(to: .init(x: center.x + 55.4, y: 0))
        path.addLine(to: .init(x: bounds.width, y: 0))
        path.addLine(to: .init(x: bounds.width, y: bounds.height))
        path.addLine(to: .init(x: 0, y: bounds.height))
//        path.addLine(to: .zero) // 없어도 될 듯?
        path.close()
        
        UIColor.sub(.sub4).setFill()
        path.fill()
        
    }
    
}
