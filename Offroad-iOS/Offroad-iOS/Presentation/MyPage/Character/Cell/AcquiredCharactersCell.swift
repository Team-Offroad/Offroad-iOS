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
    
    // MARK: - Properties
    
    private let containerView = UIView().then {
        $0.backgroundColor = UIColor.primary(.characterSelectBg3)
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
    }
    
    private var imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    private let characterLabel = UILabel().then {
        $0.text = ""
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
        contentView.backgroundColor = UIColor.home(.homeCharacterName)
        
        containerView.snp.makeConstraints { make in
            make.height.equalTo(167)
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
        }
    }
    
    private func getAcquiredCharacterInfo() {
        NetworkService.shared.characterService.getCharacterInfo { response in
            switch response {
            case .success(let data):
                let count = data?.data.characters.count ?? 0
                
                self.characterInfoModelList = data?.data.characters
                
                self.extendedCharacterImageList.insert(data?.data.characters[count - 1].characterBaseImageUrl ?? "", at: 0)
                for character in data?.data.characters ?? [CharacterList]() {
                    self.extendedCharacterImageList.append(character.characterBaseImageUrl)
                    self.characterNames.append(character.name)
                    self.characterDiscriptions.append(character.description)
                }
                self.extendedCharacterImageList.append(data?.data.characters[0].characterBaseImageUrl ?? "")
                
            default:
                break
            }
        }
    
    //MARK: - Func
    
    func configureCell(data: NotGainedCharacterList) {
        imageView.fetchSvgURLToImageView(svgUrlString: data.characterThumbnailImageUrl)
        
        switch imageName {
        case "character_1":
            contentView.backgroundColor = UIColor.home(.homeCharacterName)
            containerView.backgroundColor = UIColor.primary(.characterSelectBg3)
            characterLabel.text = "아루"
        case "character_2":
            contentView.backgroundColor = UIColor.primary(.getCharacter2)
            containerView.backgroundColor = UIColor.primary(.characterSelectBg2)
            characterLabel.text = "오푸"
        case "character_3":
            contentView.backgroundColor = UIColor.home(.homeContents1GraphMain)
            containerView.backgroundColor = UIColor.primary(.characterSelectBg1)
            characterLabel.text = "루미"
        default:
            contentView.backgroundColor = UIColor.gray
            containerView.backgroundColor = UIColor.darkGray
        }
    }
}
