//
//  CustomAlmostDoneProgressView.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 7/10/24.
//

import UIKit

final class CustomAlmostDoneProgressView: UIView {
    
    //MARK: - Properties
    
    private var lineLayer = CAShapeLayer()
    private var progressLayer = CAShapeLayer()
    
    //MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        createLinePath(rect: rect)
    }
}

extension CustomAlmostDoneProgressView {
    
    //MARK: - Private Func
    
    private func createLinePath(rect: CGRect) {
        let linePath = UIBezierPath()
        linePath.move(to: CGPoint(x: rect.minX, y: rect.midY))
        linePath.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        
        lineLayer.path = linePath.cgPath
        lineLayer.lineCap = .round
        lineLayer.lineWidth = 9
        lineLayer.strokeColor = UIColor.blackOpacity(.black25).cgColor
        layer.addSublayer(lineLayer)
        
        progressLayer.lineCap = .round
        progressLayer.lineWidth = 9
        progressLayer.strokeColor = UIColor.sub(.sub4).cgColor
        layer.addSublayer(progressLayer)
    }
    
    //MARK: - Func
    
    func setProgressView(progressValue: CGFloat) {
        let endPointX = bounds.width * progressValue
        let progressPath = UIBezierPath()
        progressPath.move(to: CGPoint(x: bounds.minX, y: bounds.midY))
        progressPath.addLine(to: CGPoint(x: endPointX, y: bounds.midY))
        
        if progressValue == 0 {
            progressLayer.lineCap = .butt
        }
        progressLayer.path = progressPath.cgPath
    }
}
