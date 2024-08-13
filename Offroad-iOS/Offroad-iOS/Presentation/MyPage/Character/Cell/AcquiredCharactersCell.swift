//
//  AcquiredCharactersCell.swift
//  Offroad-iOS
//
//  Created by  정지원 on 8/11/24.
//

import UIKit
import SnapKit

class AcquiredCharactersCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    private let containerView = UIView().then {
        $0.backgroundColor = UIColor.primary(.characterSelectBg3)
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
    }
    
    var imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Functions
    
    private func setupViews() {
        contentView.layer.cornerRadius = 10
        contentView.clipsToBounds = true
        contentView.backgroundColor = UIColor.home(.homeCharacterName)
        
        contentView.addSubview(containerView)
        containerView.addSubview(imageView)
        
        contentView.snp.makeConstraints { make in
            make.width.equalTo(162)
            make.height.equalTo(214)
        }
        
        containerView.snp.makeConstraints { make in
            make.height.equalTo(154)
            make.centerX.equalToSuperview()
            make.top.horizontalEdges.equalTo(contentView).inset(10)
        }
        
        imageView.snp.makeConstraints { make in
            make.width.equalTo(75)
            make.height.equalTo(136)
            make.center.equalToSuperview()
        }
    }
    
    func configure(imageName: String) {
        imageView.image = UIImage(named: imageName)
    }
}
