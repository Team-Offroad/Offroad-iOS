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
    
    private var toastWindow: ORBToastWindow? = nil
    
    //MARK: - Life Cycle
    
    private init() { }
    
    func showToast(message: String) {
        toastWindow = ORBToastWindow(message: message)
        toastWindow?.hideAnimator.addCompletion({ [weak self] _ in
            guard let self else { return }
            toastWindow = nil
        })
        toastWindow?.showToast()
    }
    
    func hideToast() {
        toastWindow?.hideToast()
    }
    
}
