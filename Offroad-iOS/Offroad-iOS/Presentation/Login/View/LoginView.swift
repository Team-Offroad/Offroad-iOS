//
//  LoginView.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 7/8/24.
//

import UIKit

import SnapKit
import Then

final class LoginView: UIView {

    //MARK: - UI Properties
    
    private let offroadLogoImageView = UIImageView(image: UIImage(resource: .offroadLogoLoginImg))
    private let kakaoLoginButton = UIButton()
    private let appleLoginButton = UIButton()
    private let loginButtonStackView = UIStackView()
    
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

extension LoginView {
    
    // MARK: - Layout
    
    private func setupStyle() {
        backgroundColor = .white
        
        kakaoLoginButton.do {
            $0.setTitle("Kakao로 계속하기", for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.backgroundColor = .yellow
            $0.roundCorners(cornerRadius: 5)
        }
        
        appleLoginButton.do {
            $0.setTitle("Apple로 계속하기", for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.backgroundColor = .black
            $0.roundCorners(cornerRadius: 5)
        }
        
        loginButtonStackView.do {
            $0.axis = .vertical
            $0.spacing = 14
        }
    }
    
    private func setupHierarchy() {
        addSubviews(offroadLogoImageView, loginButtonStackView)
        loginButtonStackView.addArrangedSubviews(kakaoLoginButton, appleLoginButton)
    }
    
    private func setupLayout() {
        offroadLogoImageView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).inset(233)
            $0.centerX.equalToSuperview()
        }
        
        kakaoLoginButton.snp.makeConstraints {
            $0.height.equalTo(54)
        }
        
        appleLoginButton.snp.makeConstraints {
            $0.height.equalTo(54)
        }
        
        loginButtonStackView.snp.makeConstraints{
            $0.top.equalTo(offroadLogoImageView.snp.bottom).offset(42.37)
            $0.horizontalEdges.equalToSuperview().inset(24)
        }
    }
}
