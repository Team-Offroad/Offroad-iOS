//
//  ORBCharacterChatManager.swift
//  Offroad-iOS
//
//  Created by 김민성 on 11/7/24.
//

import UIKit

final class ORBCharacterChatManager {
    
    //MARK: - Static Properties
    
    static let shared = ORBCharacterChatManager()
    
    //MARK: - Properties
    
    var chatWindow = ORBCharacterChatWindow(windowScene: UIWindowScene.current)
    var chatViewController: ORBCharacterChatViewController {
        chatWindow.rootViewController as! ORBCharacterChatViewController
    }
    
    //MARK: - Life Cycle
    
    private init() { }
    
}
    
extension ORBCharacterChatManager {
    
    func showCharacterChatBox(character name: String, message: String) {
        chatWindow.makeKeyAndVisible()
        chatViewController.configureCharacterChatBox(character: name, message: message)
        chatViewController.showCharacterChatBox()
    }
    
    func hideCharacterChatBox() {
        chatViewController.hideCharacterChatBox()
    }
    
    func startChat() {
        chatWindow.makeKeyAndVisible()
        self.chatViewController.rootView.userChatInputView.becomeFirstResponder()
    }
    
    func showKeyoardBackgroundView() {
        chatViewController.rootView.keyboardBackgroundView.isHidden = false
    }
    
    func hideKeyboardBackgroundView() {
        chatViewController.rootView.keyboardBackgroundView.isHidden = true
    }
    
}