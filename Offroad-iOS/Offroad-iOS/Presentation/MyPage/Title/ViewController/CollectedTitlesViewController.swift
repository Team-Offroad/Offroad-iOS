//
//  CollectedTitlesViewController.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 8/5/24.
//

import UIKit

final class CollectedTitlesViewController: UIViewController {
    
    //MARK: - Properties
    
    private let rootView = CollectedTitlesView()
    
    // MARK: - Life Cycle
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTarget()
    }
}

extension CollectedTitlesViewController {
    
    // MARK: - Private Method
    
    private func setupTarget() {
    }
}
