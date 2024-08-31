//
//  NavigationPopButton.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 8/22/24.
//

import UIKit

/// Navigation Pop Button
/// Navigation bar를 hidden했을 때 back button 대신 사용할 수 있는 custom button
/// > 사용 예시 :  `private let button = NavigationPopButton()
final class NavigationPopButton: UIButton {
    
    // MARK: -  UI Properties
    
    private let backButtonImageView = UIImageView(image: UIImage(resource: .backBarButton))
    private let previousViewTitleLabel = UILabel()
    
    // MARK: - Life Cycle

    init() {
        super.init(frame: .zero)
        
        setupStyle()
        setupHierarchy()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension NavigationPopButton {
    
    // MARK: - Private Func

    private func setupStyle() {
        previousViewTitleLabel.do {
            $0.textColor = .main(.main2)
            $0.textAlignment = .center
            $0.font = .offroad(style: .iosTextRegular)
        }
    }
    
    private func setupHierarchy() {
        addSubviews(backButtonImageView, previousViewTitleLabel)
    }
    
    private func setupLayout() {
        backButtonImageView.snp.makeConstraints {
            $0.centerY.leading.equalToSuperview()
        }
        
        previousViewTitleLabel.snp.makeConstraints {
            $0.centerY.trailing.equalToSuperview()
            $0.leading.equalTo(backButtonImageView.snp.trailing)
        }
    }
    
    //MARK: - Func
    
    func configureButtonTitle(titleString: String) {
        previousViewTitleLabel.text = titleString
    }
}
