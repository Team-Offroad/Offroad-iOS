//
//  ORBToastWindow.swift
//  Offroad-iOS
//
//  Created by 김민성 on 10/12/24.
//

import UIKit

class ORBToastWindow: UIWindow {
    
    //MARK: - Properties
    
    private let showAnimator = UIViewPropertyAnimator(duration: 0.5, dampingRatio: 1)
    let hideAnimator = UIViewPropertyAnimator(duration: 0.5, dampingRatio: 1)
    private var inset: CGFloat
    
    lazy var toastViewTopConstraint = toastView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: inset)
    lazy var toastViewBottomConstraint = toastView.bottomAnchor.constraint(equalTo: self.topAnchor)
    
    //MARK: - UI Properties
    
    let toastView: ORBToastView
    
    //MARK: Life Cycle
    
    init(message: String, inset: CGFloat, withImage image: UIImage? = nil) {
        self.inset = inset
        self.toastView = ORBToastView(message: message, withImage: image)
        super.init(windowScene: UIWindowScene.current)
        
        setupHierarchy()
        setupLayout()
        setupAnimator()
    }
    
    init(toastView: ORBToastView, inset: CGFloat) {
        self.toastView = toastView
        self.inset = inset
        super.init(windowScene: UIWindowScene.current)
        
        setupHierarchy()
        setupLayout()
        setupAnimator()
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ORBToastWindow {
    
    //MARK: - Layout Func
    
    private func setupLayout() {
        toastViewTopConstraint.priority = .defaultHigh
        toastViewBottomConstraint.priority = .defaultHigh
        
        toastViewTopConstraint.isActive = false
        toastViewBottomConstraint.isActive = true
        toastView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(24)
        }
    }
    
    //MARK: - Private Func
    
    private func setupHierarchy() {
        windowLevel = UIWindow.Level.alert + 2
        addSubview(toastView)
    }
    
    private func setupAnimator() {
        showAnimator.addAnimations { [weak self] in
            guard let self else { return }
            self.toastViewTopConstraint.isActive = true
            self.toastViewBottomConstraint.isActive = false
            self.layoutIfNeeded()
        }
        
        showAnimator.addCompletion { [weak self] _ in
            guard let self else { return }
            DispatchQueue.main.asyncAfter(deadline: .now()+2) { [weak self] in
                guard let self else { return }
                hideAnimator.startAnimation()
            }
            
        }
        
        hideAnimator.addAnimations { [weak self] in
            guard let self else { return }
            self.toastViewTopConstraint.isActive = false
            self.toastViewBottomConstraint.isActive = true
            self.layoutIfNeeded()
        }
    }
    
    //MARK: - Func
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        return nil
    }
    
    func showToast() {
        layoutIfNeeded()
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.showAnimator.startAnimation()
        }
    }
    
    func hideToast() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.showAnimator.stopAnimation(true)
            self.hideAnimator.startAnimation()
        }
    }
    
}
