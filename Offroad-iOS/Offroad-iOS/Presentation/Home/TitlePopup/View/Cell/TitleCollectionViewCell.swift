//
//  TitleTableViewCell.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 7/11/24.
//

import UIKit

import SnapKit
import Then

final class TitleCollectionViewCell: UICollectionViewCell {
    
    //MARK: - UI Properties
    
    private let titleLabel = UILabel()
    
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

extension TitleCollectionViewCell {
    
    // MARK: - Layout
    
    private func setupStyle() {
        backgroundColor = .neutral(.nametagInactive)
        roundCorners(cornerRadius: 5)
        layer.borderColor = UIColor.home(.homeNametagStroke).cgColor
        layer.borderWidth = 1
        
        titleLabel.do {
            $0.textColor = .main(.main2)
            $0.textAlignment = .center
            $0.font = .offroad(style: .iosSubtitle2Semibold)
        }
    }
    
    private func setupHierarchy() {
        addSubview(titleLabel)
    }
    
    private func setupLayout() {
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    //MARK: - Func
    
    func configureCell(data: TitleModel) {
        titleLabel.text = data.titleString
    }
}
