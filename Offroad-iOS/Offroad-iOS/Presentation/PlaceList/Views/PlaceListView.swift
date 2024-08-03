//
//  PlaceListView.swift
//  Offroad-iOS
//
//  Created by 김민성 on 8/3/24.
//

import UIKit

class PlaceListView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension PlaceListView {
    
    private func setupStyle() {
        backgroundColor = UIColor(hexCode: "F6EEDF")
        
    }
    
}
