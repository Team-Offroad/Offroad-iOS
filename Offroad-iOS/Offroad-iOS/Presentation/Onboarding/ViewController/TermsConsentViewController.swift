//
//  TermsConsentViewController.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 8/23/24.
//

import UIKit

final class TermsConsentViewController: UIViewController {
    
    //MARK: - Properties
    
    private let rootView = TermsConsentView()
    
    // MARK: - Life Cycle
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
