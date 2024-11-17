//
//  HomeViewController.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 7/9/24.
//

import UIKit

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
    
    // MARK: - Life Cycle
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTarget()
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
    
    private func setupTarget() {
        rootView.changeTitleButton.addTarget(self, action: #selector(changeTitleButtonTapped), for: .touchUpInside)
        rootView.shareButton.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
        rootView.chatButton.addTarget(self, action: #selector(chatButtonTapped), for: .touchUpInside)
        rootView.changeCharacterButton.addTarget(self, action: #selector(changeCharacterButtonTapped), for: .touchUpInside)
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
