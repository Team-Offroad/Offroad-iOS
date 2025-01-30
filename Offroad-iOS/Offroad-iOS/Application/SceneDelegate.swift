//
//  SceneDelegate.swift
//  Offroad-iOS
//
//  Created by 김민성 on 2024/06/25.
//

import UIKit

import KakaoSDKAuth
import RxSwift

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        self.window = UIWindow(windowScene: windowScene)
        self.window?.backgroundColor = .main(.main1)
        self.window?.rootViewController = SplashViewController()
        self.window?.makeKeyAndVisible()
        
        if let notification = connectionOptions.notificationResponse {
            let data = notification.notification.request.content.userInfo["aps"] as? [String : Any]?
            let category = notification.notification.request.content.categoryIdentifier
            
            let pushType = PushNotificationRedirectModel(data: data ?? nil, category: category)
            self.window?.rootViewController = SplashViewController(pushType: pushType)
        }
        
        #if DevTarget
        ORBToastManager.shared.showToast(message: "이 애플리케이션은 개발용 애플리케이션입니다.", inset: 30)
        #endif
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            if (AuthApi.isKakaoTalkLoginUrl(url)) {
                _ = AuthController.handleOpenUrl(url: url)
            }
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
        ORBCharacterChatManager.shared.shouldMakeKeyboardBackgroundTransparent.accept(true)
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
        ORBCharacterChatManager.shared.shouldMakeKeyboardBackgroundTransparent.accept(false)
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

