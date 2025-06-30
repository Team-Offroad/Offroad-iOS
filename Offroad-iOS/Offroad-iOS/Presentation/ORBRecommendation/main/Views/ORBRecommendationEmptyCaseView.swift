//
//  ORBRecommendationEmptyCaseView.swift
//  ORB_Dev
//
//  Created by 김민성 on 6/21/25.
//

import UIKit

import SnapKit
import Then

final class ORBRecommendationEmptyCaseView: UIView {
    
    // MARK: - UI Properties
    
    let orbImageView = UIImageView(image: UIImage.imgEmptyCaseNova)
    let messageLabel = UILabel()
    let askButton = ShrinkableButton()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupStyle()
        setupHierarchy()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


// Initial Settings
private extension ORBRecommendationEmptyCaseView {
    
    func setupStyle() {
        orbImageView.contentMode = .scaleAspectFit
        
        messageLabel.do { label in
            label.font = .offroad(style: .iosBoxMedi)
            label.textColor = .blackOpacity(.black55)
            label.textAlignment = .center
            label.numberOfLines = 2
            label.text = emptyCaseMessage
            label.setLineHeight(percentage: 160)
        }
        
        askButton.do { button in
            button.titleLabel?.font = .offroad(style: .iosBtnSmall)
            button.setTitle("다시 물어보기", for: .normal)
            button.backgroundColor = .main(.main2)
            button.setTitleColor(.primary(.white), for: .normal)
            button.roundCorners(cornerRadius: 24)
        }
    }
    
    func setupHierarchy() {
        addSubviews(orbImageView, messageLabel, askButton)
    }
    
    func setupLayout() {
        orbImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            let topInset = UIScreen.current.isAspectRatioTall ? 200 : 162
            make.top.lessThanOrEqualToSuperview().offset(topInset)
            make.height.width.equalTo(172)
        }
        
        messageLabel.snp.makeConstraints { make in
            let topInset = UIScreen.current.isAspectRatioTall ? 32 : 15
            make.top.equalTo(orbImageView.snp.bottom).offset(topInset)
            make.centerX.equalToSuperview()
        }
        
        askButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(messageLabel.snp.bottom).offset(26)
            make.bottom.lessThanOrEqualToSuperview().inset(40)
            make.width.equalTo(230)
            make.height.equalTo(48)
        }
    }
    
}

// MARK: - ORBEmptyPlaceholderType

extension ORBRecommendationEmptyCaseView: ORBEmptyPlaceholderType {
    
    var emptyCaseMessage: String { "적절한 장소를 찾지 못 했어요.\n다른 조건으로 장소를 찾아보세요.." }
    
}
