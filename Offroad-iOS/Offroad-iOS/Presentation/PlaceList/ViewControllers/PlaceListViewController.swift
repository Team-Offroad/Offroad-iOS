//
//  PlaceListViewController.swift
//  Offroad-iOS
//
//  Created by 김민성 on 8/3/24.
//

import UIKit

class PlaceListViewController: UIViewController {
    
    let rootView = PlaceListView()
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupStyle()
        setupNavigationBar()
        setNavigationController()
        setupNavigationControllerGesture()
        setupButtonsActions()
        setupDelegates()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        rootView.customSegmentedControl.selectSegment(index: 0)
        
        let questMapNavigationController = navigationController as! QuestMapNavigationController
        questMapNavigationController.setCustomAppearance(state: .questQR)
        questMapNavigationController.navigationBar.isHidden = true
        
        guard let offroadTabBarController = self.tabBarController as? OffroadTabBarController else { return }
        offroadTabBarController.hideTabBarAnimation()
    }
    
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        
//        guard let offroadTabBarController = self.tabBarController as? OffroadTabBarController else { return }
//        offroadTabBarController.showTabBarAnimation()
//    }
    
    
    
}


extension PlaceListViewController {
    
    private func setupStyle() {
//        hidesBottomBarWhenPushed = true
    }
    
    private func setupNavigationBar() {
//        self.navigationController?.navigationBar.isHidden = true
    }
    
    private func setNavigationController() {
        self.navigationItem.setHidesBackButton(true, animated: false)
    }
    
    private func setupNavigationControllerGesture() {
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    private func setupButtonsActions() {
        rootView.customBackButton.addTarget(self, action: #selector(customBackButtonTapped), for: .touchUpInside)
    }
    
    @objc private func customBackButtonTapped() {
        print(#function)
        navigationController?.popViewController(animated: true)
    }
    
    private func setupDelegates() {
        rootView.customSegmentedControl.delegate = self
    }
    
}


//MARK: - UIGestureRecognizerDelegate

extension PlaceListViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        print(#function)
        
        // Navigation stack에서 root view controller가 아닌 경우에만 pop 제스처를 허용
        return navigationController!.viewControllers.count > 1
    }
    
}

//MARK: - PlaceListSegmentedControlDelegate

extension PlaceListViewController: PlaceListSegmentedControlDelegate {
    
    func segmentedControlDidSelected(segmentedControl: PlaceListSegmentedControl, selectedIndex: Int) {
        print("\(selectedIndex) 선택됨")
    }
    
}
