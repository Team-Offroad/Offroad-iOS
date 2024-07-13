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
    
    private let customNavigationBar = QuestNavigationBar()
    private let customStatusBarBackgorund = UIView()
    private let customNavigationBarShadowLine = UIView()
    
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
        setInitialNavigationBarState()
        setupButtonsAction()
    }
    
}


extension QuestMapNavigationController {
    
    //MARK: - @objc Func
    @objc private func popByCustomBackButton() {
        popViewController(animated: true)
    }
    
    //MARK: - Private Func
    
    private func setupHierarchy() {
        navigationBar.addSubviews(
            customNavigationBar,
            customNavigationBarShadowLine,
            customStatusBarBackgorund
        )
    }
    
    private func setupStyle() {
        customNavigationBar.do { view in
            view.backgroundColor = .main(.main1)
        }
        
        customStatusBarBackgorund.do { view in
            view.backgroundColor = .main(.main1)
        }
        
        customNavigationBarShadowLine.do { view in
            view.backgroundColor = .blackOpacity(.black25)
        }
    }
    
    private func setupLayout() {
        customNavigationBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(76)
        }
        
        customStatusBarBackgorund.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view)
            make.bottom.equalTo(customNavigationBar.snp.top)
        }
        
        customNavigationBarShadowLine.snp.makeConstraints { make in
            make.top.equalTo(customNavigationBar.snp.bottom)
            make.horizontalEdges.equalTo(customNavigationBar)
            make.height.equalTo(1)
        }
    }
    
    private func setInitialNavigationBarState() {
        let appearance = UINavigationBarAppearance().then { appearance in
            appearance.configureWithTransparentBackground()
        }
        navigationBar.scrollEdgeAppearance = appearance
        customNavigationBar.changeState(to: .questMap)
    }
    
    private func setupButtonsAction() {
        customNavigationBar.customBackButton.addTarget(self, action: #selector(popByCustomBackButton), for: .touchUpInside)
    }
    
    //MARK: - Func
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)
        
        viewController.additionalSafeAreaInsets.top = 76 - navigationBar.frame.height
    }
    
    func setCustomAppearance(state: QuestNavigationView) {
        switch state {
        case .questMap:
            customStatusBarBackgorund.backgroundColor = .main(.main1)
            customNavigationBarShadowLine.backgroundColor = .blackOpacity(.black25)
            customNavigationBar.changeState(to: .questMap)
        case .questQR:
            customStatusBarBackgorund.backgroundColor = .clear
            customNavigationBarShadowLine.backgroundColor = .clear
            customNavigationBar.changeState(to: .questQR)
        }
    }
    
    
    
}
