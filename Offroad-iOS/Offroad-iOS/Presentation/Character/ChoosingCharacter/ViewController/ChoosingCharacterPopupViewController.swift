//
//  ChoosingCharacterPopupViewController.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 7/17/24.
//

import UIKit

final class ChoosingCharacterPopupViewController: UIViewController {
    
    //MARK: - Properties
    
    private let rootView = ChoosingCharacterPopupView()
    
    private var myCharacterName = String()
    private var myCharacterID = Int()
    private var myCharacterImage = String() {
        didSet {
            UserDefaults.standard.set(true, forKey: "isLoggedIn")
            let completeChoosingCharacterViewController = CompleteChoosingCharacterViewController(characterImage: myCharacterImage)
            completeChoosingCharacterViewController.modalTransitionStyle = .crossDissolve
            completeChoosingCharacterViewController.modalPresentationStyle = .fullScreen
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4){
                self.present(completeChoosingCharacterViewController, animated: true)
            }
        }
    }
        
    // MARK: - Life Cycle
    
    init(characterName: String, characterID: Int) {
        myCharacterName = characterName
        myCharacterID = characterID
        
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
        
        setupTarget()
        rootView.setCharacterName(name: myCharacterName)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        rootView.presentPopupView()
    }
}

extension ChoosingCharacterPopupViewController {
    
    // MARK: - Private Func
    
    private func setupTarget() {
        rootView.setupNoButton(action: noButtonTapped)
        rootView.setupYesButton(action: yesButtonTapped)
    }
    
    private func noButtonTapped() {
        print("noButtonTapped")
        
        rootView.dismissPopupView()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4){
            self.dismiss(animated: false)
        }
    }
    
    private func yesButtonTapped() {
        print("yesButtonTapped")
        
        postCharacterID()
        rootView.dismissPopupView()
    }
    
    private func postCharacterID() {
        NetworkService.shared.characterService.postChoosingCharacter(parameter: myCharacterID) { response in
            switch response {
            case .success(let data):
                
                self.myCharacterImage = data?.data.characterImageUrl ?? ""
            default:
                break
            }
        }
    }
}
