//
//  CharacterChatLogReusableView.swift
//  Offroad-iOS
//
//  Created by 김민성 on 11/13/24.
//

import UIKit

class CharacterChatLogFooter: UICollectionReusableView {
    
    //MARK: - UI Properties
    
    private let verticalFlipTransform = CGAffineTransform(scaleX: 1, y: -1)
    
    let dateLabel = UILabel()
    private let separator = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupStyle()
        setupHierarchy()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        transform = verticalFlipTransform
        super.layoutSubviews()
    }
    
}

extension CharacterChatLogFooter {
    
    //MARK: - Layout Func
    
    private func setupLayout() {
        dateLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(19)
        }
        
        separator.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(24)
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    //MARK: - Private Func
    
    private func setupStyle() {
        dateLabel.do { label in
            label.font = .offroad(style: .iosBoxMedi)
            label.textColor = .main(.main3)
            label.textAlignment = .center
        }
        
        separator.do { view in
            view.backgroundColor = .whiteOpacity(.white25)
        }
    }
    
    private func setupHierarchy() {
        addSubviews(dateLabel, separator)
    }
}
