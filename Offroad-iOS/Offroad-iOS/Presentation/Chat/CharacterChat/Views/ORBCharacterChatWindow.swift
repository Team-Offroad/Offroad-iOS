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
        tintColor = .sub(.sub4)
        windowLevel = UIWindow.Level.alert + 1
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let chatViewController = rootViewController as! ORBCharacterChatViewController
        let isCharacterChatBoxShown = chatViewController.isCharacterChatBoxShown
        let isChatTextInputViewShown = chatViewController.isChatTextInputViewShown
        let characterChatBox = chatViewController.rootView.characterChatBox
        let chatTextInputView = chatViewController.rootView.chatTextInputView
        let chatTextDisplayView = chatViewController.rootView.chatTextDisplayView
        let endChatButton = chatViewController.rootView.endChatButton
        
        // 캐릭터 채팅 박스를 터치한 경우
        let isChatBoxTouchAllowed = (isCharacterChatBoxShown && characterChatBox.frame.contains(point))
        
        // 사용자 채팅 입력 영역을 터치한 경우
        let isTextInputViewTouchAllowed = (
            isChatTextInputViewShown && (chatTextInputView.frame.contains(point) ||
                                         chatTextDisplayView.frame.contains(point) ||
                                         endChatButton.frame.contains(point))
        )
        
        // 사용자가 지정된 영역을 터치했을 때만 터치 인식. 그 외에는 다음 window로 터치 이벤트 전달.
        if isChatBoxTouchAllowed || isTextInputViewTouchAllowed {
            return super.hitTest(point, with: event)
        } else {
            return nil
        }
    }
    
}
