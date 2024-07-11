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
    
    //MARK: - Properties
    
    
    //MARK: - UI Properties
    
    let customNavigationBar = QuestNavigationBar()
    let customStatusBarBackgorund = UIView()
    let customNavigationBarShadowLine = UIView()
    

    
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
        setupAppearanceToTransparent()
        customNavigationBar.changeState(to: .questMap)
        self.delegate = self
    }
    
}


extension QuestMapNavigationController {
    
    private func setupHierarchy() {
        navigationBar.addSubview(customNavigationBar)
        customNavigationBar.addSubviews(
            //navigationTitleLabel,
            customNavigationBarShadowLine,
            customStatusBarBackgorund
        )
    }
    
    private func setupStyle() {
//        guard let sceneDelegate = UIApplication.shared.delegate as? SceneDelegate else { fatalError() }
//        sceneDelegate.window?.backgroundColor = .main(.main1)
        
        customNavigationBar.do { view in
            //view.clipsToBounds = false
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
    
    private func setNavigationBarAppearance() {
        navigationBar.scrollEdgeAppearance = UINavigationBarAppearance().then {
            $0.backgroundColor = .main(.main1)
        }
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        viewController.additionalSafeAreaInsets.top = 76 - navigationBar.frame.height
        super.pushViewController(viewController, animated: animated)
    }
    
    
    func setupAppearanceToTransparent() {
        let appearance = UINavigationBarAppearance().then { appearance in
            //appearance.backgroundColor = .clear
            appearance.configureWithTransparentBackground()
        }
        
        //navigationController?.navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
    }
    
    func setupAppearanceToOpaque() {
        print(#function)
        let appearance = UINavigationBarAppearance().then { appearance in
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .main(.main1)
        }
        
        navigationBar.scrollEdgeAppearance = appearance
        navigationBar.standardAppearance = appearance
        navigationBar.compactAppearance = appearance
        navigationBar.compactScrollEdgeAppearance = appearance
    }
    
    
    
}




extension QuestMapNavigationController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        self.interactivePopGestureRecognizer?.isEnabled = viewControllers.count > 1
    }
    
}
