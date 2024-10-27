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
    
    var isTooptipShown: Bool = false
    var tooltipAnchorPoint: CGPoint = .zero {
        didSet {
            layoutIfNeeded()
        }
    }
    
    var tooltip = PlaceInfoTooptip()
    
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
        super.hitTest(point, with: event)
        
        if !isTooptipShown {
            return nil
        }
        
        return self
    }
    
}

extension PlaceInfoView {
    
    //MARK: - Layout Func
    
    private func setupLayout() {
        tooltip.snp.makeConstraints { make in
            make.bottom.equalTo(self.snp.top).offset(tooltipAnchorPoint.y)
            make.centerX.equalTo(self.snp.leading).offset(tooltipAnchorPoint.x)
        }
    }
    
    //MARK: - Priavet Func
    
    private func setupStyle() {
        
    }
    
    private func setupHierarchy() {
        addSubview(tooltip)
    }
    
    //MARK: - Func
    
    func showToolTip(placeInfo: RegisteredPlaceInfo) {
        tooltip.configure(with: placeInfo)
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
