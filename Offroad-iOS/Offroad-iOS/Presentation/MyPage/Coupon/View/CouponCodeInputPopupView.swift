//
//  CouponDetailPopupView.swift
//  Offroad-iOS
//
//  Created by  정지원 on 9/3/24.
//

import UIKit

import SnapKit
import Then

final class CouponCodeInputPopupView: UIView {
    
    //MARK: - Properties
    
    typealias EnterCodeAction = () -> Void
    typealias CloseButtonAction = () -> Void
    
    var enterCodeAction: EnterCodeAction?
    var closeButtonAction: CloseButtonAction?
    
    var screenSize: CGSize { return UIScreen.current.bounds.size }
    lazy var popupViewBottomConstraint = popupView.bottomAnchor.constraint(
        equalTo: self.bottomAnchor,
        constant: 0
    )
    
    //MARK: - UI Properties
    
    let popupView = UIView()
    private let popupTitleLabel = UILabel()
    let closeButton = UIButton()
    private let popupDescriptionLabel = UILabel()
    let couponCodeTextField = UITextField()
    let okButton = StateToggleButton(state: .isDisabled, title: "확인")
    
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

extension CouponCodeInputPopupView {
    
    // MARK: - Private Func
    
    private func setupStyle() {
        backgroundColor = .clear
        
        popupView.do {
            $0.backgroundColor = UIColor.main(.main3)
            $0.roundCorners(cornerRadius: 15)
            $0.alpha = 0
        }
        
        popupTitleLabel.do {
            $0.text = "쿠폰 사용"
            $0.textColor = UIColor.main(.main2)
            $0.font = UIFont.offroad(style: .iosTextTitle)
            $0.textAlignment = .center
        }
        
        popupDescriptionLabel.do {
            $0.text = "코드를 입력 후 사장님에게 보여주세요."
            $0.font = UIFont.offroad(style: .iosTextRegular)
            $0.textColor = UIColor.main(.main2)
            $0.numberOfLines = 0
            $0.textAlignment = .center
        }
        
        couponCodeTextField.do {
            $0.layer.cornerRadius = 5
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.grayscale(.gray200).cgColor
            $0.backgroundColor = UIColor.main(.main3)
            $0.keyboardAppearance = .light
            $0.addPadding(left: 12, right: 12)
            
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
            popupTitleLabel,
            closeButton,
            popupDescriptionLabel,
            couponCodeTextField,
            okButton
        )
    }
    
    private func setupLayout() {
        popupView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.height.equalTo(240)
        }
        popupViewBottomConstraint.isActive = true
        
        popupTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(29)
            $0.horizontalEdges.equalToSuperview().inset(46)
        }
        
        popupDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(popupTitleLabel.snp.bottom).offset(18)
            $0.horizontalEdges.equalToSuperview().inset(46)
        }
        
        couponCodeTextField.snp.makeConstraints {
            $0.top.equalTo(popupDescriptionLabel.snp.bottom).offset(10)
            $0.horizontalEdges.equalToSuperview().inset(46)
            $0.height.equalTo(43)
        }
        
        closeButton.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(12)
            $0.size.equalTo(44)
        }
        
        okButton.snp.makeConstraints {
            $0.top.equalTo(couponCodeTextField.snp.bottom).offset(18)
            $0.horizontalEdges.equalToSuperview().inset(46)
            $0.height.equalTo(44)
        }
    }
}

