//
//  QuestResultView.swift
//  Offroad-iOS
//
//  Created by 김민성 on 2024/07/18.
//

import UIKit

class QuestResultView: UIView {
    
    //MARK: - UI Properties
    
    let popupView = UIView()
    
    private let titleLabel = UILabel()
    private let subTitle = UILabel()
    
    private let characterImageView = UIImageView(image: nil)
    
    let goToHomeButton = UIButton()
    
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

extension QuestResultView {
    
    //MARK: - Layout
    
    private func setupHierarchy() {
        
        popupView.addSubviews(
            titleLabel,
            subTitle,
            characterImageView,
            goToHomeButton
        )
        addSubview(popupView)
    }
    
    private func setupLayout() {
        
        titleLabel.do { label in
            label.text = "탐험 성공"
            label.font = .offroad(style: .iosTextTitle)
            label.textColor = .main(.main2)
            label.textAlignment = .center
        }
        
        titleLabel.do { label in
            label.text = "탐험에 성공했어요!\n이곳에 무엇이 있는지 천천히 살펴볼까요?"
            label.font = .offroad(style: .iosTextTitle)
            label.textColor = .main(.main2)
            label.textAlignment = .center
        }
        
        
        
    }
    
    //MARK: - Private Func
    
    private func setupStyle() {
        backgroundColor = .blackOpacity(.black15)
        
        
    }
    
    //MARK: - Func
    
    func configurePopupView(with placeInfo: RegisteredPlaceInfo) {
//        self.nameLabel.text = placeInfo.name
//        self.shortDescriptionLabel.text = placeInfo.shortIntroduction
//        self.addresssLabel.text = placeInfo.address
//        self.visitCountLabel.text = "탐험횟수:\(placeInfo.visitCount)"
    }
    
}

