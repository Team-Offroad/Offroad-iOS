//
//  ORBRecommendationMainViewController.swift
//  ORB_Dev
//
//  Created by 김민성 on 4/20/25.
//

import UIKit

import RxSwift
import RxCocoa

final class ORBRecommendationMainViewController: UIViewController {
    
    // MARK: - Properties
    
    private let rootView = ORBRecommendationMainView()
    private var disposeBag = DisposeBag()
    
    // MARK: - Life Cycle
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupButtonActions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let offroadTabBarController = self.tabBarController as? OffroadTabBarController else { return }
        offroadTabBarController.hideTabBarAnimation()
    }
    
    private func setupButtonActions() {
        rootView.backButton.rx.tap.subscribe { _ in
            self.navigationController?.popViewController(animated: true)
        }.disposed(by: disposeBag)
        
        rootView.orbMessageButton.rx.tap.subscribe { [weak self] _ in
            guard let self else { return }
            let chatViewController = ORBRecommendationChatViewController(
                firstChatText: self.rootView.orbMessageButton.message
            )
            chatViewController.view.layoutIfNeeded()
            chatViewController.transitioningDelegate = self
            chatViewController.modalPresentationStyle = .custom
            self.present(chatViewController, animated: true)
            
            // 2안을 선택할 경우 다음 코드 적용
            //self.navigationController?.pushViewController(ORBRecommendationOrderViewController(), animated: true)
        }.disposed(by: disposeBag)
    }
    
}


// Custom Transition 관련
extension ORBRecommendationMainViewController {
    
    /// present 트랜지션이 시작할 때 버튼을 숨기기
    func hideORBMessageButtonBeforePresent() {
        rootView.orbMessageButton.isHidden = true
    }
    
    /// dismiss 트랜지션이 시작할 때 버튼 보이기
    func showORBMessageButtonBeformDismiss() {
        rootView.orbMessageButton.isHidden = false
    }
    
}


extension ORBRecommendationMainViewController: UIViewControllerTransitioningDelegate {
    
    func presentationController(
        forPresented presented: UIViewController,
        presenting: UIViewController?,
        source: UIViewController
    ) -> UIPresentationController? {
        guard let chatViewController = presented as? ORBRecommendationChatViewController,
              let mainViewController = source as? ORBRecommendationMainViewController
        else {
            fatalError()
        }
        return ORBRecommendationViewPresentationController(
            presentedViewController: chatViewController,
            presenting: presenting,
            sourceViewController: mainViewController
        )
    }
    
    func animationController(
        forPresented presented: UIViewController,
        presenting: UIViewController,
        source: UIViewController
    ) -> (any UIViewControllerAnimatedTransitioning)? {
        return ORBRecommendationChatViewPresentingTransition(
            buttonFrame: rootView.orbMessageButton.frame,
            buttonText: rootView.orbMessageButton.message
        )
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> (any UIViewControllerAnimatedTransitioning)? {
        return ORBRecommendationChatViewDismissingTransition()
    }
    
}
