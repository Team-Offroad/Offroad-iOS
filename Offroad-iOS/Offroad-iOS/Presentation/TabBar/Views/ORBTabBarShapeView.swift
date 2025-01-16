//
//  ORBTabBarShapeView.swift
//  Offroad-iOS
//
//  Created by 김민성 on 10/6/24.
//

import UIKit

final class ORBTabBarShapeView: UIView {
    
    //MARK: - UI Properties
    
    var blurEffectView = CustomIntensityBlurView(blurStyle: .dark, intensity: 0.15)
    
    //MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupStyle()
        setupHierarchy()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        drawORBTabBarShape()
    }
    
}

extension ORBTabBarShapeView {
    
    //MARK: - Layout Func
    
    private func setupLayout() {
        blurEffectView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    //MARK: - Private Func
    
    private func setupStyle() {
        backgroundColor = .sub(.sub480)
        isUserInteractionEnabled = false
    }
    
    private func setupHierarchy() {
        addSubview(blurEffectView)
    }
    
    private func drawORBTabBarShape() {
        let path = UIBezierPath()
        path.move(to: .init(x: 25, y: 0))
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
        path.addLine(to: .init(x: bounds.width - 25, y: 0))
        path.addCurve(
            to: .init(x: bounds.width, y: 25),
            controlPoint1: .init(x: bounds.width - 11.2, y: 0),
            controlPoint2: .init(x: bounds.width, y: 11.2)
        )
        path.addLine(to: .init(x: bounds.width, y: bounds.height))
        path.addLine(to: .init(x: 0, y: bounds.height))
        path.addLine(to: .init(x: 0, y: 25))
        path.addCurve(
            to: .init(x: 25, y: 0),
            controlPoint1: .init(x: 0, y: 11.2),
            controlPoint2: .init(x: 11.2, y: 0)
        )
        path.close()
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        layer.mask = shapeLayer
    }
    
}
