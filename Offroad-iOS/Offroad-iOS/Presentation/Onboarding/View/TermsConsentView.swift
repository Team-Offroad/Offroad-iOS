//
//  TermsConsentView.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 8/23/24.
//

import UIKit

import SnapKit
import Then

final class TermsConsentView: UIView {

    //MARK: - UI Properties
    
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let labelStackView = UIStackView()
    private let agreeAllView = UIView()
    let agreeAllButton = UIButton()
    private let agreeAllLabel = UILabel()
    private let agreeAllStackView = UIStackView()
    let termsListTableView = UITableView()
    let nextButton = StateToggleButton(state: .isDisabled, title: "다음")
        
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

extension TermsConsentView {
    
    // MARK: - Layout
    
    private func setupStyle() {
        backgroundColor = .main(.main1)
        
        titleLabel.do {
            $0.text = "약관 동의"
            $0.textColor = .main(.main2)
            $0.font = .offroad(style: .iosTextTitle)
            $0.textAlignment = .center
        }
        
        descriptionLabel.do {
            $0.text = "필수항목 및 선택항목 약관에 동의해 주세요."
            $0.textColor = .main(.main2)
            $0.font = .offroad(style: .iosTextAuto)
            $0.textAlignment = .center
        }
        
        labelStackView.do {
            $0.axis = .vertical
            $0.spacing = 12
            $0.alignment = .leading
        }
        
        agreeAllView.do {
            $0.backgroundColor = .neutral(.nametagInactive)
            $0.roundCorners(cornerRadius: 5)
        }
        
        agreeAllLabel.do {
            $0.text = "전체동의"
            $0.textColor = .main(.main2)
            $0.font = .offroad(style: .iosTextBold)
            $0.textAlignment = .center
        }
        
        agreeAllButton.do {
            $0.adjustsImageWhenHighlighted = false
            $0.setImage(.btnUnchecked, for: .normal)
            $0.setImage(.btnChecked, for: .selected)
        }
        
        agreeAllStackView.do {
            $0.axis = .horizontal
            $0.spacing = 8
            $0.alignment = .center
        }
        
        termsListTableView.do {
            $0.backgroundColor = .clear
            $0.separatorStyle = .none
            $0.isScrollEnabled = false
            
            $0.register(TermsListTableViewCell.self, forCellReuseIdentifier: TermsListTableViewCell.className)
        }
    }
    
    private func setupHierarchy() {
        addSubviews(
            labelStackView,
            agreeAllView,
            termsListTableView,
            nextButton
        )
        labelStackView.addArrangedSubviews(titleLabel, descriptionLabel)
        agreeAllView.addSubview(agreeAllStackView)
        agreeAllStackView.addArrangedSubviews(agreeAllButton, agreeAllLabel)
    }
    
    private func setupLayout() {
        labelStackView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).inset(82)
            $0.leading.equalToSuperview().inset(24)
        }
        
        agreeAllView.snp.makeConstraints {
            $0.top.equalTo(labelStackView.snp.bottom).offset(49)
            $0.horizontalEdges.equalToSuperview().inset(34)
            $0.height.equalTo(54)
        }
        
        agreeAllStackView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(10)
            $0.centerY.equalToSuperview()
        }
        
        termsListTableView.snp.makeConstraints {
            $0.top.equalTo(agreeAllView.snp.bottom).offset(17)
            $0.leading.equalToSuperview().inset(44)
            $0.trailing.equalToSuperview().inset(47)
            $0.height.equalTo(176)
        }
        
        nextButton.snp.makeConstraints {
            $0.bottom.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(24)
            $0.height.equalTo(54)
        }
    }
}
