//
//  ORBAlertBaseView.swift
//  Offroad-iOS
//
//  Created by 김민성 on 9/12/24.
//

import UIKit

import SnapKit

internal class ORBAlertBackgroundView: UIView {
    
    //MARK: - Properties
    
    var keyboardRect: CGRect? = nil
    
    lazy var alertViewCenterYCosntraint = alertView.centerYAnchor.constraint(lessThanOrEqualTo: self.centerYAnchor)
    lazy var alertViewBottomConstraint = alertView.bottomAnchor.constraint(lessThanOrEqualTo: self.bottomAnchor)
    
    //MARK: - UI Properties
    
    let alertView: ORBAlertBaseView
    
    //MARK: - Life Cycle
    
    init(type: ORBAlertType) {
        switch type {
        case .normal:
            self.alertView = ORBAlertViewNormal()
        case .textField:
            self.alertView = ORBAlertViewTextField()
        case .textFieldWithSubMessage:
            self.alertView = ORBAlertViewTextFieldWithSubMessage()
        case .scrollableContent:
            self.alertView = ORBAlertViewScrollableContent()
        case .explorationResult:
            self.alertView = ORBAlertViewExplorationResult()
        case .acquiredEmblem:
            self.alertView = ORBAlertViewAcquiredEmblem()
        case .custom:
            self.alertView = ORBAlertViewNormal()
        }
        
        super.init(frame: .zero)
        
        setupStyle()
        setupHierarchy()
        setupLayout()
        layoutIfNeeded()
        setupNotification()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ORBAlertBackgroundView {
    
    //MARK: - Layout
    
    private func setupLayout() {
        alertView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(22.5)
            make.height.greaterThanOrEqualTo(238)
        }
        alertViewCenterYCosntraint.isActive = true
    }
    
    //MARK: - @objc Func
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRect = keyboardFrame.cgRectValue
            self.keyboardRect = keyboardRect
        }
    }
    
    //MARK: - Private Func
    
    private func setupStyle() {
        // 배경색의 초깃값 - 투명하게
        // 애니메이션 효과로 UIColor.blackOpacity(.black55) 색으로 변경
        backgroundColor = .clear
    }
    
    private func setupHierarchy() {
        addSubview(alertView)
    }
    
    private func setupNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
    }
    
    //MARK: - Func
    
    func setupLayout(of type: ORBAlertType, keyboardRect: CGRect? = nil) {
        alertViewCenterYCosntraint.isActive = true
        alertViewBottomConstraint.constant = keyboardRect == nil ? 0 : -(keyboardRect!.height + 24)
        alertViewBottomConstraint.isActive = true
    }
    
}
