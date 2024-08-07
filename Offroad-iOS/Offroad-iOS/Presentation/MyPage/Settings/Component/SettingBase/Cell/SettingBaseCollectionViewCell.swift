//
//  SettingBaseCollectionViewCell.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 8/7/24.
//

import UIKit

import SnapKit
import Then

final class SettingBaseCollectionViewCell: UICollectionViewCell {
    
    //MARK: - UI Properties
    
    private let listLabel = UILabel()
    private let arrowImageView = UIImageView(image: UIImage(resource: .iconArrow))
    
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

extension SettingBaseCollectionViewCell {
    
    // MARK: - Layout
    
    private func setupStyle() {
        backgroundColor = .main(.main1)
        
        listLabel.do {
            $0.textColor = .main(.main2)
            $0.textAlignment = .center
            $0.font = .offroad(style: .iosTabbarMedi)
        }
    }
    
    private func setupHierarchy() {
        addSubviews(listLabel, arrowImageView)
    }
    
    private func setupLayout() {
        listLabel.snp.makeConstraints {
            $0.leading.centerY.equalToSuperview()
        }
        
        arrowImageView.snp.makeConstraints {
            $0.trailing.centerY.equalToSuperview()
        }
        
    }
    
    //MARK: - Func
    
    func configureCell(data: SettingBaseModel) {
        listLabel.text = data.listString
        
        let targetText = "[중요]"
        if data.listString.contains(targetText) {
            listLabel.highlightText(targetText: targetText, color: .sub(.sub2) )
        }
    }
}
