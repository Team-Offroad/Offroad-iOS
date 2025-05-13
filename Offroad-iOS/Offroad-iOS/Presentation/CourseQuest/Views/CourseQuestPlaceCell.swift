//
//  CourseQuestPlaceCell.swift
//  Offroad-iOS
//
//  Created by  정지원 on 5/13/25.
//

import UIKit

import SnapKit
import Then

class CourseQuestPlaceCell: UICollectionViewCell {
    
    private let thumbnailImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 5
        $0.clipsToBounds = true
    }
    
    private let typeLabel = UILabel().then {
        $0.font = .offroad(style: .iosTextContentsSmall)
        $0.textColor = .sub(.sub2)
        $0.backgroundColor = UIColor.neutral(.nametagInactive)
        $0.layer.cornerRadius = 4
        $0.clipsToBounds = true
        $0.textAlignment = .center
    }
    
    private let nameLabel = UILabel().then {
        $0.font = .offroad(style: .iosTextBold)
        $0.textColor = .main(.main2)
    }
    
    private let addressLabel = UILabel().then {
        $0.font = .offroad(style: .iosTextContentsSmall)
        $0.textColor = .grayscale(.gray400)
    }
    
    private let visitButton = UIButton().then {
        $0.setTitle("방문", for: .normal)
        $0.setTitleColor(.sub(.sub), for: .normal)
        $0.titleLabel?.font = .offroad(style: .iosBtnSmall)
        $0.backgroundColor = .primary(.boxInfo)
        $0.layer.cornerRadius = 5
    }
    
    private let clearImageView = UIImageView().then {
        $0.image = UIImage(named: "clear")
        $0.contentMode = .scaleAspectFit
        $0.isHidden = true
    }
    
    var onVisit: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        visitButton.addTarget(self, action: #selector(visitTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 12
        contentView.clipsToBounds = true
        
        contentView.addSubview(thumbnailImageView)
        contentView.addSubview(typeLabel)
        contentView.addSubview(nameLabel)
        contentView.addSubview(addressLabel)
        contentView.addSubview(visitButton)
        contentView.addSubview(clearImageView)
        
        thumbnailImageView.snp.makeConstraints {
            $0.left.equalToSuperview().inset(12)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(76)
        }
        
        typeLabel.snp.makeConstraints {
            $0.top.equalTo(thumbnailImageView.snp.top)
            $0.left.equalTo(thumbnailImageView.snp.right).offset(12)
            $0.height.equalTo(18)
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(typeLabel.snp.bottom).offset(4)
            $0.left.equalTo(typeLabel.snp.left)
            $0.right.equalToSuperview().inset(60)
        }
        
        addressLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(2)
            $0.left.equalTo(nameLabel.snp.left)
        }
        
        visitButton.snp.makeConstraints {
            $0.right.equalToSuperview().inset(12)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(50)
            $0.height.equalTo(28)
        }
        
        clearImageView.snp.makeConstraints {
            $0.right.equalToSuperview().inset(12)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(50)
            $0.height.equalTo(28)
        }
    }
    
    func configure(with model: CourseQuestPlace) {
        thumbnailImageView.image = UIImage(named: model.imageName)
        typeLabel.text = " \(model.type) "
        nameLabel.text = model.name
        addressLabel.text = model.address
        
        if model.isVisited {
            visitButton.isHidden = true
            clearImageView.isHidden = false
        } else {
            visitButton.isHidden = false
            clearImageView.isHidden = true
        }
    }
    
    @objc private func visitTapped() {
        onVisit?()
    }
}
