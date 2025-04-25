//
//  CharacterChatLogReusableView.swift
//  Offroad-iOS
//
//  Created by 김민성 on 11/13/24.
//

import UIKit

class CharacterChatLogFooter: UICollectionReusableView {
    
    //MARK: - Properties
    
    private let verticalFlipTransform = CGAffineTransform(scaleX: 1, y: -1)
    
    //MARK: - UI Properties
    
    let contentView = UIView()
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
    
}

// Initial Setting
private extension CharacterChatLogFooter {
    
    func setupLayout() {
        contentView.transform = verticalFlipTransform
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        dateLabel.snp.makeConstraints { make in
            make.centerX.top.equalToSuperview()
            make.height.equalTo(19)
        }
        
        separator.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(24)
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    func setupStyle() {
        dateLabel.do { label in
            label.font = .offroad(style: .iosBoxMedi)
            label.textColor = .main(.main3)
            label.textAlignment = .center
        }
        
        separator.do { view in
            view.backgroundColor = .whiteOpacity(.white25)
        }
    }
    
    func setupHierarchy() {
        addSubview(contentView)
        contentView.addSubviews(dateLabel, separator)
    }
    
}
