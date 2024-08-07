//
//  MyPageMenuCollectionViewCell.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 8/7/24.
//

import UIKit

import SnapKit
import Then

final class MyPageMenuCollectionViewCell: UICollectionViewCell {
    
    //MARK: - UI Properties
    
    private let menuLabel = UILabel()
    private let backgroundImageView = UIImageView()
    
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

extension MyPageMenuCollectionViewCell {
    
    // MARK: - Layout
    
    private func setupStyle() {
        roundCorners(cornerRadius: 10)
        
        menuLabel.do {
            $0.textColor = .sub(.sub4)
            $0.textAlignment = .center
            $0.font = .offroad(style: .iosTextBold)
        }
    }
    
    private func setupHierarchy() {
        addSubviews(backgroundImageView, menuLabel)
    }
    
    private func setupLayout() {
        menuLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(17)
        }
        
        backgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
    }
    
    //MARK: - Func
    
    func configureCell(data: MyPageMenuModel) {
        menuLabel.text = data.menuString
        backgroundImageView.image = data.menuImage
    }
}
