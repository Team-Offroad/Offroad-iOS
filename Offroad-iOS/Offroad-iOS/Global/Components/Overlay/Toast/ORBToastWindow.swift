//
//  ORBToastWindow.swift
//  Offroad-iOS
//
//  Created by 김민성 on 10/12/24.
//

import UIKit

final class ORBToastWindow: ORBOverlayWindow {
    
    //MARK: - Properties
    
    private let showAnimator = UIViewPropertyAnimator(duration: 0.3, dampingRatio: 1)
    let hideAnimator = UIViewPropertyAnimator(duration: 0.3, dampingRatio: 1)
    
    private lazy var toastViewTopConstraint = toastView.topAnchor.constraint(equalTo: self.topAnchor, constant: 100)
    private lazy var toastViewBottomConstraint = toastView.bottomAnchor.constraint(equalTo: self.topAnchor)
    
    //MARK: - UI Properties
    
    let toastView: UIView = UIView()
    let messageLabel: UILabel = UILabel()
    
    //MARK: Life Cycle
    
    override init(windowScene: UIWindowScene) {
        super.init(windowScene: windowScene)
        
        setupHierarchy()
        setupLayout()
        setupStyle()
        setupAnimator()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupHierarchy()
        setupLayout()
        setupStyle()
        setupAnimator()
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("ORBToastWindow가 메모리에서 해제됨.")
    }
    
}

extension ORBToastWindow {
    
    //MARK: - Layout Func
    
    private func setupLayout() {
        toastViewTopConstraint.isActive = false
        toastViewBottomConstraint.isActive = true
        toastView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(24)
        }
        
        messageLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(24)
            make.verticalEdges.equalToSuperview().inset(10.5)
        }
    }
    
    //MARK: - Private Func
    
    private func setupHierarchy() {
        addSubview(toastView)
        toastView.addSubview(messageLabel)
    }
    
    private func setupStyle() {
        windowLevel = UIWindow.Level.alert + 1
        backgroundColor = .blue.withAlphaComponent(0.3)
        
        toastView.backgroundColor = .orange
        
        messageLabel.do { label in
            label.font = .offroad(style: .iosTextAuto)
            label.textColor = .primary(.black)
            label.numberOfLines = 0
            label.text = "이것은 테스트 토스트 메시지입니다. 토스트테스트중"
        }
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
    
    func showToast() {
        makeKeyAndVisible()
        layoutIfNeeded()
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.showAnimator.startAnimation()
        }
    }
    
    func hideToast() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.hideAnimator.startAnimation()
        }
    }
    
}
