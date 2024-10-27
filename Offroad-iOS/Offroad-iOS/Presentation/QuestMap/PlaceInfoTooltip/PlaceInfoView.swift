//
//  PlaceInfoView.swift
//  Offroad-iOS
//
//  Created by 김민성 on 10/27/24.
//

import UIKit

class PlaceInfoView: UIView {
    
    let backgroundColorAnimator = UIViewPropertyAnimator(duration: 0.3, dampingRatio: 1)
    let tooltipShowingAnimator = UIViewPropertyAnimator(duration: 0.3, dampingRatio: 0.8)
    let tooltipHidingAnimator = UIViewPropertyAnimator(duration: 0.3, dampingRatio: 0.8)
    
    lazy var tooltipBottonConstraint = tooltip.bottomAnchor.constraint(equalTo: self.topAnchor, constant: 0)
    lazy var tooltipCenterXConstraint = tooltip.centerXAnchor.constraint(equalTo: self.leadingAnchor, constant: 0)
    
    var tooltipAnchorPoint: CGPoint = .zero {
        didSet {
            updateTooltipPosition()
        }
    }
    
    var tooltip = PlaceInfoTooltip()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupStyle()
        setupHierarchy()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)
        if hitView == self {
            print("placeInfoView hitTest")
            return nil
        }
        return hitView
    }
    
}

extension PlaceInfoView {
    
    //MARK: - Layout Func
    
    private func setupLayout() {
        tooltipBottonConstraint.isActive = true
        tooltipCenterXConstraint.isActive = true
    }
    
    //MARK: - Priavet Func
    
    private func setupStyle() {
        backgroundColor = .blue.withAlphaComponent(0.1)
    }
    
    private func setupHierarchy() {
        addSubview(tooltip)
    }
    
    private func updateTooltipPosition() {
        tooltipBottonConstraint.constant = tooltipAnchorPoint.y
        tooltipCenterXConstraint.constant = tooltipAnchorPoint.x
    }
    
    //MARK: - Func
    
    func showToolTip() {
        tooltip.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        tooltip.alpha = 0
        tooltipHidingAnimator.stopAnimation(true)
        tooltipShowingAnimator.addAnimations { [weak self] in
            guard let self else { return }
            self.tooltip.transform = .identity
            self.tooltip.alpha = 1
            self.layoutIfNeeded()
        }
        tooltipShowingAnimator.startAnimation()
    }
    
    func hideTooltip() {
        tooltip.configure(with: nil)
        tooltipShowingAnimator.stopAnimation(true)
        tooltipHidingAnimator.addAnimations { [weak self] in
            guard let self else { return }
            self.tooltip.alpha = 0
            self.tooltip.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        }
        tooltipHidingAnimator.startAnimation()
    }
    
}
