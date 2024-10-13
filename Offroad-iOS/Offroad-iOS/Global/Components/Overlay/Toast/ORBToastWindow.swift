//
//  ORBToastWindow.swift
//  Offroad-iOS
//
//  Created by 김민성 on 10/12/24.
//

import UIKit

final class ORBToastWindow: UIWindow {
    
    //MARK: - Properties
    
    private let showAnimator = UIViewPropertyAnimator(duration: 0.4, dampingRatio: 1)
    let hideAnimator = UIViewPropertyAnimator(duration: 0.4, dampingRatio: 1)
    private var inset: CGFloat
    
    private lazy var toastViewTopConstraint = toastView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: inset)
    private lazy var toastViewBottomConstraint = toastView.bottomAnchor.constraint(equalTo: self.topAnchor)
    
    //MARK: - UI Properties
    
    let toastView: UIView = UIView()
    let imageView: UIImageView = .init(image: .btnChecked)
    let messageLabel: UILabel = UILabel()
    
    //MARK: Life Cycle
    
    init(message: String, inset: CGFloat) {
        self.inset = inset
        self.messageLabel.text = message != "" ? message : "빈 토스트 메시지"
        super.init(windowScene: UIWindowScene.current)
        
        setupHierarchy()
        setupLayout()
        setupStyle()
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
        
        imageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(21)
            make.size.equalTo(22)
        }
        
        messageLabel.snp.makeConstraints { make in
            make.leading.equalTo(imageView.snp.trailing).offset(11)
            make.trailing.equalToSuperview().inset(20)
            make.verticalEdges.equalToSuperview().inset(10.5)
        }
    }
    
    //MARK: - Private Func
    
    private func setupHierarchy() {
        addSubview(toastView)
        toastView.addSubviews(imageView, messageLabel)
    }
    
    private func setupStyle() {
        windowLevel = UIWindow.Level.alert + 1
        
        toastView.do({ view in
            view.backgroundColor = .blackOpacity(.black55)
            view.roundCorners(cornerRadius: 10)
        })
        
        imageView.do { imageView in
            imageView.contentMode = .scaleAspectFit
        }
        
        messageLabel.do { label in
            label.font = .offroad(style: .iosTextAuto)
            label.textColor = .primary(.white)
            label.numberOfLines = 0
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
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        return nil
    }
    
    func showToast() {
        makeKeyAndVisible()
        layoutIfNeeded()
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.showAnimator.startAnimation()
        }
    }
    
    func hideToast() {
        showAnimator.stopAnimation(true)
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.hideAnimator.startAnimation()
        }
    }
    
}
