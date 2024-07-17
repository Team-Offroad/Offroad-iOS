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
    
    static let identifier = "ChoosingCharacterCell"
    
    let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubviews(imageView)
        
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureCell(imageURL: String) {
        let url = URL(string: imageURL)
        imageView.kf.setImage(with: url)
    }
}
