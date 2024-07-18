//
//  ChoosingCharacterCell.swift
//  Offroad-iOS
//
//  Created by  정지원 on 7/11/24.
//
import UIKit

import Kingfisher
import SnapKit
import Then

final class ChoosingCharacterCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    private let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    //MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupHierarchy()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ChoosingCharacterCell {
    
    //MARK: - Layout
    
    private func setupHierarchy() {
        contentView.addSubview(imageView)
    }
    
    private func setupLayout() {
        imageView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(70)
            make.centerX.equalToSuperview()
        }
    }
    
    //MARK: - Func
    
    func configureCell(imageURL: String) {
        imageView.fetchSvgURLToImageView(svgUrlString: imageURL)
    }
}
