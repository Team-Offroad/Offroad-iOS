//
//  DiaryView.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 3/4/25.
//

import UIKit

import SnapKit
import Then

final class DiaryView: UIView {
    
    //MARK: - UI Properties
    
    let customBackButton = NavigationPopButton()
    private let headerView = UIView()
    private let dividerView = UIView()
    private let titleLabel = UILabel()
    private let titleImageView = UIImageView(frame: CGRect(origin: .init(), size: CGSize(width: 24, height: 24)))
    let guideButton = UIButton()
    
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

extension DiaryView {
    
    // MARK: - Layout
    
    private func setupStyle() {
        backgroundColor = .primary(.listBg)
        
        headerView.do {
            $0.backgroundColor = .main(.main1)
        }
        
        dividerView.do {
            $0.backgroundColor = .grayscale(.gray100)
        }
        
        titleImageView.do {
            $0.image = .imgSparkle
        }
        
        titleLabel.do {
            $0.text = "기억빛"
            $0.font = .offroad(style: .iosTextTitle)
            $0.textColor = .main(.main2)
            $0.textAlignment = .center
        }
        
        guideButton.do {
            $0.setImage(.iconGuide, for: .normal)
        }
    }
    
    private func setupHierarchy() {
        addSubviews(
            headerView,
            customBackButton,
            titleLabel,
            titleImageView,
            guideButton,
            dividerView
        )
    }
    
    private func setupLayout() {
        headerView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(dividerView.snp.top)
        }
        
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
        
        guideButton.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel.snp.centerY)
            $0.leading.equalTo(titleImageView.snp.trailing).offset(4)
        }
        
        dividerView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
}
