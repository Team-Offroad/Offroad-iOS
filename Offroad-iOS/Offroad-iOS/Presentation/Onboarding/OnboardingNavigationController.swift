//
//  OnboardingNavigationController.swift
//  Offroad-iOS
//
//  Created by 김민성 on 12/1/24.
//

import UIKit

class OnboardingNavigationController: UINavigationController {
    
    enum Gender: String {
        case male = "MALE"
        case female = "FEMALE"
        case other = "OTHER"
    }
    
    // 온보딩 시 입력 정보
    var nickname: String? = nil
    var year: Int? = nil
    var month: Int? = nil
    var day: Int? = nil
    var gender: Gender? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.isHidden = true
    }

}
