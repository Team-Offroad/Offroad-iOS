//
//  PlaceInfoViewController.swift
//  Offroad-iOS
//
//  Created by 김민성 on 10/27/24.
//

import UIKit

class PlaceInfoViewController: UIViewController {
    
    let rootView = PlaceInfoView()
    
    
    
    var isTooptipShown: Bool {
        get { rootView.isTooptipShown }
        set { rootView.isTooptipShown = newValue }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
}

extension PlaceInfoViewController {
    
    //MARK: - Func
    
    
    
}
