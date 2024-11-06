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
    
    func showToast(message: String, inset: CGFloat, withImage image: UIImage? = nil) {
        toastWindow?.hideAnimator.stopAnimation(true)
        toastWindow = nil
        DispatchQueue.main.async {
            self.toastWindow = ORBToastWindow(message: message, inset: inset, withImage: image)
            self.toastWindow?.hideAnimator.addCompletion({ [weak self] _ in
                guard let self else { return }
                self.toastWindow = nil
            })
            self.toastWindow?.showToast()
        }
    }
    
    func hideToast() {
        self.toastWindow?.hideToast()
    }
    
}
