//
//  ORBToastBackgroundView.swift
//  Offroad-iOS
//
//  Created by 김민성 on 10/7/24.
//

import UIKit

class ORBToastBackgroundView: UIView {
    
    //MARK: - Properties
    
    let showAnimator = UIViewPropertyAnimator(duration: 0.3, dampingRatio: 1)
    let hideAnimator = UIViewPropertyAnimator(duration: 0.3, dampingRatio: 1)
    
    //MARK: - UI Properties
    
    let toastMessageLabel = UILabel()
    let toastView = UIView()
    
    lazy var toastMessageLabelBottomConstraint = toastMessageLabel.bottomAnchor.constraint(equalTo: topAnchor)
    lazy var toastMessageLabelTopConstraint = toastMessageLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 66)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupStyle()
        setupHierarchy()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ORBToastBackgroundView {
    
    //MARK: - Layout Func
    
    private func setupLayout() {
        toastMessageLabelTopConstraint.isActive = false
        toastMessageLabelBottomConstraint.isActive = true
        toastMessageLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(24)
            make.verticalEdges.equalToSuperview().inset(10.5)
        }
    }
    
    //MARK: - Private Func
    
    private func setupStyle() {
        toastMessageLabel.do { label in
            label.font = .offroad(style: .iosTextAuto)
            label.textColor = .primary(.white)
            label.numberOfLines = 0
            label.text = "이것은 테스트 토스트 메시지입니다. 토스트테스트중"
        }
        
        showAnimator.addAnimations { [weak self] in
            guard let self else { return }
            self.toastMessageLabelTopConstraint.isActive = true
            self.toastMessageLabelBottomConstraint.isActive = false
            self.layoutIfNeeded()
        }
        
        hideAnimator.addAnimations { [weak self] in
            guard let self else { return }
            self.toastMessageLabelTopConstraint.isActive = false
            self.toastMessageLabelBottomConstraint.isActive = true
            self.layoutIfNeeded()
        }
    }
    
    private func setupHierarchy() {
        addSubview(toastView)
        toastView.addSubview(toastMessageLabel)
    }
    
    private func showToast() {
        hideAnimator.stopAnimation(true)
        showAnimator.startAnimation()
    }
    
    private func hideToast() {
        showAnimator.stopAnimation(true)
        hideAnimator.startAnimation()
    }
    
    
}
