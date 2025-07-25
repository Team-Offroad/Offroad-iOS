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
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.toastWindow?.hideAnimator.stopAnimation(true)
            self.toastWindow = nil
            self.toastWindow = ORBToastWindow(message: message, inset: inset, withImage: image)
            self.toastWindow?.isHidden = false
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
    
    func showCustomToast(toastView: ORBToastView, inset: CGFloat = 66.3) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            
            self.toastWindow?.hideAnimator.stopAnimation(true)
            self.toastWindow = nil
            
            let toastWindow = ORBToastWindow(toastView: toastView, inset: inset)
            self.toastWindow = toastWindow
            toastWindow.isHidden = false
            
            toastWindow.hideAnimator.addCompletion { [weak self] _ in
                self?.toastWindow = nil
            }
            
            toastWindow.showToast()
        }
    }
    
}
