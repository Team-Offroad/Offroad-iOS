//
//  TermsConsentPopupViewController.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 9/1/24.
//

import UIKit

final class TermsConsentPopupViewController: UIViewController {
    
    //MARK: - Properties
    
    private let rootView = TermsConsentPopupView()
    
    private let popupTitleString: String
    private let popupDescriptionString: String
    private let popupContentString: String
    
    // MARK: - Life Cycle
    
    init(titleString: String, descriptionString: String, contentString: String) {
        popupTitleString = titleString
        popupDescriptionString = descriptionString
        popupContentString = contentString
        
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
        
        rootView.configurePopupView(titleString: popupTitleString, descriptionString: popupDescriptionString, contentString: popupContentString)
        setupAddTarget()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        rootView.presentPopupView()
    }
}

extension TermsConsentPopupViewController {
    
    //MARK: - Private Func
    
    private func setupAddTarget() {
        rootView.agreeButton.addTarget(self, action: #selector(agreeButtonTapped), for: .touchUpInside)
        rootView.disagreeButton.addTarget(self, action: #selector(disagreeButtonTapped), for: .touchUpInside)
    }
    
    //MARK: - @Objc Func
    
    @objc private func agreeButtonTapped() {
        rootView.dismissPopupView()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4){
            self.dismiss(animated: false)
        }
    }
    
    @objc private func disagreeButtonTapped() {
        rootView.dismissPopupView()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4){
            self.dismiss(animated: false)
        }
    }
}
