//
//  AcquiredCharactersView.swift
//  Offroad-iOS
//
//  Created by  정지원 on 8/11/24.
//

import UIKit

import SnapKit
import Then

class CharacterListView: UIView {

    // MARK: - UI Properties
    
    let customBackButton = NavigationPopButton()
    
    var characterImage = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    private let labelView = UIView().then {
        $0.backgroundColor = UIColor.main(.main1)
    }
    
    private let mainLabel = UILabel().then {
        $0.text = "획득 캐릭터"
        $0.textAlignment = .left
        $0.textColor = UIColor.main(.main2)
        $0.font = UIFont.offroad(style: .iosTextTitle)
    }
    
    private let characterIconImage = UIImageView(image: .icnCharacterDetailOrbCharacter).then { imageView in
        imageView.contentMode = .scaleAspectFit
    }
    
    private let subLabel = UILabel().then {
        $0.text = "퀘스트를 달성하고 보상으로 캐릭터를 얻어보아요!"
        $0.textAlignment = .left
        $0.textColor = UIColor.sub(.sub2)
        $0.font = UIFont.offroad(style: .iosBoxMedi)
    }
    
    private let checkImage = UIImageView(image: UIImage(resource: .iconCheckCircle))
    
    private lazy var layout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .vertical
        let padding: CGFloat = 20
        let itemWidth = (UIScreen.main.bounds.width - 2*24.5 - padding)/2
        let itemHeight: CGFloat = itemWidth * (214 / 162)
        $0.itemSize = CGSize(width: itemWidth, height: itemHeight)
        $0.minimumLineSpacing = padding
        $0.minimumInteritemSpacing = padding
        $0.sectionInset = .init(top: 20, left: 24.5, bottom: 20, right: 24.5)
    }

    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout).then {
        $0.register(CharacterListCell.self, forCellWithReuseIdentifier: CharacterListCell.className)
        $0.backgroundColor = .clear
        $0.showsVerticalScrollIndicator = false
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

    // MARK: - Private Func
    
    private func setupStyle() {
        backgroundColor = .primary(.listBg)
        checkImage.contentMode = .scaleAspectFit
        collectionView.delaysContentTouches = false
    }

    private func setupHierarchy() {
        addSubviews(
            labelView,
            collectionView
        )
        labelView.addSubviews(
            customBackButton,
            mainLabel,
            characterIconImage,
            subLabel,
            characterImage,
            checkImage
        )
    }

    private func setupLayout() {
        customBackButton.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).inset(12)
            $0.leading.equalToSuperview().inset(12)
        }
        
        labelView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }

        mainLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(98)
            make.left.equalToSuperview().inset(24)
        }

        subLabel.snp.makeConstraints { make in
            make.top.equalTo(mainLabel.snp.bottom).offset(13)
            make.leading.equalTo(checkImage.snp.trailing).offset(6)
            make.bottom.equalToSuperview().inset(24)
        }

        characterIconImage.snp.makeConstraints { make in
            make.centerY.equalTo(mainLabel)
            make.leading.equalTo(mainLabel.snp.trailing).offset(8)
            make.size.equalTo(27)
        }

        checkImage.snp.makeConstraints { make in
            make.centerY.equalTo(subLabel)
            make.leading.equalTo(mainLabel)
            make.size.equalTo(CGSize(width: 16, height: 18))
        }

        collectionView.snp.makeConstraints { make in
            make.top.equalTo(labelView.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}
