//
//  QuestMapListButton.swift
//  Offroad-iOS
//
//  Created by 김민성 on 2024/07/10.
//

import UIKit

import SnapKit
import Then

class ORBMapListButton: ShrinkableButton {
    
    //MARK: - Life Cycle
    
    convenience init(image: UIImage, title: String) {
        self.init(shrinkScale: 0.95)
        let transformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont.offroad(style: .iosBtnSmall)
            outgoing.foregroundColor = UIColor.primary(.white)
            return outgoing
        }
        var filledConfiguration = UIButton.Configuration.filled()
        filledConfiguration.titleTextAttributesTransformer = transformer
        filledConfiguration.image = image
        filledConfiguration.title = title
        filledConfiguration.baseBackgroundColor = .main(.main2)
        filledConfiguration.contentInsets = .init(top: 9, leading: 11, bottom: 9, trailing: 11)
        filledConfiguration.imagePadding = 10
        self.configuration = filledConfiguration
    }
    
}
