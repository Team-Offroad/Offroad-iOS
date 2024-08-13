//
//  CollectedTitleCollectionViewCell.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 8/5/24.
//

import UIKit

import SnapKit
import Then

final class CollectedTitleCollectionViewCell: UICollectionViewCell {
    
    //MARK: - UI Properties
    
    private let titleLabel = UILabel()
    private let collectConditionLabel = UILabel()
    private let labelStackView = UIStackView()
    private let lockedView = UIView()
    private let lockImageView = UIImageView(image: UIImage(resource: .iconLock))
    
    //MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupHierarchy()
        setupStyle()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}

extension CollectedTitleCollectionViewCell {
    
    // MARK: - Layout
    
    private func setupStyle() {
        backgroundColor = .main(.main3)
        roundCorners(cornerRadius: 5)
        
        titleLabel.do {
            $0.font = .offroad(style: .iosTextBold)
            $0.textColor = .sub(.sub4)
            $0.textAlignment = .center
        }
        
        collectConditionLabel.do {
            $0.font = .offroad(style: .iosHint)
            $0.textColor = .grayscale(.gray400)
        }
        
        labelStackView.do {
            $0.axis = .vertical
            $0.spacing = 6
            $0.alignment = .leading
        }
        
        lockedView.do {
            $0.backgroundColor = .blackOpacity(.black25)
        }
    }
    
    private func setupHierarchy() {
        addSubviews(labelStackView, lockedView)
        labelStackView.addArrangedSubviews(titleLabel, collectConditionLabel)
        lockedView.addSubview(lockImageView)
    }
    
    private func setupLayout() {
        labelStackView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(18)
            $0.centerY.equalToSuperview()
        }
        
        lockedView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        lockImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    //MARK: - Func
    
    func configureCell(data: CollectedTitleModel) {
        titleLabel.text = data.titleString
        collectConditionLabel.text = "\(data.collectConditionString) 달성 시 획득"
        collectConditionLabel.highlightText(targetText: data.collectConditionString, font: .offroad(style: .iosTextContents))
        lockedView.isHidden = data.isCollected ? false : true
    }
}
