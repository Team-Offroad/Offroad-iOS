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
    private var startAngle = -CGFloat.pi / 2
    private var endAngle = 3 * CGFloat.pi / 2
    
    //MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        createCircularPath()
    }
}

extension CustomRecentProgressView {
    
    //MARK: - Private Method
    
    func createCircularPath() {
        let centerX = bounds.width / 2.0
        let centerY = bounds.height / 2.0
        let circularPath = UIBezierPath(arcCenter: .init(x: centerX, y: centerY),
                                        radius: frame.size.height / 2.0,
                                        startAngle: startAngle,
                                        endAngle: endAngle,
                                        clockwise: true)
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
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
        progressLayer.strokeColor = UIColor.home(.homeContents1GraphMain).cgColor
        layer.addSublayer(progressLayer)
        
        CATransaction.commit()
    }
    
    func setProgressView(progressValue: CGFloat) {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        progressLayer.strokeEnd = progressValue
        
        CATransaction.commit()
    }
}
