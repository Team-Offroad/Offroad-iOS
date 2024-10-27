//
//  ORBToastView.swift
//  Offroad-iOS
//
//  Created by 김민성 on 10/23/24.
//

import UIKit

class ORBToastView: UIView {
    
    //MARK: - UI Properties
    
    let imageView: UIImageView
    let messageLabel = UILabel()
    
    //MARK: - Life Cycle
    
    init(message: String? = nil, withImage image: UIImage? = nil) {
        self.messageLabel.text = message
        self.imageView = UIImageView.init(image: image)
        super.init(frame: .zero)
        
        setupStyle()
        setupHierarchy()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ORBToastView {
    
    //MARK: - Layout Func
    
    private func setupLayout() {
        imageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(22)
            if imageView.image != nil {
                make.size.equalTo(22)
            } else {
                make.size.equalTo(0)
            }
        }
        
        messageLabel.snp.makeConstraints { make in
            if imageView.image != nil {
                make.leading.equalTo(imageView.snp.trailing).offset(11)
                make.trailing.equalToSuperview().inset(20)
            } else {
                make.horizontalEdges.equalToSuperview().inset(20)
            }
            make.verticalEdges.equalToSuperview().inset(10.5)
        }
    }
    
    //MARK: - Private Func
    
    private func setupStyle() {
        backgroundColor = .blackOpacity(.black55)
        roundCorners(cornerRadius: 10)
        
        imageView.do { imageView in
            imageView.contentMode = .scaleAspectFit
        }
        
        messageLabel.do { label in
            label.font = .offroad(style: .iosTextAuto)
            label.textColor = .primary(.white)
            label.numberOfLines = 0
            label.textAlignment = imageView.image == nil ? .center : .left
        }
    }
    
    private func setupHierarchy() {
        addSubviews(imageView, messageLabel)
    }
    
}
