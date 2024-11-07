//
//  ORBCharacterChatWindow.swift
//  Offroad-iOS
//
//  Created by 김민성 on 11/6/24.
//

import UIKit

class ORBCharacterChatWindow: UIWindow {
    
    
    override init(windowScene: UIWindowScene) {
        super.init(windowScene: windowScene)
        rootViewController = ORBCharacterChatViewController()
        windowLevel = UIWindow.Level.alert + 1
        makeKeyAndVisible()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let chatViewController = rootViewController as! ORBCharacterChatViewController
        if chatViewController.rootView.characterChatBox.frame.contains(point) ||
            chatViewController.rootView.userChatInputView.frame.contains(point) ||
            chatViewController.rootView.endChatButton.frame.contains(point) {
            return super.hitTest(point, with: event)
        } else {
            return nil
        }
    }
    
}
