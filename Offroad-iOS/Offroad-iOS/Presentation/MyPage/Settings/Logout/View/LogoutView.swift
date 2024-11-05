//
//  LogoutView.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 9/3/24.
//

import UIKit

import SnapKit
import Then

final class LogoutView: UIView {

    //MARK: - UI Properties
    
    private let popupView = UIView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let labelStackView = UIStackView()
    let noButton = UIButton()
    let yesButton = UIButton()
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

extension LogoutView {
    
    // MARK: - Layout
    
    private func setupStyle() {
        backgroundColor = .blackOpacity(.black25)
        
        popupView.do {
            $0.backgroundColor = .main(.main3)
            $0.roundCorners(cornerRadius: 15)
            $0.alpha = 0
        }

        titleLabel.do {
            $0.text = "로그아웃"
            $0.font = .offroad(style: .iosTextTitle)
            $0.textColor = .main(.main2)
            $0.textAlignment = .center
        }

        descriptionLabel.do {
            $0.text = "정말 로그아웃 하시겠어요?"
            $0.font = .offroad(style: .iosText)
            $0.textColor = .main(.main2)
            $0.textAlignment = .center
        }
        
        labelStackView.do {
            $0.axis = .vertical
            $0.spacing = 12
            $0.alignment = .center
        }
        
        noButton.do {
            $0.setTitle("아니오", for: .normal)
            $0.setTitleColor(.main(.main2), for: .normal)
            $0.titleLabel?.font = .offroad(style: .iosBtnSmall)
            $0.backgroundColor = .clear
            $0.roundCorners(cornerRadius: 5)
            $0.layer.borderColor = UIColor.main(.main2).cgColor
            $0.layer.borderWidth = 1
        }

        yesButton.do {
            $0.setTitle("네", for: .normal)
            $0.setTitleColor(.primary(.white), for: .normal)
            $0.titleLabel?.font = .offroad(style: .iosBtnSmall)
            $0.backgroundColor = .main(.main2)
            $0.roundCorners(cornerRadius: 5)
        }

        buttonStackView.do {
            $0.axis = .horizontal
            $0.spacing = 14
            $0.distribution = .fillEqually
        }
    }
    
    private func setupHierarchy() {
        addSubview(popupView)
        popupView.addSubviews(labelStackView, buttonStackView)
        labelStackView.addArrangedSubviews(titleLabel, descriptionLabel)
        buttonStackView.addArrangedSubviews(noButton, yesButton)
    }
    
    private func setupLayout() {
        popupView.snp.makeConstraints {
            $0.height.equalTo(190)
            $0.width.equalToSuperview().inset(24)
            $0.center.equalToSuperview()
        }
        
        labelStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(28)
            $0.centerX.equalToSuperview()
        }
        
        buttonStackView.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(28)
            $0.horizontalEdges.equalToSuperview().inset(46)
            $0.height.equalTo(48)
        }
    }
    
    //MARK: - Func
    
    func presentPopupView() {
        popupView.executePresentPopupAnimation()
    }
    
    func dismissPopupView(completion: @escaping () -> Void) {
        backgroundColor = .clear
        popupView.executeDismissPopupAnimation { _ in
            completion()
        }
    }
}
