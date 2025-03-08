//
//  GuideCollectionViewCell.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 3/5/25.
//

import UIKit

import Kingfisher
import SnapKit
import Then

final class GuideCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    private let imageView = UIImageView()
    private let descriptionLabel = UILabel()

    //MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupStyle()
        setupHierarchy()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.image = nil
    }
}

private extension GuideCollectionViewCell {
    
    //MARK: - Layout
    
    func setupStyle() {
        imageView.do {
            $0.contentMode = .scaleAspectFit
        }
        
        descriptionLabel.do {
            $0.textColor = .primary(.white)
            $0.numberOfLines = 0
            $0.textAlignment = .center
            $0.font = .offroad(style: .iosText)
            
            $0.setContentCompressionResistancePriority(UILayoutPriority.defaultHigh + 1, for: .vertical)
        }
    }
    
    func setupHierarchy() {
        contentView.addSubviews(
            imageView,
            descriptionLabel
        )
    }
    
    func setupLayout() {
        imageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(70)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}

extension GuideCollectionViewCell {
    
    
    //MARK: - Func
    
    func configureCell(image: UIImage, description: String) {
        imageView.image = image
        descriptionLabel.text = description
        descriptionLabel.setLineHeight(percentage: 150)
    }
}
