//
//  ORBRecommendationOrderViewController.swift
//  ORB_Dev
//
//  Created by 김민성 on 5/1/25.
//

import UIKit

import RxSwift
import RxCocoa

final class ORBRecommendationOrderViewController: UIViewController {
    
    // MARK: - Properties
    
    let rootView = ORBRecommendationOrderView()
    
    // MARK: - Life Cycle
    
    override func loadView() {
        view  = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rootView.backButton.addTarget(self, action: #selector(confirmExit), for: .touchUpInside)
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let tabBarController  = tabBarController as? OffroadTabBarController else { return }
        tabBarController.hideTabBarAnimation()
    }
    
}

private extension ORBRecommendationOrderViewController {
    
    @objc func confirmExit() {
        let popupViewController = ORBAlertController(
            title: "",
            message: AlertMessage.orbRecommendationOrderUnsavedExitMessage,
            type: .messageOnly
        )
        let cancelAction = ORBAlertAction(title: "취소", style: .cancel, handler: { _ in return })
        let okAction = ORBAlertAction(title: "확인", style: .default, handler: { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        })
        popupViewController.addAction(cancelAction)
        popupViewController.addAction(okAction)
        popupViewController.xButton.isHidden = true
        self.present(popupViewController, animated: true)
    }
    
}

// MARK: - UIGestureRecognizerDelegate

extension ORBRecommendationOrderViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        confirmExit()
        return false
    }
    
}
