//
//  OFRAlertButton.swift
//  Offroad-iOS
//
//  Created by 김민성 on 9/12/24.
//

import UIKit

class OFRAlertButton: UIButton {
    
    //MARK: - Properties
    
    var primaryAction: OFRAlertAction? {
        didSet {
            guard let primaryAction else { return }
            setTitle(primaryAction.title, for: .normal)
            setupStyle(of: primaryAction.style)
        }
    }
    
    //MARK: - UI Properties
    
    //MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //setupStyle()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(primaryAction: OFRAlertAction) {
        
        /*
         생성자 내에서 primaryAction에 값을 할당하는 경우, didSet이 호출되지 않음.
         이 문제를 해결하기 위해서 생성자 내에서 defer()을 호출하여 값이 할당될 때 didSet이 호출되도록 임시 조치하였음.
         추후 RxSwift를 이용하여 해결할 수 있으면 리팩토링하기
         */
        defer {
            self.primaryAction = primaryAction
        }
        
        self.init()
    }
}

extension OFRAlertButton {
    
    //MARK: - Layout
    
    private func setupLayout() {
        self.snp.makeConstraints { make in
            make.height.equalTo(44)
        }
    }
    
    //MARK: - @objc Func
    
    //MARK: - Private Func
    
    private func setupStyle() {
        setupStyle(of: .default)
    }
    
    private func setupHierarchy() {
        
    }
    
    private func setupStyle(of style: OFRAlertAction.Style) {
        
        roundCorners(cornerRadius: 5)
        
        titleLabel?.font = .offroad(style: .iosBtnSmall)
        switch style {
        case .default:
            backgroundColor = .main(.main2)
            setTitleColor(.primary(.white), for: .normal)
            
        case .cancel:
            backgroundColor = .main(.main3)
            setTitleColor(.main(.main2), for: .normal)
            layer.borderColor = UIColor.main(.main2).cgColor
            layer.borderWidth = 1
            clipsToBounds = true
            
        case .destructive:
            backgroundColor = .main(.main3)
            setTitleColor(.main(.main2), for: .normal)
            layer.borderColor = UIColor.main(.main2).cgColor
            layer.borderWidth = 1
            clipsToBounds = true
        }
    }
    
    //MARK: - Func
    
}
