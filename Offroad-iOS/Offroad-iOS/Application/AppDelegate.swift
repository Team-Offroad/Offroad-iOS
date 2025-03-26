//
//  AppDelegate.swift
//  Offroad-iOS
//
//  Created by 김민성 on 2024/06/25.
//

import UIKit

import Firebase
import FirebaseMessaging
import KakaoSDKCommon
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        if let nativeAppKey = Bundle.main.infoDictionary?["NATIVE_APP_KEY"] as? String {
            KakaoSDK.initSDK(appKey: nativeAppKey)
        }
        
        // NetworkMonitoringManager 싱글톤 객체 생성
        let _ = NetworkMonitoringManager.shared
        
        #if DevTarget
        // 개발용 앱인 경우 'GoogleService-Info_Dev.plist' 파일을 사용하여 FirebaseApp을 configure
        let filePath = Bundle.main.path(forResource: "GoogleService-Info_Dev", ofType: "plist")
        if let filePath, let options = FirebaseOptions(contentsOfFile: filePath) {
            FirebaseApp.configure(options: options)
        } else {
            // 개발용 앱에서만 문제 발생 시 fataError 발생(앱 강제종료)
            fatalError("GoogleService-Info.plist not found.")
        }
        #elseif ReleaseTarget
        // AmplitudeManager 싱글톤 객체 초기화
        let _ = AmplitudeManager.shared
        // 배포용 앱인 경우 'GoogleService-Info.plist' 파일을 사용하여 FirebaseApp을 configure (기본값)
        FirebaseApp.configure()
        #endif
        
        
        
        UNUserNotificationCenter.current().delegate = self
        application.registerForRemoteNotifications()
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("APNS token: \(deviceToken)")
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        if let data = notification.request.content.userInfo["aps"] as? [String: Any] {
            let category = notification.request.content.categoryIdentifier
            if category == "CHARACTER_CHAT" {
                completionHandler([])
                if let characterName = data["characterName"] as? String,
                   let message = data["message"] as? String {
                    if let chatLogViewController = ORBCharacterChatManager.shared.currentChatLogViewController {
                        chatLogViewController.characterChatPushedRelay.accept(message)
                    } else {
                        ORBCharacterChatManager.shared.shouldUpdateLastChatInfo.accept(())
                        ORBCharacterChatManager.shared.showCharacterChatBox(character: characterName, message: message, mode: .withReplyButtonShrinked)
                        ORBCharacterChatManager.shared.chatViewController.rootView.setNeedsLayout()
                    }
                }
            } else if category == "ANNOUNCEMENT_REDIRECT" {
                completionHandler([.list, .banner])
            }
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let application = UIApplication.shared
        
        if application.applicationState == .active {
            print("푸쉬알림 탭(앱 켜져있음)")
            
            //TODO: - 앱 실행 중에 공지사항 알림을 탭했을 때 수행할 동작 정의
        }
        
        if application.applicationState == .inactive {
            print("푸쉬알림 탭(앱 꺼져있음)")
            
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
            guard let window = windowScene.windows.first  else { return }
            
            let data = response.notification.request.content.userInfo["aps"] as? [String : Any]?
            let category = response.notification.request.content.categoryIdentifier
            
            let pushType = PushNotificationRedirectModel(data: data ?? nil, category: category)
            window.rootViewController = SplashViewController(pushType: pushType)
        }

        completionHandler()
    }

}
