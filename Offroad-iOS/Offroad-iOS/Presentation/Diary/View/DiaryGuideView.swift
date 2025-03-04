//
//  DiaryGuideView.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 3/4/25.
//

import UIKit

import SnapKit
import Then

final class DiaryGuideView: UIView {
    
    //MARK: - UI Properties
    
    let closeButton = UIButton()
    let nextButton = ShrinkableButton()
    
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

extension DiaryGuideView {
    
    // MARK: - Layout
    
    private func setupStyle() {
        backgroundColor = .blackOpacity(.black75)
        
        closeButton.do {
            $0.setImage(.iconCloseWhite, for: .normal)
        }
        
        nextButton.do {
            $0.setTitle("다음", for: .normal)
            $0.setTitleColor(.main(.main1), for: .normal)
            $0.titleLabel?.font = .offroad(style: .iosText)
            $0.titleLabel?.setLineHeight(percentage: 150)
            $0.backgroundColor = .sub(.sub)
            $0.roundCorners(cornerRadius: 5)
        }
    }
    
    private func setupHierarchy() {
        addSubviews(
            closeButton,
            nextButton
        )
    }
    
    private func setupLayout() {
        closeButton.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).inset(4)
            $0.trailing.equalToSuperview().inset(14)
            $0.size.equalTo(44)
        }
        
        nextButton.snp.makeConstraints {
            $0.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide).inset(24)
            $0.height.equalTo(54)
        }
    }
}
