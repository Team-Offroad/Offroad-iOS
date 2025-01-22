//
//  CustomListSegmentButton.swift
//  Offroad-iOS
//
//  Created by 김민성 on 8/3/24.
//

import UIKit

final class ORBSegmentedControlButton: ShrinkableButton {
    
    //MARK: - Life Cycle
    
    private override init(frame: CGRect) {
        super.init(shrinkScale: 0.9)
        
        setupStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(title: String, tag: Int) {
        self.init(frame: .zero)
        self.setTitle(title, for: .normal)
        self.tag = tag
    }
    
}

extension ORBSegmentedControlButton {
    
    //MARK: - Private Func
    
    private func setupStyle() {
        
        roundCorners(cornerRadius: 10)
        
        configureBackgroundColorWhen(
            normal: .clear,
            highlighted: .primary(.black).withAlphaComponent(0.08),
            highlightedAndSelected: .clear
        )
        
        let transformer = UIConfigurationTextAttributesTransformer { [weak self] incoming in
            guard let self else { return incoming }
            var outgoing = incoming
            
            switch self.state {
            case .selected, .init(rawValue: 5):
                outgoing.foregroundColor = .main(.main2)
                outgoing.font = .offroad(style: .iosTooltipTitle)
            default:
                outgoing.foregroundColor = .grayscale(.gray300)
                outgoing.font = .offroad(style: .iosTabbarMedi)
            }
            return outgoing
        }
        
        configuration?.titleTextAttributesTransformer = transformer
    }
    
}
