//
//  AcquiredCharactersCell.swift
//  Offroad-iOS
//
//  Created by  정지원 on 8/11/24.
//

import UIKit
import SnapKit

class AcquiredCharactersCell: UICollectionViewCell {
    var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        // Configure the cell's appearance
        contentView.layer.cornerRadius = 10
        contentView.clipsToBounds = true
        contentView.backgroundColor = UIColor(red: 0.545, green: 0.396, blue: 0.276, alpha: 0.45)
        
        contentView.addSubview(imageView)
        
        // Apply SnapKit constraints to contentView and imageView
        contentView.snp.makeConstraints { make in
            make.width.equalTo(162)
            make.height.equalTo(214)
        }
        
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview().offset(-10)
        }
    }
    
    func configure(imageName: String) {
        imageView.image = UIImage(named: imageName)
    }
}
