//
//  AcquiredCharactersCell.swift
//  Offroad-iOS
//
//  Created by  정지원 on 8/11/24.
//

import UIKit

import SnapKit
import Kingfisher

class CharacterListCell: UICollectionViewCell {
    
    // MARK: - UI Properties
    
    private let containerView = UIView().then {
        $0.roundCorners(cornerRadius: 10)
    }
    
    private var acqiredCharacterImageView = UIImageView().then {
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
    
    private let newBadgeView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(resource: .imgNewTag)
        $0.isHidden = true
    }
    
    let mainCharacterBadgeView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(resource: .imgCrownTag)
        $0.isHidden = true
    }
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupHierarchy()
        setupStyle()
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Functions
    
    private func setupHierarchy() {
        contentView.addSubviews(containerView, characterLabel, shadowView, newBadgeView, mainCharacterBadgeView)
        shadowView.addSubview(lockImageView)
        containerView.addSubview(acqiredCharacterImageView)
    }
    
    private func setupStyle() {
        contentView.roundCorners(cornerRadius: 10)
    }
    
    private func setupLayout() {
        containerView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.horizontalEdges.equalTo(contentView).inset(10)
        }
        
        acqiredCharacterImageView.snp.makeConstraints { make in
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
        
        newBadgeView.snp.makeConstraints { make in
            make.top.trailing.equalTo(containerView).inset(8)
            make.size.equalTo(24)
        }
        
        mainCharacterBadgeView.snp.makeConstraints { make in
            make.top.trailing.equalTo(containerView).inset(8)
            make.size.equalTo(24)
        }
    }
    
    //MARK: - Func
    
    func gainedCharacterCell(data: CharacterListData, representiveCharacterId: Int) {
        acqiredCharacterImageView.fetchSvgURLToImageView(svgUrlString: data.characterThumbnailImageUrl)
        characterLabel.text = data.characterName
        contentView.backgroundColor = UIColor(hex: data.characterMainColorCode)
        containerView.backgroundColor = UIColor(hex: data.characterSubColorCode)
        
        shadowView.isHidden = true
        lockImageView.isHidden = true
        
        newBadgeView.isHidden = !data.isNewGained
        
        if data.characterId == representiveCharacterId {
            mainCharacterBadgeView.isHidden = false
        }
    }
    
    func notGainedCharacterCell(data: CharacterListData) {
        acqiredCharacterImageView.fetchSvgURLToImageView(svgUrlString: data.characterThumbnailImageUrl)
        characterLabel.text = data.characterName
        contentView.backgroundColor = UIColor(hex: data.characterMainColorCode)
        containerView.backgroundColor = UIColor(hex: data.characterSubColorCode)
        
        shadowView.isHidden = false
        lockImageView.isHidden = false
        
        if data.isNewGained {
            newBadgeView.isHidden = false
        }
        
        mainCharacterBadgeView.isHidden = true
    }
}
