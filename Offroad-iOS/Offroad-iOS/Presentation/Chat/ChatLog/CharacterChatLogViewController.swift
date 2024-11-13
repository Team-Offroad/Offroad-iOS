//
//  CharacterChatLogViewController.swift
//  Offroad-iOS
//
//  Created by 김민성 on 11/12/24.
//

import UIKit

class CharacterChatLogViewController: UIViewController {
    
    let rootView: CharacterChatLogView
    
    init(background: UIView) {
        rootView = CharacterChatLogView(background: background)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        setupDelegates()
        setupTargets()
//        setupGestures()
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let tabBarController = tabBarController as? OffroadTabBarController else { return }
        tabBarController.showTabBarAnimation()
        rootView.backgroundView.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        rootView.backgroundView.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        rootView.backgroundView.isHidden = true
    }
    
}

extension CharacterChatLogViewController {
    
    //MARK: - @objc Func
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Private Func
    
//    private func setupDelegates() {
//        navigationController?.delegate = self
//    }
    
    private func setupTargets() {
        rootView.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
//    private func setupGestures() {
//        
//        let edgePanGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
//        edgePanGesture.edges = .left
//        navigationController?.view.addGestureRecognizer(edgePanGesture)
//        
//    }
    
    
}

//extension CharacterChatLogViewController: UINavigationControllerDelegate {
//    
//    func navigationController(
//        _ navigationController: UINavigationController,
//        animationControllerFor operation: UINavigationController.Operation,
//        from fromVC: UIViewController,
//        to toVC: UIViewController
//    ) -> (any UIViewControllerAnimatedTransitioning)? {
//        if operation == .push && toVC is CharacterChatLogViewController {
//            return ChatLogPushAnimator()
//        } else if operation == .pop && fromVC is CharacterChatLogViewController {
//            return ChatLogPopAnimator()
//        }
//        return nil
//    }
//    
//    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: any UIViewControllerAnimatedTransitioning) -> (any UIViewControllerInteractiveTransitioning)? {
//        return interactionController
//    }
//    
//}
