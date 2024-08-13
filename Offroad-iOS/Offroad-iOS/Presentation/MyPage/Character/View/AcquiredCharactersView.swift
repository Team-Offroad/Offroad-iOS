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

    private lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let padding: CGFloat = 20
        layout.itemSize = CGSize(width: 162, height: 214)
        layout.minimumLineSpacing = padding
        layout.minimumInteritemSpacing = padding
        return layout
    }()

    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(AcquiredCharactersCell.self, forCellWithReuseIdentifier: "AcquiredCharactersCell")
        collectionView.backgroundColor = .clear
        return collectionView
    }()

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
        backgroundColor = UIColor.main(.main3)
    }

    private func setupHierarchy() {
        addSubview(collectionView)
    }

    private func setupLayout() {
        let totalCellWidth = 2 * layout.itemSize.width
        let totalSpacingWidth = layout.minimumInteritemSpacing
        let collectionViewWidth = totalCellWidth + totalSpacingWidth

        collectionView.snp.makeConstraints { make in
            make.centerX.equalToSuperview() // Center horizontally
            make.top.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().offset(-20)
            make.width.equalTo(collectionViewWidth)
        }
    }
}

