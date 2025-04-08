//
//  DeveloperModeNormalCell.swift
//  ORB_Dev
//
//  Created by 김민성 on 4/5/25.
//

import UIKit

import RxSwift
import RxCocoa

final class DeveloperModeNormalCell: ShrinkableCollectionViewCell {
    
    //MARK: - Properties
    
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                feedbackGenerator.prepare()
                contentView.backgroundColor = .primary(.listBg)
            } else {
                contentView.backgroundColor = .main(.main1)
            }
        }
    }
    
    private let feedbackGenerator = UIImpactFeedbackGenerator()
    
    //MARK: - UI Properties
    
    private let titleLabel = UILabel()
    private let valueLabel = UILabel()
    
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
    
}

private extension DeveloperModeNormalCell {
    
    private func setupStyle() {
        backgroundColor = .main(.main1)
        roundCorners(cornerRadius: 12)
        
        titleLabel.do {
            $0.textColor = .main(.main2)
            $0.textAlignment = .center
            $0.font = .offroad(style: .iosTabbarMedi)
        }
        
        valueLabel.do {
            $0.textColor = .sub(.sub)
        }
    }
    
    private func setupHierarchy() {
        contentView.addSubviews(titleLabel, valueLabel)
    }
    
    // MARK: - Layout Func
    
    private func setupLayout() {
        titleLabel.snp.makeConstraints {
            $0.leading.centerY.equalToSuperview().inset(14)
        }
        
        valueLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(14)
        }
    }
    
}

extension DeveloperModeNormalCell {
    
    //MARK: - Public Func
    
    public func configure(with model: any DeveloperSettingModelNormal) {
        titleLabel.text = model.title
        valueLabel.text = model.value
    }
    
}
