//
//  ChoosingCharacterPopupView.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 7/17/24.
//

import UIKit

import SnapKit
import Then

final class ChoosingCharacterPopupView: UIView {
    
    //MARK: - Properties
    
    typealias NoButtonAction = () -> Void
    typealias YesButtonAction = () -> Void

    private var noButtonAction: NoButtonAction?
    private var yesButtonAction: YesButtonAction?

    //MARK: - UI Properties
    
    private let popupView = UIView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let noButton = UIButton()
    private let yesButton = UIButton()
    private let buttonStackView = UIStackView()
        
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

extension ChoosingCharacterPopupView {
    
    // MARK: - Layout
    
    private func setupStyle() {
        backgroundColor = .blackOpacity(.black55)
        
        popupView.do {
            $0.backgroundColor = .main(.main3)
            $0.roundCorners(cornerRadius: 15)
            $0.alpha = 0
        }
        
        titleLabel.do {
            $0.text = "오푸와 함께 하시겠어요?"
            $0.textAlignment = .center
            $0.textColor = .main(.main2)
            $0.font = .offroad(style: .iosTextTitle)
        }
        
        descriptionLabel.do {
            $0.text = "지금 캐릭터를 선택하시면\n오푸와 모험을 시작하게 돼요."
            $0.font = .offroad(style: .iosTextRegular)
            $0.highlightText(targetText: "오푸", font: .offroad(style: .iosTextBold))
            $0.numberOfLines = 2
            $0.textAlignment = .center
            $0.textColor = .sub(.sub4)
        }
        
        noButton.do {
            $0.setImage(UIImage(resource: .btnNo), for: .normal)
        }
        
        yesButton.do {
            $0.setImage(UIImage(resource: .btnYes), for: .normal)
        }
        
        buttonStackView.do {
            $0.axis = .horizontal
            $0.spacing = 12
        }
    }
    
    private func setupHierarchy() {
        addSubview(popupView)
        popupView.addSubviews(
            titleLabel,
            descriptionLabel,
            buttonStackView
        )
        buttonStackView.addArrangedSubviews(noButton, yesButton)
    }
    
    private func setupLayout() {
        popupView.snp.makeConstraints {
            $0.height.equalTo(204)
            $0.width.equalToSuperview().inset(24)
            $0.center.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(28)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
        }
        
        buttonStackView.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview().inset(46)
            $0.height.equalTo(48)
        }
    }
    
    //MARK: - @Objc
    
    @objc private func noButtonTapped() {
        noButtonAction?()
    }
    
    @objc private func yesButtonTapped() {
        yesButtonAction?()
    }
    
    //MARK: - Func
    
    func presentPopupView() {
        popupView.excutePresentPopupAnimation()
    }
    
    func dismissPopupView() {
        backgroundColor = .clear
        popupView.excuteDismissPopupAnimation()
    }
    
    func setCharacterName(name: String) {
        titleLabel.text = "\(name)와(과) 함께 하시겠어요?"
        
        descriptionLabel.text = "지금 캐릭터를 선택하시면\n\(name)와(과) 모험을 시작하게 돼요."
        descriptionLabel.font = .offroad(style: .iosTextRegular)
        descriptionLabel.highlightText(targetText: name, font: .offroad(style: .iosTextBold))
    }
    
    //MARK: - targetView Method
    
    func setupNoButton(action: @escaping NoButtonAction) {
        noButtonAction = action
        noButton.addTarget(self, action: #selector(noButtonTapped), for: .touchUpInside)
    }
    
    func setupYesButton(action: @escaping NoButtonAction) {
        yesButtonAction = action
        yesButton.addTarget(self, action: #selector(yesButtonTapped), for: .touchUpInside)
    }
}
