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
        createLinePath(rect: rect)
    }
}

extension CustomAlmostDoneProgressView {
    
    //MARK: - Method
    
    func createLinePath(rect: CGRect) {
        let linePath = UIBezierPath()
        linePath.move(to: CGPoint(x: rect.minX, y: rect.midY))
        linePath.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        
        lineLayer.path = linePath.cgPath
        lineLayer.lineCap = .round
        lineLayer.lineWidth = 9
        lineLayer.strokeColor = UIColor.blackOpacity(.black25).cgColor
        layer.addSublayer(lineLayer)
        
        let endPointX = rect.maxX - rect.width / 8.0
        let progressPath = UIBezierPath()
        progressPath.move(to: CGPoint(x: rect.minX, y: rect.midY))
        progressPath.addLine(to: CGPoint(x: endPointX, y: rect.midY))
        
        progressLayer.path = progressPath.cgPath
        progressLayer.lineCap = .round
        progressLayer.lineWidth = 9
        progressLayer.strokeColor = UIColor.sub(.sub4).cgColor
        layer.addSublayer(progressLayer)
    }
}
