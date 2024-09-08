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
    
    private let shadowView = UIView().then {
        $0.backgroundColor = .blackOpacity(.black25)
        $0.isHidden = true
    }
    
    private let lockImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(resource: .imgLock)
        $0.isHidden = true
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
        contentView.addSubviews(containerView, characterLabel, shadowView)
        shadowView.addSubview(lockImageView)
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
            make.width.equalTo(81)
            make.height.equalTo(147)
            make.centerX.centerY.equalToSuperview()
        }
        
        characterLabel.snp.makeConstraints{ make in
            make.top.equalTo(containerView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(10)
        }
        
        shadowView.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
        
        lockImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(75)
            make.width.equalTo(33)
            make.height.equalTo(37)
        }
    }
    
    
    //MARK: - Func
    
    func gainedCharacterCell(data: GainedCharacterList) {
        imageView.fetchSvgURLToImageView(svgUrlString: data.characterThumbnailImageUrl)
        characterLabel.text = data.characterName
        contentView.backgroundColor = UIColor(hex: data.characterMainColorCode)
        containerView.backgroundColor = UIColor(hex: data.characterSubColorCode)
        
        shadowView.isHidden = true
        lockImageView.isHidden = true
    }
    
    func notGainedCharacterCell(data: NotGainedCharacterList) {
        imageView.fetchSvgURLToImageView(svgUrlString: data.characterThumbnailImageUrl)
        characterLabel.text = data.characterName
        contentView.backgroundColor = UIColor(hex: data.characterMainColorCode)
        containerView.backgroundColor = UIColor(hex: data.characterSubColorCode)
        
        shadowView.isHidden = false
        lockImageView.isHidden = false
    }
}
