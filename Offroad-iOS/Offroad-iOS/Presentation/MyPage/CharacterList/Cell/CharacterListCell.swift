//
//  AcquiredCharactersCell.swift
//  Offroad-iOS
//
//  Created by  정지원 on 8/11/24.
//

import UIKit

import SnapKit
import Kingfisher

class CharacterListCell: UICollectionViewCell, SVGFetchable {
    
    // MARK: - Properties
    
    override var isHighlighted: Bool {
        didSet { dimmingView.isHidden = !isHighlighted }
    }
    
    // MARK: - UI Properties
    
    private let containerView = UIView().then {
        $0.roundCorners(cornerRadius: 10)
    }
    
    private var characterListCellImageView = UIImageView().then {
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
    
    private let dimmingView = UIView().then {
        $0.backgroundColor = .blackOpacity(.black25)
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        characterListCellImageView.image = nil
    }
    
}

extension CharacterListCell {
    
    // MARK: - Private Func
    
    private func setupHierarchy() {
        contentView.addSubviews(containerView, characterLabel, shadowView, newBadgeView, mainCharacterBadgeView, dimmingView)
        shadowView.addSubview(lockImageView)
        containerView.addSubview(characterListCellImageView)
    }
    
    private func setupStyle() {
        contentView.roundCorners(cornerRadius: 10)
    }
    
    private func setupLayout() {
        containerView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.horizontalEdges.equalTo(contentView).inset(10)
        }
        
        characterListCellImageView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(17.5)
            make.verticalEdges.equalToSuperview().inset(17.5)
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
        
        dimmingView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    //MARK: - Func
    
    func configure(with data: CharacterListInfoData, representativeCharacterId: Int) {
        characterListCellImageView.startLoading(withoutShading: true)
        fetchSVG(svgURLString: data.characterThumbnailImageUrl) { image in
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                characterListCellImageView.stopLoading()
                self.characterListCellImageView.image = image
            }
        }
        
        characterLabel.text = data.characterName
        contentView.backgroundColor = UIColor(hex: data.characterMainColorCode)
        containerView.backgroundColor = UIColor(hex: data.characterSubColorCode)
        
        shadowView.isHidden = data.isGained
        lockImageView.isHidden = data.isGained
        newBadgeView.isHidden = !data.isNewGained
        mainCharacterBadgeView.isHidden = !((data.isGained) && (data.characterId == representativeCharacterId))
    }
    
}
