//
//  AcquiredCharactersCell.swift
//  Offroad-iOS
//
//  Created by  정지원 on 8/11/24.
//

import UIKit

import SnapKit
import Kingfisher

class AcquiredCharactersCell: UICollectionViewCell {
    
    // MARK: - UI Properties
    
    private let containerView = UIView().then {
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
    }
    
    private var imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    private let characterLabel = UILabel().then {
        $0.textAlignment = .center
        $0.textColor = UIColor.primary(.white)
        $0.font = UIFont.offroad(style: .iosTextContents)
    }
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupHierarchy()
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Functions
    
    private func setupHierarchy() {
        contentView.addSubviews(containerView, characterLabel)
        containerView.addSubview(imageView)
    }
    
    private func setupLayout() {
        contentView.layer.cornerRadius = 10
        contentView.clipsToBounds = true
        
        containerView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.horizontalEdges.equalTo(contentView).inset(10)
        }
        
        imageView.snp.makeConstraints { make in
            make.width.equalTo(75)
            make.height.equalTo(136)
            make.center.equalToSuperview()
        }
        
        characterLabel.snp.makeConstraints{ make in
            make.top.equalTo(containerView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(10)
        }
    }
    
    
    //MARK: - Func
    
    func configureCell(data: GainedCharacterList) {
        imageView.fetchSvgURLToImageView(svgUrlString: data.characterThumbnailImageUrl)
        characterLabel.text = data.characterName
        contentView.backgroundColor = UIColor(hex: data.characterMainColorCode)
        containerView.backgroundColor = UIColor(hex: data.characterSubColorCode)
    }
}
