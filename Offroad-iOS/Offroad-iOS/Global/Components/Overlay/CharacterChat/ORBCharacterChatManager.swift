//
//  ORBCharacterChatManager.swift
//  Offroad-iOS
//
//  Created by 김민성 on 11/7/24.
//

import UIKit

final class ORBCharacterChatManager {
    
    static let shared = ORBCharacterChatManager()
    
    var chatWindow = ORBCharacterChatWindow(windowScene: UIWindowScene.current)
    var chatViewController: ORBCharacterChatViewController {
        chatWindow.rootViewController as! ORBCharacterChatViewController
    }
    
    private init() { }
    
    func showCharacterChatBox(character name: String, message: String) {
        chatViewController.configureCharacterChatBox(character: name, message: message)
        chatViewController.showCharacterChatBox()
    }
    
    func startChat() {
        chatViewController.rootView.inputTextView.becomeFirstResponder()
    }
    
    func endChat() {
        chatViewController.rootView.inputTextView.resignFirstResponder()
    }
    
}
