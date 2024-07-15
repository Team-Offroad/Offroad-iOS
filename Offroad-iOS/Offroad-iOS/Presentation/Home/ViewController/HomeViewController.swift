//
//  HomeViewController.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 7/9/24.
//

import UIKit

final class HomeViewController: OffroadTabBarViewController {
    
    //MARK: - Properties
    
    private let rootView = HomeView()
    
    // MARK: - Life Cycle
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTarget()
    }
}

extension HomeViewController {
    
    // MARK: - Private Method
    
    private func setupTarget() {
        rootView.setupChangeTitleButton(action: changeTitleButtonTapped)
    }
    
    private func changeTitleButtonTapped() {
        print("changeTitleButtonTapped")
        
        let titlePopupViewController = TitlePopupViewController()
        titlePopupViewController.modalPresentationStyle = .overCurrentContext
        titlePopupViewController.delegate = self
        
        present(titlePopupViewController, animated: false)
    }
}

extension HomeViewController: selectedTitleProtocol {
    func fetchTitleString(titleString: String) {
        rootView.changeMyTitleLabelText(text: titleString)
    }
}
