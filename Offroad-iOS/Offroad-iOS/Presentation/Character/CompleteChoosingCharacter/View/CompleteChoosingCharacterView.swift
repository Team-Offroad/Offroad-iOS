//
//  CompleteChoosingCharacterView.swift
//  Offroad-iOS
//
//  Created by  정지원 on 7/15/24.
//

import UIKit

import Kingfisher
import SnapKit
import Then

final class CompleteChoosingCharacterView: UIView {
    
    //MARK: - Properties
    
    private let mainLabel = UILabel()
    private let backgroundView = UIImageView(image: UIImage(resource: .imgCompleteChoosingBackground))
    private let characterView = UIImageView()
    
    let startButton = StateToggleButton(state: .isEnabled, title: "모험 시작하기")
    
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

extension CompleteChoosingCharacterView {
    
    // MARK: - Private Func
    
    private func setupHierarchy() {
        addSubviews(
            backgroundView,
            characterView,
            mainLabel,
            startButton
        )
    }
    
    private func setupStyle() {
        mainLabel.do {
            $0.text = "프로필 생성을 축하드려요!\n지금 바로 모험을 떠나볼까요?"
            $0.setLineSpacing(spacing: 4.0)
            $0.textAlignment = .center
            $0.numberOfLines = 2
            $0.textColor = .main(.main1)
            $0.font = UIFont.offroad(style: .iosTextTitle)
        }
        
        characterView.do {
            $0.contentMode = .scaleAspectFit
        }
    }
    
    private func setupLayout() {
        mainLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(120)
            make.centerX.equalToSuperview()
        }
        
        backgroundView.snp.makeConstraints { make in
            make.edges.horizontalEdges.equalToSuperview()
        }
        
        characterView.snp.makeConstraints { make in
            make.top.equalTo(mainLabel.snp.bottom).offset(100)
            make.bottom.equalTo(startButton.snp.top).offset(-200)
            make.horizontalEdges.equalToSuperview().inset(79)
        }
        
        startButton.snp.makeConstraints{ make in
            make.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide).inset(24)
            make.height.equalTo(54)
        }
    }
    
    //MARK: - Func
    
    func setCharacterImage(imageURL: String) {
        characterView.fetchSvgURLToImageView(svgUrlString: imageURL)
    }
}

