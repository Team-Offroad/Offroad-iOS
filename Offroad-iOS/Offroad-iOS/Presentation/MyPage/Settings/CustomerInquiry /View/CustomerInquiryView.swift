//
//  CustomerInquiryView.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 11/27/24.
//

import UIKit

import SnapKit
import Then

final class CustomerInquiryView: UIView {
    
    //MARK: - UI Properties
    
    let customBackButton = NavigationPopButton()
    private let borderView = UIView()
    private let titleLabel = UILabel()
    private let titleImageView = UIImageView(frame: CGRect(origin: .init(), size: CGSize(width: 24, height: 24)))
    private let mainLabel = UILabel()
    private let subLabel = UILabel()
    private let labelStackView = UIStackView()
    private let emailButton = UIButton()
    
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

extension CustomerInquiryView {
    
    // MARK: - Layout
    
    private func setupStyle() {
        backgroundColor = .main(.main1)
        
        customBackButton.do {
            $0.configureButtonTitle(titleString: "설정")
        }
        
        borderView.do {
            $0.backgroundColor = .grayscale(.gray100)
        }
        
        titleImageView.do {
            $0.image = .imgChat
        }
        
        titleLabel.do {
            $0.text = "고객 문의"
            $0.font = .offroad(style: .iosTextTitle)
            $0.textColor = .main(.main2)
            $0.textAlignment = .center
        }
        
        mainLabel.do {
            $0.text = "오브를 플레이하시면서 불편한 점이나 궁금한 점이\n있으시다면, 아래 연락처로 편하게 문의주세요."
            $0.font = .offroad(style: .iosTextBold)
            $0.numberOfLines = 0
            $0.textColor = .main(.main2)
            $0.textAlignment = .left
            $0.setLineHeight(percentage: 150)
        }
        
        subLabel.do {
            $0.text = "확인 후 이메일로 답변드리겠습니다."
            $0.font = .offroad(style: .iosTextAuto)
            $0.numberOfLines = 0
            $0.textColor = .grayscale(.gray400)
            $0.textAlignment = .left
        }
        
        labelStackView.do {
            $0.axis = .vertical
            $0.spacing = 12
            $0.alignment = .leading
        }
        
        emailButton.do {
            $0.setTitle("contact.track1@gmail.com", for: .normal)
            $0.setTitleColor(.main(.main2), for: .normal)
            $0.titleLabel?.font = .offroad(style: .iosText)
            $0.roundCorners(cornerRadius: 5)
            $0.backgroundColor = .neutral(.nametagInactive)
        }
    }
    
    private func setupHierarchy() {
        addSubviews(
            customBackButton,
            titleLabel,
            titleImageView,
            borderView,
            labelStackView,
            emailButton
        )
        labelStackView.addArrangedSubviews(mainLabel, subLabel)
    }
    
    private func setupLayout() {
        customBackButton.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).inset(12)
            $0.leading.equalToSuperview().inset(12)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).inset(98)
            $0.leading.equalToSuperview().inset(24)
        }
        
        titleImageView.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel.snp.centerY)
            $0.leading.equalTo(titleLabel.snp.trailing).offset(8)
        }
        
        borderView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        labelStackView.snp.makeConstraints {
            $0.top.equalTo(borderView.snp.bottom).offset(41)
            $0.leading.equalToSuperview().inset(24)
        }
        
        emailButton.snp.makeConstraints {
            $0.top.equalTo(labelStackView.snp.bottom).offset(28)
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.height.equalTo(54)
        }
    }
}
