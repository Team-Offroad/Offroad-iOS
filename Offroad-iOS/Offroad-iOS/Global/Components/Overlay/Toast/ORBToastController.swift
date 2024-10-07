//
//  ORBToastController.swift
//  Offroad-iOS
//
//  Created by 김민성 on 10/7/24.
//

import UIKit

class ORBToastController: ORBOverlayViewController {
    
    let backgroundView = ORBToastBackgroundView()
    
    override func loadView() {
        view = backgroundView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    
}
