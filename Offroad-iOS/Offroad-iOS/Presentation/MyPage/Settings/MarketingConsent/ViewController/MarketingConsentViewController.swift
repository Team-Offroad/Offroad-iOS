//
//  MarketingConsentViewController.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 9/6/24.
//

import UIKit

final class MarketingConsentViewController: UIViewController {
    
    //MARK: - Properties
    
    private let rootView = TermsConsentPopupView()
        
    private let marketingConsentDetailModel = TermsDetailModel.getTermsDetailModel()[3]
    
    // MARK: - Life Cycle
    
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rootView.configurePopupView(titleString: marketingConsentDetailModel.titleString,
                                    descriptionString: marketingConsentDetailModel.descriptionString,
                                    contentString: marketingConsentDetailModel.contentString)
        setupAddTarget()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        rootView.presentPopupView()
    }
}

extension MarketingConsentViewController {
    
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
