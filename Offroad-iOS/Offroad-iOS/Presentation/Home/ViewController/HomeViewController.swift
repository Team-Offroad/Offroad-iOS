//
//  HomeViewController.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 7/9/24.
//

import UIKit

final class HomeViewController: OffroadTabBarViewController {
    
    //MARK: - Properties
    
    private let rootView = HomeView()
    
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
        
        getUserAdventureInfo()
        getUserQuestInfo()
    }
}

extension HomeViewController {
    
    // MARK: - Private Method
    
    private func setupTarget() {
        rootView.setupChangeTitleButton(action: changeTitleButtonTapped)
    }
    
    private func changeTitleButtonTapped() {
        print("changeTitleButtonTapped")
        
        let titlePopupViewController = TitlePopupViewController()
        titlePopupViewController.modalPresentationStyle = .overCurrentContext
        titlePopupViewController.delegate = self
        
        present(titlePopupViewController, animated: false)
    }
    
    private func getUserAdventureInfo() {
        NetworkService.shared.adventureService.getAdventureInfo { response in
            switch response {
            case .success(let data):
                let nickname = data?.data.nickname ?? ""
                let characterImgUrl = data?.data.characterImgUrl ?? ""
                let characterName = data?.data.characterName ?? ""
                let emblemName = data?.data.emblemName ?? ""

                self.rootView.updateAdventureInfo(nickname: nickname, characterImgUrl: characterImgUrl, characterName: characterName, emblemName: emblemName)
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
}

extension HomeViewController: selectedTitleProtocol {
    func fetchTitleString(titleString: String) {
        rootView.changeMyTitleLabelText(text: titleString)
    }
}
