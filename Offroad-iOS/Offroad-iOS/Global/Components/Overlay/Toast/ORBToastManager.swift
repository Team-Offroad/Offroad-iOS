//
//  ORBToastManager.swift
//  Offroad-iOS
//
//  Created by 김민성 on 10/12/24.
//

import UIKit

final class ORBToastManager {
    
    //MARK: - Type Properties
    
    static var shared = ORBToastManager()
    
    //MARK: - Properties
    
    var toastWindow: ORBToastWindow? = nil
    
    //MARK: - Life Cycle
    
    private init() { }
    
    func showToast(message: String) {
        toastWindow = ORBToastWindow(windowScene: UIWindow.current.windowScene!)
        toastWindow?.hideAnimator.addCompletion({ [weak self] _ in
            guard let self else { return }
            toastWindow = nil
        })
        toastWindow?.showToast()
    }
    
}
