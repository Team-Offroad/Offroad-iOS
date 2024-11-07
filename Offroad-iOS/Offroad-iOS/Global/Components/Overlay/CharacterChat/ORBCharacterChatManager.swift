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
        chatWindow.makeKey()
        let isFR = self.chatViewController.rootView.inputTextView.becomeFirstResponder()
        print("isFirstResponder?: \(isFR)")
    }
    
    func endChat() {
        let isFR = chatViewController.rootView.inputTextView.resignFirstResponder()
        print("isFirstResponder?: \(isFR)")
    }
    
}
