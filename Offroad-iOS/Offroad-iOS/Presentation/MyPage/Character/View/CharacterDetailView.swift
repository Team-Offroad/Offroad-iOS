//
//  CharacterDetailView.swift
//  Offroad-iOS
//
//  Created by  정지원 on 8/13/24.
//

import UIKit

import SnapKit

class CharacterDetailView: UIView {
    
    // MARK: - Properties
    
    var characterImage = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    private let labelView = UIView().then {
        $0.backgroundColor = UIColor.main(.main1)
        $0.roundCorners(cornerRadius: 10)
    }
    
    private let detailLabelView = UIView().then {
        $0.backgroundColor = UIColor.main(.main1)
        $0.roundCorners(cornerRadius: 10)
    }
    
    let nameLabel = UILabel().then {
        $0.text = ""
        $0.textAlignment = .left
        $0.textColor = UIColor.sub(.sub4)
        $0.font = UIFont.offroad(style: .iosSubtitle2Bold)
    }
    
    private let mainLabel = UILabel().then {
        $0.text = "캐릭터 모션"
        $0.textAlignment = .left
        $0.textColor = UIColor.main(.main2)
        $0.font = UIFont.offroad(style: .iosTextTitle)
    }
    
    private let babyImage = UIImageView(image: UIImage(resource: .baby))
    
    var characterLogoImage = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    private let titleLabel = UILabel().then {
        $0.text = "호기심이 많은 탐험가"
        $0.textAlignment = .left
        $0.textColor = UIColor.grayscale(.gray300)
        $0.font = UIFont.offroad(style: .iosTextContentsSmall)
    }
    
    let detailLabel = UILabel().then {
        $0.text = ""
        $0.textAlignment = .left
        $0.numberOfLines = 3
        $0.textColor = UIColor.grayscale(.gray400)
        $0.font = UIFont.offroad(style: .iosBoxMedi)
    }
    
    private lazy var layout = UICollectionViewFlowLayout().then {
        let padding: CGFloat = 20
        $0.itemSize = CGSize(width: 162, height: 214)
        $0.minimumLineSpacing = padding
        $0.minimumInteritemSpacing = padding
    }
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout).then {
        $0.register(AcquiredCharactersCell.self, forCellWithReuseIdentifier: "AcquiredCharactersCell")
        $0.backgroundColor = .clear
    }
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStyle()
        setupHierarchy()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Functions
    
    private func setupStyle() {
        backgroundColor = UIColor.myPage(.listBg)
    }
    
    private func setupHierarchy() {
        addSubview(characterImage)
        addSubview(labelView)
        addSubview(detailLabelView)
        addSubview(collectionView)
        labelView.addSubviews(
            nameLabel,
            titleLabel,
            characterLogoImage
        )
        detailLabelView.addSubview(detailLabel)
        collectionView.addSubviews(mainLabel, babyImage)
    }
    
    private func setupLayout() {
        
        characterImage.snp.makeConstraints { make in
            make.top.equalTo(safeAreaInsets).inset(84)
            make.centerX.equalToSuperview()
            make.width.equalTo(155)
            make.height.equalTo(280)
        }
        
        labelView.snp.makeConstraints { make in
            make.top.equalTo(characterImage.snp.bottom).offset(30)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(84)
        }
        
        characterLogoImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(22)
            make.size.equalTo(CGSize(width: 50, height: 50))
        }
        
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(characterLogoImage.snp.trailing).offset(17)
            make.top.equalToSuperview().inset(21)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(4)
            make.centerX.equalTo(nameLabel)
        }
        
        detailLabelView.snp.makeConstraints { make in
            make.top.equalTo(labelView.snp.bottom)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(104)
        }
        
        detailLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(22)
            make.centerY.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(detailLabelView.snp.bottom).offset(30)
            make.horizontalEdges.equalToSuperview().inset(24.5)
            make.bottom.equalToSuperview().offset(-20)
        }
        
        mainLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(37)
            make.left.equalToSuperview().inset(24)
        }
        
        babyImage.snp.makeConstraints { make in
            make.centerY.equalTo(mainLabel)
            make.leading.equalTo(mainLabel.snp.trailing).offset(8)
            make.size.equalTo(CGSize(width: 26, height: 21))
        }
    }
}

