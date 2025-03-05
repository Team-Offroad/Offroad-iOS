//
//  ORBCharacterChatManager.swift
//  Offroad-iOS
//
//  Created by 김민성 on 11/7/24.
//

import UIKit

import RxSwift
import RxCocoa

final class ORBCharacterChatManager {
    
    //MARK: - Static Properties
    
    static let shared = ORBCharacterChatManager()
    
    //MARK: - Properties
    
    let shouldPushCharacterChatLogViewController = PublishSubject<Int?>()
    let shouldMakeKeyboardBackgroundTransparent = PublishRelay<Bool>()
    let shouldUpdateLastChatInfo = PublishRelay<Void>()
    let didReadLastChat = PublishRelay<Void>()
    weak var currentChatLogViewController: CharacterChatLogViewController? = nil
    
    //MARK: - UI Properties
    
    private var chatWindow = ORBCharacterChatWindow(windowScene: UIWindowScene.current)
    var chatViewController: ORBCharacterChatViewController {
        chatWindow.rootViewController as! ORBCharacterChatViewController
    }
    private var characterChatBox: ORBCharacterChatBox { chatViewController.rootView.characterChatBox }
    private var endChatButton: UIButton { chatViewController.rootView.endChatButton }
    
    //MARK: - Life Cycle
    
    private init() {
        characterChatBox.isHidden = true
        endChatButton.isHidden = true
    }
    
}

extension ORBCharacterChatManager {
    
    func showCharacterChatBox(character name: String, message: String, mode: ChatBoxMode, isAutoDismiss: Bool = true) {
        chatWindow.makeKeyAndVisible()
        characterChatBox.configureContents(character: name, message: message, mode: mode, animated: false)
        chatViewController.showCharacterChatBox(isAutoDismiss: isAutoDismiss)
    }
    
    func hideCharacterChatBox() {
        chatViewController.hideCharacterChatBox()
    }
    
    func startChat() {
        chatWindow.makeKeyAndVisible()
        chatViewController.startChat()
    }
    
    func endChat() {
        chatViewController.endChat()
        hideCharacterChatBox()
    }
    
}
