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
    
    
    private init() { }
    
    
    func showCharacterChatBox() {
        let chatViewController = chatWindow.rootViewController as! ORBCharacterChatViewController
        
    }
    
    func startChat() {
        chatWindow = ORBCharacterChatWindow(windowScene: UIWindowScene.current)
    }
    
    func endChat() {
        
    }
    
}
