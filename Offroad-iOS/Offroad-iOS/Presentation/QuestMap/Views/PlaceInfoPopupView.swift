//
//  placeInfoPopupView.swift
//  Offroad-iOS
//
//  Created by 김민성 on 2024/07/17.
//

import UIKit

class PlaceInfoPopupView: UIView {
    
    //MARK: - UI Properties
    
    let popupView = UIView()
    
    let offroadLogoImageView = UIImageView(image: .icnOffroadlogoPopupView)
    let nameLabel = UILabel()
    let nameAndImageStackView = UIStackView()
    
    let placeCategoryImageView = UIImageView()
    let shortDescriptionLabel = UILabel()
    let addresssLabel = UILabel()
    let visitCountLabel = UILabel()
    
    let exploreButton = UIButton()
    let closeButton = UIButton()
    
    //MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupHierarchy()
        setupStyle()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension PlaceInfoPopupView {
    
    private func setupHierarchy() {
        nameAndImageStackView.addArrangedSubviews(nameLabel, placeCategoryImageView)
        
        popupView.addSubviews(
            offroadLogoImageView,
            nameAndImageStackView,
            shortDescriptionLabel,
            addresssLabel,
            visitCountLabel,
            exploreButton,
            closeButton
        )
    }
    
    private func setupStyle() {
        popupView.backgroundColor = .main(.main3)
        
        nameLabel.do { label in
            label.font = .offroad(style: .iosTooltipTitle)
            label.textColor = .main(.main2)
            label.textAlignment = .left
        }
        
        nameAndImageStackView.do { stackView in
            stackView.axis = .horizontal
            stackView.spacing = 5
            stackView.alignment = .center
            stackView.distribution = .fillProportionally
        }
        
        shortDescriptionLabel.do { label in
            label.font = .offroad(style: .iosTextContents)
            label.textColor = .main(.main2)
            label.textAlignment = .left
        }
        
        addresssLabel.do { label in
            label.font = .offroad(style: .iosTextContentsSmall)
            label.textColor = .grayscale(.gray400)
            label.textAlignment = .left
        }
        
        visitCountLabel.do { label in
            label.font = .offroad(style: .iosTooltipNumber)
            label.textColor = .sub(.sub2)
            label.textAlignment = .left
        }
        
        exploreButton.do { button in
            button.setTitle("탐험하기", for: .normal)
            button.setImage(.btnPopupClose, for: .normal)
            button.titleLabel?.font = .offroad(style: .iosBtnSmall)
            button.setTitleColor(.primary(.white), for: .normal)
            button.backgroundColor = .sub(.sub)
            button.roundCorners(cornerRadius: 5)
        }
    }
    
    private func setupLayout() {
        
        nameAndImageStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(17)
            make.leading.equalToSuperview().inset(15)
        }
        
        shortDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(nameAndImageStackView.snp.bottom).offset(10)
            make.leading.equalToSuperview().inset(15)
        }
        
        addresssLabel.snp.makeConstraints { make in
            make.top.equalTo(shortDescriptionLabel.snp.bottom).offset(4)
            make.leading.equalToSuperview().inset(15)
            
        }
        
        visitCountLabel.snp.makeConstraints { make in
            make.top.equalTo(addresssLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().inset(15)
        }
        
        exploreButton.snp.makeConstraints { make in
            make.top.equalTo(visitCountLabel.snp.bottom).offset(15)
            make.horizontalEdges.equalToSuperview().inset(14)
            make.bottom.equalToSuperview().inset(14)
        }
        
        closeButton.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview()
            make.width.height.equalTo(48)
        }
        
        
        popupView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
    
}
