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
    
    let nameLabel = UILabel()
    let placeCategoryImage: UIImage? = nil
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
        popupView.addSubviews(
            nameLabel,
            shortDescriptionLabel,
            addresssLabel,
            visitCountLabel,
            exploreButton,
            closeButton
        )
    }
    
    private func setupStyle() {
        popupView.backgroundColor = .main(.main3)
    }
    
    private func setupLayout() {
        
    }
    
}
