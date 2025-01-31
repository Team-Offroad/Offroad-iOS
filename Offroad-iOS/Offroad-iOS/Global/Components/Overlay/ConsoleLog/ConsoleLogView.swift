//
//  ConsoleLogView.swift
//  ORB(Dev)
//
//  Created by 김민성 on 1/31/25.
//

import UIKit

class ConsoleLogView: UIView {
    
//    let floatingButton = ShrinkableButton(shrinkScale: 0.9)
    let floatingButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupStyle()
        setupHierarchy()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension ConsoleLogView {
    
    // MARK: - Layout Func
    
    private func setupStyle() {
        floatingButton.do { button in
            button.setTitle("🛠️", for: .normal)
            button.backgroundColor = UIColor.black.withAlphaComponent(0.7)
            button.setTitleColor(.white, for: .normal)
            button.roundCorners(cornerRadius: 30)
            button.frame = CGRect(x: 20, y: 100, width: 60, height: 60)
        }
    }
    
    // MARK: - Private Func
    
    private func setupHierarchy() {
        addSubview(floatingButton)
    }    
    
}
