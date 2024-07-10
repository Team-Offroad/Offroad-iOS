//
//  CustomRecentProgressView.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 7/10/24.
//

import UIKit

final class CustomRecentProgressView: UIView {
    
    //MARK: - Properties
    
    private var circleLayer = CAShapeLayer()
    private var progressLayer = CAShapeLayer()
    private var startPoint = -CGFloat.pi / 2
    private var endPoint = 3 * CGFloat.pi / 2
    
    //MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        createCircularPath(rect: rect)
    }
}

extension CustomRecentProgressView {
    
    //MARK: - Method
    
    func createCircularPath(rect: CGRect) {
        let centerX = rect.width / 2.0
        let centerY = rect.height / 2.0
        let circularPath = UIBezierPath(arcCenter: .init(x: centerX,
                                                         y: centerY),
                                        radius: frame.size.height / 2.0,
                                        startAngle: startPoint,
                                        endAngle: endPoint,
                                        clockwise: true)
        circleLayer.path = circularPath.cgPath
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.lineCap = .round
        circleLayer.lineWidth = 9
        circleLayer.strokeEnd = 1.0
        circleLayer.strokeColor = UIColor.home(.homeContents1GraphSub).cgColor
        layer.addSublayer(circleLayer)
        
        progressLayer.path = circularPath.cgPath
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineCap = .round
        progressLayer.lineWidth = 9
        progressLayer.strokeEnd = 0.75
        progressLayer.strokeColor = UIColor.home(.homeContents1GraphMain).cgColor
        layer.addSublayer(progressLayer)
    }
}
