//
//  HomeViewController.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 7/9/24.
//

import UIKit

import Firebase
import FirebaseMessaging
import Photos

final class HomeViewController: OffroadTabBarViewController {
    
    //MARK: - Properties
    
    private let rootView = HomeView()
    
    private var userEmblemString = ""
    private var characterImage: UIImage?
    private var characterImageURLString: String? {
        didSet {
            loadCharacterImage(imageURL: characterImageURLString ?? "")
        }
    }
    
    var categoryString = "NONE"
    private let pushType: PushNotificationRedirectModel?
    private var noticeModelList: [NoticeInfo] = []
    
    // MARK: - Life Cycle
    
    init(pushType: PushNotificationRedirectModel? = nil) {
        self.pushType = pushType
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDelegate()
        setupTarget()
        
        requestPushNotificationPermission()
        redirectViewControllerForPushNotification()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let offroadTabBarController = self.tabBarController as? OffroadTabBarController else { return }
        offroadTabBarController.showTabBarAnimation()
        
        self.navigationController?.navigationBar.isHidden = true
        getUserAdventureInfo()
        getUserQuestInfo()
    }
}

extension HomeViewController {
    
    // MARK: - Private Method
    
    private func setupDelegate() {
        Messaging.messaging().delegate = self
    }
    
    private func setupTarget() {
        rootView.changeTitleButton.addTarget(self, action: #selector(changeTitleButtonTapped), for: .touchUpInside)
        rootView.shareButton.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
        rootView.chatButton.addTarget(self, action: #selector(chatButtonTapped), for: .touchUpInside)
        rootView.changeCharacterButton.addTarget(self, action: #selector(changeCharacterButtonTapped), for: .touchUpInside)
    }
    
    private func getUserAdventureInfo() {
        view.startLoading()
        NetworkService.shared.adventureService.getAdventureInfo(category: categoryString) { [weak self] response in
            guard let self else { return }
            self.view.stopLoading()
            switch response {
            case .success(let data):
                let nickname = data?.data.nickname ?? ""
                let baseImageUrl = data?.data.baseImageUrl ?? ""
                let motionImageUrl = data?.data.motionImageUrl ?? ""
                let characterName = data?.data.characterName ?? ""
                let emblemName = data?.data.emblemName ?? ""
                
                self.characterImageURLString = baseImageUrl
                
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
    
    private func redirectNoticePost() {
        NetworkService.shared.noticeService.getNoticeList { response in
            switch response {
            case .success(let data):
                self.noticeModelList = data?.data.announcements ?? [NoticeInfo]()
                
                guard let id = Int(self.pushType?.data?["noticeID"] as! String) else { return }
                let noticePostViewController = NoticePostViewController(noticeInfo: self.noticeModelList[id - 1])
                noticePostViewController.setupCustomBackButton(buttonTitle: "홈")
                self.navigationController?.pushViewController(noticePostViewController, animated: true)
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
    
    private func redirectViewControllerForPushNotification() {
        if let pushType {
            switch pushType.category {
            case "ANNOUNCEMENT_REDIRECT":
                redirectNoticePost()
            case "CHARACTER_CHAT":
                ORBCharacterChatManager.shared.startChat()
                ORBCharacterChatManager.shared.showCharacterChatBox(character: self.pushType?.data?["characterName"] as! String, message: self.pushType?.data?["message"] as! String, mode: .withoutReplyButtonExpanded)
            default:
                break
            }
        }
    }
    
    //MARK: - Func
    
    func fetchCategoryString(category: String) {
        categoryString = category
    }
    
    //MARK: - @Objc Func
    
    @objc private func chatButtonTapped() {
        ORBCharacterChatManager.shared.startChat()
    }
    
    @objc private func shareButtonTapped() {
        PHPhotoLibrary.requestAuthorization { status in
            print(status)
        }
        
        let imageProvider = ShareableImageProvider(image: characterImage ?? UIImage())
        
        let activityViewController = UIActivityViewController(activityItems: [imageProvider], applicationActivities: nil)
        activityViewController.excludedActivityTypes = [.addToReadingList, .assignToContact, .mail]
        
        self.present(activityViewController, animated: true)
    }
    
    @objc private func changeCharacterButtonTapped() {
        let characterListViewController = CharacterListViewController()
        characterListViewController.setupCustomBackButton(buttonTitle: "홈")
        self.navigationController?.pushViewController(characterListViewController, animated: true)
    }
    
    @objc private func changeTitleButtonTapped() {        
        let titlePopupViewController = TitlePopupViewController(emblemString: userEmblemString)
        titlePopupViewController.modalPresentationStyle = .overCurrentContext
        titlePopupViewController.delegate = self
        
        present(titlePopupViewController, animated: false)
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

extension HomeViewController: SelectedTitleProtocol {
    func fetchTitleString(titleString: String) {
        rootView.changeMyTitleLabelText(text: titleString)
        userEmblemString = titleString
    }
}

extension HomeViewController: SVGFetchable {
    func loadCharacterImage(imageURL: String) {
        fetchSVG(svgURLString: characterImageURLString ?? "") { image in
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                characterImage = image ?? UIImage()
            }
        }
    }
}
