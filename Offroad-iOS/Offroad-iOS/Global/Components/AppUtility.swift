//
//  AppUtility.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 11/9/24.
//

import UIKit

final class AppUtility {
    static let shared = AppUtility()
        
    private init() {}
    
    static func changeRootViewController(to viewController: UIViewController) {
        let window = UIWindow.current
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            UIView.transition(with: window, duration: 1.0, options: .transitionCrossDissolve, animations: {
                window.rootViewController = viewController
            }, completion: nil)
            
            window.makeKeyAndVisible()
        }
    }
}
