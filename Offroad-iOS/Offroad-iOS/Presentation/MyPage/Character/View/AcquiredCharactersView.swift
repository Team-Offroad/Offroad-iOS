//
//  AcquiredCharactersView.swift
//  Offroad-iOS
//
//  Created by  정지원 on 8/11/24.
//

import UIKit

import SnapKit

class AcquiredCharactersView: UIView {

    // MARK: - Properties
    
    private let labelView = UIView().then {
        $0.backgroundColor = UIColor.main(.main1)
    }
    
    private let mainLabel = UILabel().then {
        $0.text = "획득 캐릭터"
        $0.textAlignment = .left
        $0.textColor = UIColor.main(.main2)
        $0.font = UIFont.offroad(style: .iosTextTitle)
    }
    
    private let characterImage = UIImageView(image: UIImage(resource: .baby))
    
    private let subLabel = UILabel().then {
        $0.text = "퀘스트를 달성하고 보상으로 캐릭터를 얻어보아요!"
        $0.textAlignment = .left
        $0.textColor = UIColor.sub(.sub2)
        $0.font = UIFont.offroad(style: .iosBoxMedi)
    }
    
    private let checkImage = UIImageView(image: UIImage(resource: .check))
    
    private lazy var layout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .vertical
        let padding: CGFloat = 20
        $0.itemSize = CGSize(width: 162, height: 214)
        $0.minimumLineSpacing = padding
        $0.minimumInteritemSpacing = padding
    }

    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout).then {
        $0.register(AcquiredCharactersCell.self, forCellWithReuseIdentifier: "AcquiredCharactersCell")
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

    // MARK: - Private Functions
    
    private func setupStyle() {
        backgroundColor = .primary(.listBg)
    }

    private func setupHierarchy() {
        addSubviews(labelView, collectionView)
        labelView.addSubviews(mainLabel, subLabel, characterImage, checkImage)
    }

    private func setupLayout() {
        labelView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(230) 
        }

        mainLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(98)
            make.left.equalToSuperview().inset(24)
        }

        subLabel.snp.makeConstraints { make in
            make.top.equalTo(mainLabel.snp.bottom).offset(13)
            make.leading.equalTo(checkImage.snp.trailing).offset(6)
        }

        characterImage.snp.makeConstraints { make in
            make.centerY.equalTo(mainLabel)
            make.leading.equalTo(mainLabel.snp.trailing).offset(8)
            make.size.equalTo(CGSize(width: 26, height: 21))
        }

        checkImage.snp.makeConstraints { make in
            make.centerY.equalTo(subLabel)
            make.leading.equalTo(mainLabel)
            make.size.equalTo(CGSize(width: 16, height: 18))
        }

        collectionView.snp.makeConstraints { make in
            make.top.equalTo(labelView.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(24.5)
            make.bottom.equalToSuperview().inset(20)
        }
    }
}
