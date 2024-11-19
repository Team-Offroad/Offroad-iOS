//
//  HomeViewController.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 7/9/24.
//

import UIKit

import Firebase
import FirebaseMessaging

final class HomeViewController: OffroadTabBarViewController {
    
    //MARK: - Properties
    
    private let rootView = HomeView()
    
    private var userEmblemString = ""
    
    var categoryString = "NONE"
    
    // MARK: - Life Cycle
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDelegate()
        setupTarget()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getUserAdventureInfo()
        getUserQuestInfo()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        requestPushNotificationPermission()
    }
}

extension HomeViewController {
    
    //MARK: - @objc Func
    
    @objc private func chatButtonTapped() {
        ORBCharacterChatManager.shared.startChat()
    }
    
    // MARK: - Private Method
    
    private func setupDelegate() {
        Messaging.messaging().delegate = self
    }
    
    private func setupTarget() {
        rootView.setupChangeTitleButton(action: changeTitleButtonTapped)
        rootView.chatButton.addTarget(self, action: #selector(chatButtonTapped), for: .touchUpInside)
    }
    
    private func changeTitleButtonTapped() {
        print("changeTitleButtonTapped")
        
        let titlePopupViewController = TitlePopupViewController(emblemString: userEmblemString)
        titlePopupViewController.modalPresentationStyle = .overCurrentContext
        titlePopupViewController.delegate = self
        
        present(titlePopupViewController, animated: false)
    }
    
    private func getUserAdventureInfo() {
        NetworkService.shared.adventureService.getAdventureInfo(category: categoryString) { response in
            switch response {
            case .success(let data):
                let nickname = data?.data.nickname ?? ""
                let baseImageUrl = data?.data.baseImageUrl ?? ""
                let motionImageUrl = data?.data.motionImageUrl ?? ""
                let characterName = data?.data.characterName ?? ""
                let emblemName = data?.data.emblemName ?? ""
                
                self.userEmblemString = emblemName
                
                self.rootView.updateAdventureInfo(nickname: nickname, baseImageUrl: baseImageUrl, characterName: characterName, emblemName: emblemName)
                
                if self.categoryString != "NONE" && motionImageUrl != "" {
                    self.rootView.showMotionImage(motionImageUrl: motionImageUrl)
                }
            default:
                break
            }
        }
    }
    
    private func getUserQuestInfo() {
        NetworkService.shared.questService.getQuestInfo { response in
            switch response {
            case .success(let data):
                let recentQuestName = data?.data.recent.questName ?? ""
                let recentProgress = data?.data.recent.progress ?? Int()
                let recentCompleteCondition = data?.data.recent.completeCondition ?? Int()
                
                let almostQuestName = data?.data.almost.questName ?? ""
                let almostprogress = data?.data.almost.progress ?? Int()
                let almostCompleteCondition = data?.data.almost.completeCondition ?? Int()
                
                self.rootView.updateQuestInfo(recentQuestName: recentQuestName, recentProgress: recentProgress, recentCompleteCondition: recentCompleteCondition, almostQuestName: almostQuestName, almostprogress: almostprogress, almostCompleteCondition: almostCompleteCondition)
            default:
                break
            }
        }
    }
    
    private func requestPushNotificationPermission() {
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { [weak self] settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                    if let error = error {
                        print("권한 요청 중 오류 발생: \(error)")
                        return
                    }
                    if granted {
                        DispatchQueue.main.async {
                            self?.registerForPushNotifications()
                        }
                    } else {
                        print("사용자가 푸시 알림을 거부했습니다.")
                    }
                }
            case .denied:
                print("사용자가 이전에 푸시 알림을 거부했습니다.")
            case .authorized, .provisional, .ephemeral:
                DispatchQueue.main.async {
                    self?.registerForPushNotifications()
                }
            @unknown default:
                break
            }
        }
    }
    
    private func registerForPushNotifications() {
        DispatchQueue.main.async {
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
    
    //MARK: - Func
    
    func fetchCategoryString(category: String) {
        categoryString = category
    }
}

extension HomeViewController: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(String(describing: fcmToken))")
        
        let dataDict: [String: String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        
        NetworkService.shared.pushNotificationService.postSocialLogin(body: FcmTokenRequestDTO(token: fcmToken ?? String())) { response in
            switch response {
            case .success:
                print("fcm 토큰 갱신 성공!!!")
            default:
                break
            }
        }
    }
}

extension HomeViewController: selectedTitleProtocol {
    func fetchTitleString(titleString: String) {
        rootView.changeMyTitleLabelText(text: titleString)
        userEmblemString = titleString
    }
}
