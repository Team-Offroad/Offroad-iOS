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
    private var nickname: String = ""
    private var birthYear: Int?
    private var birthMonth: Int?
    private var birthDay: Int?
    
    //MARK: - Life Cycle
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init(nickname: String, birthYear: String?, birthMonth: String?, birthDay: String?) {
        self.init(nibName: nil, bundle: nil)
        
        self.nickname = nickname
        self.birthYear = birthYear.flatMap { Int($0) }
        self.birthMonth = birthMonth.flatMap { Int($0) }
        self.birthDay = birthDay.flatMap { Int($0) }
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
        
        self.modalPresentationStyle = .fullScreen
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
        genderView.nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: genderView.skipButton)
        genderView.skipButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
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
    
    @objc func nextButtonTapped() {
        let gender: String?
        if genderView.maleButton.isSelected {
            gender = "MALE"
        } else if genderView.femaleButton.isSelected {
            gender = "FEMALE"
        } else if genderView.etcButton.isSelected {
            gender = "OTHER"
        }
        else {
            gender = nil
        }
        
        ProfileService().updateProfile(body: ProfileUpdateRequestDTO(nickname: nickname, year: birthYear, month: birthMonth, day: birthDay, gender: gender)) { result in
            switch result {
            case .success(let response):
                print("프로필 업데이트 성공~~~~~~~~~")
                
                let choosingCharacterViewController = ChoosingCharacterViewController()
                self.navigationController?.pushViewController(choosingCharacterViewController, animated: true)
            default:
                return
            }
        }
    }
}


