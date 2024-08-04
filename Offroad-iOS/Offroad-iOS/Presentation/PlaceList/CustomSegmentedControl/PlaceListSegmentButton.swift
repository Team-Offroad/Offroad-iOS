//
//  PlaceListSegmentButton.swift
//  Offroad-iOS
//
//  Created by 김민성 on 8/3/24.
//

import UIKit

final class PlaceListSegmentButton: UIButton {
    
    //MARK: - Properties
    
    //버튼 선택 시 글자 색 변경
    override var isSelected: Bool {
        didSet {
            let textWeight: PretendardFontWeight = isSelected ? .bold : .medium
            let textColor: UIColor = isSelected ? .main(.main2) : .grayscale(.gray300)
            // 추후 FontLiteral 만들어서 변경 요망
            self.titleLabel?.font = .pretendardFont(ofSize: 18, weight: textWeight)
            self.setTitleColor(textColor, for: .normal)
        }
    }
    
    //MARK: - Life Cycle
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.titleLabel?.font = UIFont.pretendardFont(ofSize: 18, weight: .medium)
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
