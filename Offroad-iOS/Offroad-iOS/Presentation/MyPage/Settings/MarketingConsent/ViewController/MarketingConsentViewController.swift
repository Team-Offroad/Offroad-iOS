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
    
    private func patchMarketingConsent(isAgreed: MarketingConsentRequestDTO) {
        NetworkService.shared.profileService.patchMarketingConsent(body: isAgreed) { response in
            switch response {
            case .success(let data):
                print("마케팅 수신 여부 변경 성공!\n요청 성공 값: \(isAgreed.marketing)")
            default:
                break
            }
        }
    }
    
    //MARK: - @Objc Func
    
    @objc private func agreeButtonTapped() {
        patchMarketingConsent(isAgreed: MarketingConsentRequestDTO(marketing: true))
        
        rootView.dismissPopupView()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4){
            self.dismiss(animated: false)
        }
    }
    
    @objc private func disagreeButtonTapped() {
        patchMarketingConsent(isAgreed: MarketingConsentRequestDTO(marketing: false))
        
        rootView.dismissPopupView()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4){
            self.dismiss(animated: false)
        }
    }
}
