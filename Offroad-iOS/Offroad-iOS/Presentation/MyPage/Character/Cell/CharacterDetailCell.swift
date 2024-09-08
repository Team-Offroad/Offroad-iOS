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
    
    private let newTagView = UIView().then {
        $0.backgroundColor = UIColor.sub(.sub)
        $0.layer.cornerRadius = 12
        $0.isHidden = true
    }
    
    private let newTagLabel = UIImageView().then {
        $0.image = UIImage(resource: .imgNewTag)
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
            newTagView
        )
        newTagView.addSubview(newTagLabel)
        containerView.addSubview(motionImageView)
    }
    
    private func setupLayout() {
        containerView.snp.makeConstraints { make in
            make.height.equalTo(167)
            make.centerX.equalToSuperview()
            make.top.horizontalEdges.equalToSuperview().inset(10)
        }
        
        motionImageView.snp.makeConstraints { make in
            make.width.equalTo(75)
            make.height.equalTo(136)
            make.center.equalToSuperview()
        }
        
        characterLabel.snp.makeConstraints{ make in
            make.top.equalTo(containerView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        
        newTagView.snp.makeConstraints { make in
            make.top.trailing.equalTo(containerView).inset(10)
            make.size.equalTo(24)
        }
        
        newTagLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
//    func configureCharacterImage(imageName: String, isNew: Bool = false) {
//        motionImageView.image = UIImage(named: imageName)
//        
//        switch imageName {
//        case "character_1":
//            contentView.backgroundColor = UIColor.home(.homeCharacterName)
//            containerView.backgroundColor = UIColor.primary(.characterSelectBg3)
//            characterLabel.text = "카페 방문 시"
//        case "character_2":
//            contentView.backgroundColor = UIColor.primary(.getCharacter2)
//            containerView.backgroundColor = UIColor.primary(.characterSelectBg2)
//            characterLabel.text = "공원 방문 시"
//        case "character_3":
//            contentView.backgroundColor = UIColor.home(.homeContents1GraphMain)
//            containerView.backgroundColor = UIColor.primary(.characterSelectBg1)
//            characterLabel.text = "식당 방문 시"
//        default:
//            contentView.backgroundColor = UIColor.gray
//            containerView.backgroundColor = UIColor.darkGray
//        }
//        
//        newTagView.isHidden = !isNew
//    }
}
