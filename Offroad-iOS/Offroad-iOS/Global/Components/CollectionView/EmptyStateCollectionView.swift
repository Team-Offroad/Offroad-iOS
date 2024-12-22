//
//  EmptyStateCollectionView.swift
//  Offroad-iOS
//
//  Created by 김민성 on 12/23/24.
//

import UIKit

import SnapKit
import Then

class EmptyStateCollectionView: UICollectionView {
    
    //MARK: - Properties
    
    var emptyState: Bool = false {
        didSet {
            emptyStateStackView.isHidden = !emptyState
        }
    }
    
    //MARK: - UIProperties
    
    private var emptyStateMessage: String? = nil
    private let emptyStateLabel = UILabel()
    private let emptyStateImage = UIImageView(image: .imgEmptyCaseNova)
    private lazy var emptyStateStackView = UIStackView(arrangedSubviews: [emptyStateImage, emptyStateLabel])
    
    //MARK: - Life Cycle
    
    init(message: String?, frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        self.emptyStateMessage = message
        super.init(frame: frame, collectionViewLayout: layout)
        
        setupStyle()
        setupHierarchy()
        setupLayout()
        emptyStateStackView.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension EmptyStateCollectionView {
    
    //MARK: - Layout Func
    
    private func setupLayout() {
        emptyStateImage.snp.makeConstraints { make in
            make.size.equalTo(172)
        }
        
        emptyStateStackView.snp.makeConstraints { make in
            make.centerX.equalTo(frameLayoutGuide.snp.centerX)
            make.centerY.equalTo(frameLayoutGuide.snp.centerY).offset(-41)
            make.width.equalTo(243)
        }
    }
    
    //MARK: - Private Func
    
    private func setupStyle() {
        emptyStateLabel.do { label in
            label.text = emptyStateMessage
            label.textAlignment = .center
            label.numberOfLines = 0
            label.font = .offroad(style: .iosBoxMedi)
            label.textColor = .blackOpacity(.black55)
        }
        
        emptyStateImage.do { imageView in
            imageView.contentMode = .scaleAspectFit
        }
        
        emptyStateStackView.do { stackView in
            stackView.axis = .vertical
            stackView.spacing = 20
            stackView.alignment = .center
            stackView.distribution = .fill
        }
    }
    
    private func setupHierarchy() {
        addSubview(emptyStateStackView)
    }
    
}
