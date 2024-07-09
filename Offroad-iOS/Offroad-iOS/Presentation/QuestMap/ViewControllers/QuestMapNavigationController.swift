//
//  QuestMapNavigationController.swift
//  Offroad-iOS
//
//  Created by 김민성 on 2024/07/07.
//

import UIKit

import SnapKit
import Then

class QuestMapNavigationController: UINavigationController {
    
    //MARK: - UI Properties
    
    private let customNavigationBar = UIView()
    private let customNavigationBarShadowLine = UIView()
    private let navigationTitleLabel = UILabel()
    
    
    //MARK: - LifeCycle
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        rootViewController.additionalSafeAreaInsets.top = 76 - navigationBar.frame.height
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupHierarchy()
        setupStyle()
        setupLayout()
        setNavigationBarAppearance()
    }
    
}


extension QuestMapNavigationController {
    
    private func setupHierarchy() {
        navigationBar.addSubview(customNavigationBar)
        customNavigationBar.addSubviews(navigationTitleLabel, customNavigationBarShadowLine)
    }
    
    private func setupStyle() {
        customNavigationBar.do { view in
            //view.clipsToBounds = false
            view.backgroundColor = .main(.main1)
        }
        
        customNavigationBarShadowLine.do { view in
            view.backgroundColor = .blackOpacity(.black25)
        }
        
        navigationTitleLabel.do { label in
            label.text = "어디를 탐험해 볼까요?"
            label.font = .offroad(style: .iosSubtitle2Bold)
            label.textAlignment = .left
        }
    }
    
    private func setupLayout() {
        customNavigationBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(76)
        }
        
        customNavigationBarShadowLine.snp.makeConstraints { make in
            make.top.equalTo(customNavigationBar.snp.bottom)
            make.horizontalEdges.equalTo(customNavigationBar)
            make.height.equalTo(1)
        }
        
        navigationTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(26.41)
            make.bottom.equalToSuperview().inset(25.59)
            make.leading.equalToSuperview().inset(24)
        }
    }
    
    private func setNavigationBarAppearance() {
        navigationBar.scrollEdgeAppearance = UINavigationBarAppearance().then {
            $0.backgroundColor = .main(.main1)
        }
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        viewController.additionalSafeAreaInsets.top = 76 - navigationBar.frame.height
        super.pushViewController(viewController, animated: animated)
    }
    
}
