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
import RxSwift

final class HomeViewController: OffroadTabBarViewController {
    
    //MARK: - Properties
    
    private var disposeBag = DisposeBag()
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
    private var lastUnreadChatInfo: CharacterChatReadGetResponseData? = nil
    private var isReadLatestDiary = false
    
    // MARK: - Life Cycle
    
    init(pushType: PushNotificationRedirectModel? = nil) {
        self.pushType = pushType
        
        super.init(nibName: nil, bundle: nil)
        
        MyInfoManager.shared.updateCharacterListInfo()
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
        getUserAdventureInfo()
        getUserQuestInfo()
        bindData()
        getLastChatInfo()
        
        requestPushNotificationPermission()
        redirectViewControllerForPushNotification()
        #if DevTarget
        postDiarySettingDataRecord()
        getLatestDiaryInfo()
        #endif
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let offroadTabBarController = self.tabBarController as? OffroadTabBarController else { return }
        offroadTabBarController.showTabBarAnimation()
        
        self.navigationController?.navigationBar.isHidden = true
    }
}

extension HomeViewController {
    
    // MARK: - Private Method
    
    private func setupDelegate() {
        Messaging.messaging().delegate = self
    }
    
    private func setupTarget() {
        rootView.changeTitleButton.addTarget(self, action: #selector(changeTitleButtonTapped), for: .touchUpInside)
        rootView.chatButton.addTarget(self, action: #selector(chatButtonTapped), for: .touchUpInside)
        rootView.changeCharacterButton.addTarget(self, action: #selector(changeCharacterButtonTapped), for: .touchUpInside)
        #if DevTarget
        rootView.diaryButton.addTarget(self, action: #selector(diaryButtonTapped), for: .touchUpInside)
        rootView.recommendButton.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
        #else
        rootView.shareButton.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
        #endif
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
                
                if motionImageUrl != "" {
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
    
    func getLastChatInfo() {
        rootView.chatButton.isEnabled = false
        NetworkService.shared.characterChatService.getLastChatInfo { [weak self] networkResult in
            guard let self else { return }
            self.rootView.chatButton.isEnabled = true
            switch networkResult {
            case .success(let dto):
                guard let dto else { return }
                self.rootView.chatUnreadDotView.isHidden = dto.data.doesAllRead
                self.lastUnreadChatInfo = dto.data.doesAllRead ? nil : dto.data
            case .serverErr(_):
                showToast(message: "서버에 문제가 있는 것 같아요. 잠시 후 다시 시도해 주세요.", inset: 66)
            default:
                showToast(message: ErrorMessages.networkError, inset: 66)
            }
        }
    }
    
    private func bindData() {
        MyInfoManager.shared.didSuccessAdventure
            .debug()
            .subscribe(onNext: { [weak self] in
                guard let self else { return }
                self.getUserAdventureInfo()
                self.getUserQuestInfo()
            }).disposed(by: disposeBag)
        
        MyInfoManager.shared.didChangeRepresentativeCharacter
            .subscribe(onNext: { [weak self] in
                guard let self else { return }
                self.getUserAdventureInfo()
            }).disposed(by: disposeBag)
        
        MyInfoManager.shared.shouldUpdateCharacterAnimation
            .debug()
            .subscribe(onNext: { [weak self] category in
                guard let self else { return }
                self.categoryString = category
            }).disposed(by: disposeBag)
        
        Observable.merge(
            [ORBCharacterChatManager.shared.shouldUpdateLastChatInfo.asObservable(),
             ORBCharacterChatManager.shared.didReadLastChat.asObservable()]
        ).subscribe(onNext: { [weak self] in
            guard let self else { return }
            self.getLastChatInfo()
        }).disposed(by: disposeBag)
        
        #if DevTarget
        MyDiaryManager.shared.didCompleteCreateDiary
            .bind { _ in
                self.showCompleteCreateDiaryAlert()
            }
            .disposed(by: disposeBag)

        MyDiaryManager.shared.didUpdateLatestDiaryInfo
            .bind { _ in
                self.getLatestDiaryInfo()
            }
            .disposed(by: disposeBag)
        #endif
    }
    
    private func redirectNoticePost() {
        NetworkService.shared.noticeService.getNoticeList { response in
            switch response {
            case .success(let data):
                self.noticeModelList = data?.data.announcements ?? [NoticeInfo]()
                
                guard let id = Int(self.pushType?.data?["announcementId"] as! String) else { return }
                
                for post in self.noticeModelList {
                    if post.id == id {
                        let noticePostViewController = NoticePostViewController(noticeInfo: post)
                        noticePostViewController.setupCustomBackButton(buttonTitle: "홈")
                        self.navigationController?.pushViewController(noticePostViewController, animated: true)
                    }
                }
            default:
                break
            }
        }
    }
    
    #if DevTarget
    private func showCompleteCreateDiaryAlert() {
        let alertController = ORBAlertController(title: DiaryMessage.completeCreateDiaryTitle, message: DiaryMessage.completeCreateDiaryMessage, type: .normal)
        alertController.configureMessageLabel{ label in
            label.setLineHeight(percentage: 150)
        }
        alertController.xButton.isHidden = true
        let cancelAction = ORBAlertAction(title: "나중에", style: .cancel) { _ in return }
        let okAction = ORBAlertAction(title: "확인", style: .default) { _ in
            let diaryViewController = DiaryViewController(shouldShowLatestDiary: !self.isReadLatestDiary)
            diaryViewController.setupCustomBackButton(buttonTitle: "홈")
            self.navigationController?.pushViewController(diaryViewController, animated: true)
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        
        present(alertController, animated: true)
    }
    #endif
    
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
            
            Messaging.messaging().token { token, error in
                if let error = error {
                    print("Error fetching FCM token: \(error)")
                } else if let token = token {
                    print("FCM token: \(token)")
                    NetworkService.shared.pushNotificationService.postFcmToken(body: FcmTokenRequestDTO(token: token)) { response in
                        switch response {
                        case .success:
                            print("fcm 토큰 전송 성공!!!")
                        default:
                            break
                        }
                    }
                }
            }
        }
    }
    
    private func redirectViewControllerForPushNotification() {
        if let pushType {
            switch pushType.category {
            case "ANNOUNCEMENT_REDIRECT":
                redirectNoticePost()
            case "CHARACTER_CHAT":
                ORBCharacterChatManager.shared.chatViewController.patchChatReadRelay.accept(())
                ORBCharacterChatManager.shared.showCharacterChatBox(character: self.pushType?.data?["characterName"] as! String, message: self.pushType?.data?["message"] as! String, mode: .withReplyButtonShrinked)
            #if DevTarget
            case "MEMBER_DIARY_CREATE":
                MyDiaryManager.shared.didCompleteCreateDiary.accept(())
            #endif
            default:
                break
            }
        }
    }
    
    #if DevTarget
    private func postDiarySettingDataRecord() {
        NetworkService.shared.diarySettingService.postDiarySettingDataRecord { response in
            switch response {
            case .success:
                print("일기 레코드 세팅 데이터 전송 성공")
            default:
                break
            }
        }
    }
    
    private func getLatestDiaryInfo() {
        rootView.diaryButton.isEnabled = false
        NetworkService.shared.diaryService.getLatestDiaryChecked { [weak self] response in
            guard let self else { return }
            self.rootView.diaryButton.isEnabled = true
            switch response {
            case .success(let dto):
                guard let dto else { return }
                isReadLatestDiary = dto.data.doesNotExistOrChecked
                self.rootView.diaryUnreadDotView.isHidden = dto.data.doesNotExistOrChecked
            case .serverErr(_):
                showToast(message: "서버에 문제가 있는 것 같아요. 잠시 후 다시 시도해 주세요.", inset: 66)
            default:
                showToast(message: ErrorMessages.networkError, inset: 66)
            }
        }
    }
    #endif
    
    //MARK: - Func
    
    func fetchCategoryString(category: String) {
        categoryString = category
    }
    
    //MARK: - @Objc Func
    
    @objc private func chatButtonTapped() {
        if let lastUnreadChatInfo {
            ORBCharacterChatManager.shared.showCharacterChatBox(
                character: lastUnreadChatInfo.characterName ?? MyInfoManager.shared.representativeCharacterName ?? "",
                message: lastUnreadChatInfo.content ?? "",
                mode: .withoutReplyButtonShrinked,
                isAutoDismiss: false
            )
        }
        ORBCharacterChatManager.shared.startChat()
        ORBCharacterChatManager.shared.chatViewController.patchChatReadRelay.accept(())
    }
    
    @objc private func shareButtonTapped() {
        PHPhotoLibrary.requestAuthorization { status in
            print(status)
        }
        
        let imageProvider = ShareableImageProvider(image: characterImage ?? UIImage())
        
        let activityViewController = UIActivityViewController(activityItems: [imageProvider], applicationActivities: nil)
        activityViewController.excludedActivityTypes = [.addToReadingList, .assignToContact, .mail]
        
        if let popoverController = activityViewController.popoverPresentationController {
            popoverController.sourceView = rootView.shareButton
            popoverController.sourceRect = rootView.shareButton.bounds
            popoverController.permittedArrowDirections = .any
        }
        
        self.present(activityViewController, animated: true)
    }
    
    @objc private func changeCharacterButtonTapped() {
        let characterListViewController = CharacterListViewController()
        characterListViewController.setupCustomBackButton(buttonTitle: "홈")
        self.navigationController?.pushViewController(characterListViewController, animated: true)
    }

    #if DevTarget
    @objc private func diaryButtonTapped() {
        let diaryViewController = DiaryViewController(shouldShowLatestDiary: !isReadLatestDiary)
        diaryViewController.setupCustomBackButton(buttonTitle: "홈")
        self.navigationController?.pushViewController(diaryViewController, animated: true)
    }
    #endif
    
    @objc private func changeTitleButtonTapped() {
        let titlePopupViewController = TitlePopupViewController(emblemString: userEmblemString)
        titlePopupViewController.modalPresentationStyle = .overCurrentContext
        titlePopupViewController.delegate = self
        
        tabBarController?.present(titlePopupViewController, animated: false)
    }
}

extension HomeViewController: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        let dataDict: [String: String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
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
