//
//  IconLabelStackView.swift
//  Offroad-iOS
//
//  Created by  정지원 on 3/11/25.
//

import UIKit

class IconLabelStackView: UIStackView {
    
    private let iconImageView = UIImageView()
    private let textLabel = UILabel()
    
    init(icon: UIImage?, text: String) {
        super.init(frame: .zero)
        setupStackView()
        configure(icon: icon, text: text)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupStackView() {
        axis = .horizontal
        spacing = 6
        alignment = .center
        distribution = .fill
        
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.snp.makeConstraints { make in
            make.size.equalTo(25)
        }
        
        textLabel.font = .offroad(style: .iosBoxMedi)
        textLabel.textColor = .grayscale(.gray400)
        textLabel.numberOfLines = 0
        textLabel.textAlignment = .left
        textLabel.lineBreakMode = .byWordWrapping
        
        addArrangedSubview(iconImageView)
        addArrangedSubview(textLabel)
    }
    
    func configure(icon: UIImage?, text: String) {
        iconImageView.image = icon
        textLabel.text = text
    }
}
