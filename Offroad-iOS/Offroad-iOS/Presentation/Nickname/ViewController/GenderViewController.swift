//
//  GenderViewController.swift
//  Offroad-iOS
//
//  Created by  정지원 on 7/10/24.
//

import UIKit

import SnapKit
import Then

final class GenderViewController: UIViewController {
    
    //MARK: - Properties
    
    private let genderView = GenderView()
    
    //MARK: - Life Cycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init(birthYear: String, birthMonth: String, birthDay: String) {
        self.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = genderView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAddTarget()
    }
    
    private func presentToNextVC() {
        let choosingCharacterViewController = ChoosingCharacterViewController()
        
        present(UINavigationController(rootViewController: choosingCharacterViewController), animated: true)
    }
    
    //MARK: - Private Method
    
    private func setupAddTarget() {
        genderView.maleButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        genderView.femaleButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        genderView.etcButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
    }
}

extension GenderViewController {
    
    //MARK: - @objc Method
    @objc func buttonTapped(_ sender: UIButton) {
        
        [genderView.maleButton, genderView.femaleButton, genderView.etcButton].forEach { button in
            if button == sender {
                button.isSelected.toggle()
                button.layer.borderColor = button.isSelected ? UIColor.sub(.sub).cgColor : UIColor.grayscale(.gray100).cgColor
            } else {
                button.isSelected = false
                button.layer.borderColor = UIColor.grayscale(.gray100).cgColor
            }
        }
    }
}


