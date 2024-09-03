//
//  LogoutViewController.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 9/3/24.
//

import UIKit

final class LogoutViewController: UIViewController {
    
    //MARK: - Properties
    
    private let rootView = LogoutView()
    
    // MARK: - Life Cycle
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
