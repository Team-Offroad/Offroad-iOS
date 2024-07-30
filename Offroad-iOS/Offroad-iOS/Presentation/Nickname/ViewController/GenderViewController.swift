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
    
    private func updateNextButtonState() {
        let isGenderSelected = genderView.maleButton.isSelected || genderView.femaleButton.isSelected || genderView.etcButton.isSelected
        genderView.nextButton.changeState(forState: isGenderSelected ? .isEnabled : .isDisabled)
    }
}

extension GenderViewController {
    
    //MARK: - @objc Method
    @objc func buttonTapped(_ sender: UIButton) {
        
        [genderView.maleButton, genderView.femaleButton, genderView.etcButton].forEach { button in
            if button == sender {
                button.isSelected.toggle()
                button.layer.borderColor = button.isSelected ? UIColor.sub(.sub).cgColor : UIColor.grayscale(.gray100).cgColor
                genderView.nextButton.changeState(forState: .isEnabled)
            } else {
                button.isSelected = false
                button.layer.borderColor = UIColor.grayscale(.gray100).cgColor
            }
        }
        updateNextButtonState()
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
        
        let button = UIButton().then { button in
            button.setImage(.backBarButton, for: .normal)
            button.addTarget(self, action: #selector(executePop), for: .touchUpInside)
            button.imageView?.contentMode = .scaleAspectFill
            button.snp.makeConstraints { make in
                make.width.equalTo(30)
                make.height.equalTo(44)
            }
        }
        
        
        ProfileService().updateProfile(body: ProfileUpdateRequestDTO(nickname: nickname, year: birthYear, month: birthMonth, day: birthDay, gender: gender)) { result in
            switch result {
            case .success(let response):
                print("프로필 업데이트 성공~~~~~~~~~")
                
                let choosingCharacterViewController = ChoosingCharacterViewController()
                let customBackBarButton = UIBarButtonItem(customView: button)
                choosingCharacterViewController.navigationItem.leftBarButtonItem = customBackBarButton
                self.navigationController?.pushViewController(choosingCharacterViewController, animated: true)
            default:
                return
            }
        }
    }
    
    @objc private func executePop() {
        navigationController?.popViewController(animated: true)
    }
}


