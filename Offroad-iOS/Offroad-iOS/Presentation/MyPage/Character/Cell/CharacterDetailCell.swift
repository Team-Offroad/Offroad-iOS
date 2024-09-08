//
//  CharacterDetailCell.swift
//  Offroad-iOS
//
//  Created by  정지원 on 8/13/24.
//
import UIKit

import SnapKit

class CharacterDetailCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    let containerView = UIView().then {
        $0.backgroundColor = UIColor.primary(.characterSelectBg3)
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
    }
    
    private var motionImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    private let characterLabel = UILabel().then {
        $0.text = ""
        $0.textAlignment = .center
        $0.textColor = UIColor.primary(.white)
        $0.font = UIFont.offroad(style: .iosTextContents)
    }
    
    private let newBadgeView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(resource: .imgNewTag)
        $0.isHidden = true
    }
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStyle()
        setupHierarchy()
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Functions
    
    private func setupStyle() {
        contentView.roundCorners(cornerRadius: 10)
        contentView.clipsToBounds = true
        contentView.backgroundColor = UIColor.home(.homeCharacterName)
    }
    
    private func setupHierarchy() {
        contentView.addSubviews(
            containerView,
            characterLabel,
            newBadgeView
        )
        containerView.addSubview(motionImageView)
    }
    
    private func setupLayout() {
        contentView.layer.cornerRadius = 10
        contentView.clipsToBounds = true
        
        containerView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.horizontalEdges.equalTo(contentView).inset(10)
        }
        
        motionImageView.snp.makeConstraints { make in
            make.width.equalTo(81)
            make.height.equalTo(147)
            make.centerX.centerY.equalToSuperview()
        }
        
        characterLabel.snp.makeConstraints{ make in
            characterLabel.snp.makeConstraints{ make in
                make.top.equalTo(containerView.snp.bottom).offset(10)
                make.centerX.equalToSuperview()
                make.bottom.equalToSuperview().inset(10)
            }
        }
        
        newBadgeView.snp.makeConstraints { make in
            make.top.trailing.equalTo(containerView).inset(8)
            make.size.equalTo(24)
        }    }
    
    //MARK: - Func
    
    func gainedMotionCell(data: GainedCharacterMotionList) {
        motionImageView.fetchSvgURLToImageView(svgUrlString: data.characterMotionImageUrl)
        if data.category == "CAFFE" {
            characterLabel.text = "카페 방문 시"
        }
        else if data.category == "PARK" {
            characterLabel.text = "공원 방문 시"
        }
        else if data.category == "CULTURE" {
            characterLabel.text = "문화 방문 시"
        }
        else if data.category == "RESTAURANT" {
            characterLabel.text = "식당 방문 시"
        }
        else if data.category == "SPORT" {
            characterLabel.text = "헬스장 방문 시"
        }
        
        if data.isNewGained {
            newBadgeView.isHidden = false
        }
    }
    
    func notGainedMotionCell(data: NotGainedCharacterMotionList) {
        motionImageView.fetchSvgURLToImageView(svgUrlString: data.characterMotionImageUrl)
        if data.category == "CAFFE" {
            characterLabel.text = "카페 방문 시"
        }
        else if data.category == "PARK" {
            characterLabel.text = "공원 방문 시"
        }
        else if data.category == "CULTURE" {
            characterLabel.text = "문화 방문 시"
        }
        else if data.category == "RESTAURANT" {
            characterLabel.text = "식당 방문 시"
        }
        else if data.category == "SPORT" {
            characterLabel.text = "헬스장 방문 시"
        }
            
        if data.isNewGained {
            newBadgeView.isHidden = false
        }
    }
    
    func configureCellColor(mainColor: String, subColor: String){
        contentView.backgroundColor = UIColor(hex: mainColor)
        containerView.backgroundColor = UIColor(hex: subColor)
    }
}
