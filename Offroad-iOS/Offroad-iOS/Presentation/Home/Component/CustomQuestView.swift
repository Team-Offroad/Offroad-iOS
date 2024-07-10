//
//  CustomQuestView.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 7/10/24.
//

import UIKit

import SnapKit
import Then

final class CustomQuestView: UIView {

    //MARK: - UI Properties
    
    private let questLabel = UILabel()
    private let imageView = UIImageView()
    private let detailView = UIView()
    private let detailLabel = UILabel()
        
    // MARK: - Life Cycle
    
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

extension CustomQuestView {
    
    // MARK: - Layout
    
    private func setupStyle() {
        self.backgroundColor = backgroundColor
        roundCorners(cornerRadius: 10)
        
        questLabel.do {
            $0.font = .offroad(style: .iosTextContents)
            $0.textAlignment = .center
        }
        
        detailView.do {
            $0.backgroundColor = .whiteOpacity(.white25)
            $0.roundCorners(cornerRadius: 5)
        }
        
        detailLabel.do {
            $0.font = .offroad(style: .iosTextContentsSmall)
            $0.textAlignment = .center
        }
    }
    
    private func setupHierarchy() {
        addSubviews(
            questLabel,
            imageView,
            detailView
        )
        
        detailView.addSubview(detailLabel)
    }
    
    private func setupLayout() {
        questLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(18)
            $0.leading.equalToSuperview().inset(14)
        }
        
        imageView.snp.makeConstraints {
            $0.centerY.equalTo(questLabel.snp.centerY)
            $0.leading.equalTo(questLabel.snp.trailing).offset(3)
        }
        
        detailView.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(14)
            $0.horizontalEdges.equalToSuperview().inset(11)
            $0.height.equalTo(25)
        }
        
        detailLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    //MARK: - Method
    
    func configureCustomView(mainColor: UIColor, questString: String, textColor: UIColor, image: UIImage, detailString: String) {
        backgroundColor = mainColor
        questLabel.text = questString
        questLabel.textColor = textColor
        imageView.image = image
        detailLabel.text = detailString
        detailLabel.textColor = textColor
    }
}
