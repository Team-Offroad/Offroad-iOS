//
//  OFRAlertBaseView.swift
//  Offroad-iOS
//
//  Created by 김민성 on 9/12/24.
//

import UIKit

import SnapKit

internal class OFRAlertBackgroundView: UIView {
    
    //MARK: - Properties
    
    var keyboardRect: CGRect? = nil
    
    lazy var alertViewCenterYCosntraint = alertView.centerYAnchor.constraint(lessThanOrEqualTo: self.centerYAnchor)
    lazy var alertViewBottomConstraint = alertView.bottomAnchor.constraint(lessThanOrEqualTo: self.bottomAnchor)
    
    //MARK: - UI Properties
    
    let alertView = OFRAlertView()
    
    //MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupStyle()
        setupHierarchy()
        setupDefaultLayout()
        layoutIfNeeded()
        setupNotification()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension OFRAlertBackgroundView {
    
    //MARK: - Layout
    
    private func setupDefaultLayout() {
        alertView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(24)
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
    
    func setupLayout(of type: OFRAlertViewType, keyboardRect: CGRect? = nil) {
        alertViewCenterYCosntraint.isActive = true
        alertViewBottomConstraint.constant = keyboardRect == nil ? 0 : -(keyboardRect!.height + 24)
        alertViewBottomConstraint.isActive = true
    }
    
}