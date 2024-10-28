//
//  PlaceInfoView.swift
//  Offroad-iOS
//
//  Created by 김민성 on 10/27/24.
//

import UIKit

class PlaceInfoView: UIView {
    
    let contentView = UIView()
    let contentFrame: CGRect
    
    let backgroundColorAnimator = UIViewPropertyAnimator(duration: 0.4, dampingRatio: 1)
    let tooltipShowingAnimator = UIViewPropertyAnimator(duration: 0.4, dampingRatio: 0.8)
    let tooltipHidingAnimator = UIViewPropertyAnimator(duration: 0.4, dampingRatio: 1)
    
    // tooltip의 centerYAnchor인 이유는 tooltip.layer.anchorPoint가 (0.5, 1)이기 때문
    lazy var tooltipCenterYConstraint = tooltip.centerYAnchor.constraint(equalTo: self.topAnchor, constant: 0)
    lazy var tooltipCenterXConstraint = tooltip.centerXAnchor.constraint(equalTo: self.leadingAnchor, constant: 0)
    
    var tooltipAnchorPoint: CGPoint = .zero {
        didSet {
            updateTooltipPosition()
        }
    }
    
    var tooltip = PlaceInfoTooltip()
    
    init(contentFrame: CGRect) {
        self.contentFrame = contentFrame
        super.init(frame: .zero)
        
        setupStyle()
        setupHierarchy()
        setupLayout()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)
        if hitView == contentView {
            return nil
        }
        return hitView
    }
    
}

extension PlaceInfoView {
    
    //MARK: - Layout Func
    
    private func setupLayout() {
        contentView.frame = contentFrame
        tooltipCenterYConstraint.isActive = true
        tooltipCenterXConstraint.isActive = true
    }
    
    //MARK: - Priavet Func
    
    private func setupStyle() {
        contentView.backgroundColor = .blue.withAlphaComponent(0.1)
        contentView.clipsToBounds = true
    }
    
    private func setupHierarchy() {
        addSubviews(contentView)
        contentView.addSubview(tooltip)
    }
    
    private func updateTooltipPosition() {
        tooltipCenterYConstraint.constant = tooltipAnchorPoint.y// + tooltip.bounds.height * 0.5
        tooltipCenterXConstraint.constant = tooltipAnchorPoint.x
        layoutIfNeeded()
    }
    
    //MARK: - Func
    
    func showToolTip() {
        tooltip.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        tooltip.alpha = 0
        layoutIfNeeded()
        
        backgroundColorAnimator.addAnimations { [weak self] in
            guard let self else { return }
            self.backgroundColor = .blackOpacity(.black25)
        }
        tooltipHidingAnimator.stopAnimation(true)
        tooltipShowingAnimator.addAnimations { [weak self] in
            guard let self else { return }
            self.tooltip.transform = .identity
            self.tooltip.alpha = 1
            self.layoutIfNeeded()
        }
        tooltipShowingAnimator.addCompletion { [weak self] _ in
            guard let self else { return }
            print("tooltip's frame:", self.tooltip.frame)
        }
        backgroundColorAnimator.startAnimation()
        tooltipShowingAnimator.startAnimation()
    }
    
    func hideTooltip(completion: @escaping () -> Void) {
        backgroundColorAnimator.addAnimations { [weak self] in
            guard let self else { return }
            self.backgroundColor = .clear
        }
        tooltipShowingAnimator.stopAnimation(true)
        tooltipHidingAnimator.addAnimations { [weak self] in
            guard let self else { return }
            self.tooltip.alpha = 0
            self.tooltip.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        }
        tooltipHidingAnimator.addCompletion { [weak self] _ in
            guard let self else { return }
            self.tooltip.configure(with: nil)
            completion()
        }
        backgroundColorAnimator.startAnimation()
        tooltipHidingAnimator.startAnimation()
    }
    
}
