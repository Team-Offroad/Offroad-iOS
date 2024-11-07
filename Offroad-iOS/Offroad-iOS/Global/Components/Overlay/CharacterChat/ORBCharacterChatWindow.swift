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
        makeKeyAndVisible()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
