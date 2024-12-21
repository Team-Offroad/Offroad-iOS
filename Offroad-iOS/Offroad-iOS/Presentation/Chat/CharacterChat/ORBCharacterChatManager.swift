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
    
    let shouldPushCharacterChatLogViewController = PublishSubject<Int>()
    let shouldMakeKeyboardBackgroundTransparent = PublishRelay<Bool>()
    let shouldUpdateLastChatInfo = PublishRelay<Void>()
    let didReadLastChat = PublishRelay<Void>()
    weak var currentChatLogViewController: CharacterChatLogViewController? = nil
    
    //MARK: - UI Properties
    
    var chatWindow = ORBCharacterChatWindow(windowScene: UIWindowScene.current)
    var chatViewController: ORBCharacterChatViewController {
        chatWindow.rootViewController as! ORBCharacterChatViewController
    }
    var characterChatBox: ORBCharacterChatBox { chatViewController.rootView.characterChatBox }
    var userChatView: UIView { chatViewController.rootView.userChatView }
    var endChatButton: UIButton { chatViewController.rootView.endChatButton }
    
    //MARK: - Life Cycle
    
    private init() {
        characterChatBox.isHidden = true
        userChatView.isHidden = true
        endChatButton.isHidden = true
    }
    
}

extension ORBCharacterChatManager {
    
    func showCharacterChatBox(character name: String, message: String, mode: ChatBoxMode) {
        chatWindow.makeKeyAndVisible()
        chatViewController.configureCharacterChatBox(character: name, message: message, mode: mode, animated: false)
        chatViewController.showCharacterChatBox()
    }
    
    func hideCharacterChatBox() {
        chatViewController.hideCharacterChatBox()
    }
    
    func startChat() {
        chatWindow.makeKeyAndVisible()
        userChatView.isHidden = false
        endChatButton.isHidden = false
        self.chatViewController.rootView.userChatInputView.becomeFirstResponder()
    }
    
    func endChat() {
        chatViewController.hideUserChatInputView()
        chatViewController.rootView.userChatInputView.resignFirstResponder()
        chatViewController.rootView.userChatInputView.text = ""
        chatViewController.rootView.userChatDisplayView.text = ""
        hideCharacterChatBox()
    }
    
}
