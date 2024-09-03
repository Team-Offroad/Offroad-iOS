//
//  CouponDetailPopupView.swift
//  Offroad-iOS
//
//  Created by  정지원 on 9/3/24.
//

import UIKit

import SnapKit
import Then

final class CouponUsagePopupView: UIView {
    
    //MARK: - Properties
    
    typealias EnterCodeAction = () -> Void
    typealias CloseButtonAction = () -> Void
    
    private var enterCodeAction: EnterCodeAction?
    private var closeButtonAction: CloseButtonAction?
    
    //MARK: - UI Properties
    
    private let popupView = UIView()
    private let usageTitleLabel = UILabel()
    private let closeButton = UIButton()
    private let usageDescriptionLabel = UILabel()
    private let codeTextField = UITextField()
    private let checkButton = StateToggleButton(state: .isDisabled, title: "확인")
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupHierarchy()
        setupStyle()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CouponUsagePopupView {
    
    // MARK: - Layout
    
    private func setupStyle() {
        backgroundColor = .blackOpacity(.black55)
        
        popupView.do {
            $0.backgroundColor = UIColor.main(.main3)
            $0.roundCorners(cornerRadius: 15)
            $0.alpha = 0
        }
        
        usageTitleLabel.do {
            $0.text = "쿠폰 사용"
            $0.textColor = UIColor.main(.main2)
            $0.font = UIFont.offroad(style: .iosTextTitle)
        }
        
        usageDescriptionLabel.do {
            $0.text = "코드를 입력 후 사장님에게 보여주세요."
            $0.font = UIFont.offroad(style: .iosTextRegular)
            $0.textColor = UIColor.gray
        }
        
        codeTextField.do {
            $0.layer.cornerRadius = 5
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.grayscale(.gray200).cgColor
            $0.backgroundColor = UIColor.main(.main3)
            
            let placeholderText = "매장의 고유 코드를 입력해 주세요."
            let attributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor.grayscale(.gray300),
                .font: UIFont.offroad(style: .iosHint)
            ]
            
            $0.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: attributes)
        }
        
        closeButton.do {
            $0.setImage(UIImage(resource: .iconClose), for: .normal)
        }
        
    }
    
    private func setupHierarchy() {
        addSubview(popupView)
        popupView.addSubviews(
            usageTitleLabel,
            closeButton,
            usageDescriptionLabel,
            codeTextField,
            checkButton
        )
    }
    
    private func setupLayout() {
        popupView.snp.makeConstraints {
            $0.height.equalTo(240)
            $0.width.equalTo(345)
            $0.center.equalToSuperview()
        }
        
        usageTitleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(29)
        }
        
        usageDescriptionLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(usageTitleLabel.snp.bottom).inset(18)
        }
        
        codeTextField.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(usageDescriptionLabel.snp.bottom).inset(10)
            $0.width.equalTo(usageDescriptionLabel)
        }
        
        closeButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(13)
            $0.trailing.equalToSuperview().inset(12)
            $0.height.width.equalTo(44)
        }
        
        checkButton.snp.makeConstraints {
            $0.top.equalTo(codeTextField.snp.bottom).inset(18)
            $0.height.equalTo(44)
            $0.width.equalTo(usageDescriptionLabel)
        }
    }
    
    private func setupActions() {
        codeTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
    }
    
    func presentPopupView() {
        popupView.executePresentPopupAnimation()
    }
    
    func dismissPopupView() {
        backgroundColor = .clear
        popupView.executeDismissPopupAnimation()
    }
    
    // MARK: - @Objc
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        if let text = textField.text, !text.isEmpty {
            checkButton.isEnabled = true
            checkButton.changeState(forState: .isEnabled)
        } else {
            checkButton.isEnabled = false
            checkButton.changeState(forState: .isDisabled)
        }
    }
    
    @objc private func closeButtonTapped() {
        closeButtonAction?()
        dismissPopupView()
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4){
//            self.dismiss(animated: false)
//        }
    }
}

