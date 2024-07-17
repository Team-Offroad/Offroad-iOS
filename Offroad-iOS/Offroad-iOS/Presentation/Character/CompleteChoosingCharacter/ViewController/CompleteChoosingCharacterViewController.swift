//
//  CompleteChoosingCharacterViewController.swift
//  Offroad-iOS
//
//  Created by  정지원 on 7/15/24.
//

import UIKit

import SnapKit
import Then

final class CompleteChoosingCharacterViewController: UIViewController {
    
    //MARK: - Properties
    
    private let completeChoosingCharacterView = CompleteChoosingCharacterView()
    
    private var myCharacterImage = String()
    
    //MARK: - Life Cycle
    
    init(characterImage: String) {
        myCharacterImage = characterImage
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = completeChoosingCharacterView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTarget()
        completeChoosingCharacterView.setCharacterImage(imageURL: myCharacterImage)
    }
}

extension CompleteChoosingCharacterViewController {
    
    //MARK: - Private Func
    
    private func setupTarget() {
        completeChoosingCharacterView.startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
    }
    
    //MARK: - @objc Func
    
    @objc private func startButtonTapped() {
        let offroadTabBarController = OffroadTabBarController()
        offroadTabBarController.modalTransitionStyle = .crossDissolve
        offroadTabBarController.modalPresentationStyle = .fullScreen
        
        self.present(offroadTabBarController, animated: true)
    }
}

