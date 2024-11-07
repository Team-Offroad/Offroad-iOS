//
//  ORBCharacterChatViewController.swift
//  Offroad-iOS
//
//  Created by 김민성 on 11/7/24.
//

import UIKit

class ORBCharacterChatViewController: UIViewController {
    
    let rootView = ORBCharacterChatView()
    
    
    override func loadView() {
        view = rootView
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
}

extension ORBCharacterChatViewController {
    
    //MARK: - @objc Func
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        
    }
    
    //MARK: - Private Func
    
    private func setupNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
    }
    
    //MARK: - Func
    
    
    
}
