//
//  QuestListViewControllers.swift
//  Offroad-iOS
//
//  Created by 김민성 on 8/10/24.
//

import UIKit

import RxSwift

class QuestListViewController: UIViewController {
    
    //MARK: - Properties
    
    private var questListService = QuestListService()
    private var allQuestList: [Quest] = []
    private var activeQuestList: [Quest] = []
    private var extendedListSize = 20
    private var lastCursorID = 0
    private var disposeBag = DisposeBag()
    
    private var isActive = true {
        didSet {
            if isActive {
                activeQuestList = []
            } else {
                allQuestList = []
            }
            extendedListSize = 20
            rootView.questListCollectionView.getInitialQuestList(isActive: true)
            rootView.questListCollectionView.reloadData()
        }
    }
    
    private let operationQueue = OperationQueue()
    private var completedQuestsFromCourse: [CompleteQuest]?
    
    //MARK: - UI Properties
    
    private let rootView = QuestListView()
    
    //MARK: - Life Cycle
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupControlsTarget()
        rootView.questListCollectionView.getInitialQuestList(isActive: true)
        rootView.questListCollectionView.shouldAlertMessage.subscribe { [weak self] alertMessage in
            self?.presentAlertMessage(message: alertMessage)
        }.disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let completed = completedQuestsFromCourse, !completed.isEmpty {
                popupQuestCompletion(completeQuests: completed)
                completedQuestsFromCourse = nil // 한 번만 띄우도록 초기화
            }
        
        rootView.questListCollectionView.getInitialQuestList(isActive: true)
        rootView.questListCollectionView.reloadData()
        
        guard let offroadTabBarController = self.tabBarController as? OffroadTabBarController else { return }
        offroadTabBarController.hideTabBarAnimation()
    }
}

extension QuestListViewController {
    
    //MARK: - @objc Func
    
    @objc private func customBackButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func ongoingQuestSwitchValueChanged(sender: UISwitch) {
        rootView.questListCollectionView.isActive = sender.isOn
        rootView.questListCollectionView.setContentOffset(.zero, animated: false)
        rootView.questListCollectionView.reloadData()
    }
    
    //MARK: - Private Func
    
    private func setupControlsTarget() {
        rootView.customBackButton.addTarget(self, action: #selector(customBackButtonTapped), for: .touchUpInside)
        rootView.ongoingQuestSwitch.addTarget(self, action: #selector(ongoingQuestSwitchValueChanged(sender:)), for: .valueChanged)
        
#if DevTarget
        rootView.questListCollectionView.onTapCourseQuestDetail = { [weak self] quest in
            guard let deadline = quest.deadline else { return }
            let courseQuestViewController = CourseQuestViewController(
                questId: quest.questId,
                deadline: deadline,
                totalCount: quest.totalCount,
                currentCount: quest.currentCount
            )
            courseQuestViewController.onQuestCompleted = { [weak self] completedQuests in
                self?.completedQuestsFromCourse = completedQuests
            }
            self?.navigationController?.pushViewController(courseQuestViewController, animated: true)
        }
#endif
    }
    
    // alert 를 띄우는 함수. 장소 목록을 불러오는 데 실패했을 경우 사용
    /// - Parameter message: alert에 띄울 메시지.
    func presentAlertMessage(message: String) {
        let alertController = ORBAlertController(message: message, type: .messageOnly)
        alertController.xButton.isHidden = true
        let okAction = ORBAlertAction(title: "확인", style: .default) { _ in return }
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
    
    ///코스퀘스트 장소 방문으로 타 퀘스트 클리어 했을 때의 예외케이스 팝업 띄우는 함수
    private func popupQuestCompletion(completeQuests: [CompleteQuest]) {
        let message: String
        if completeQuests.isEmpty { return }
        else if completeQuests.count == 1 {
            message = AlertMessage.completeSingleQuestMessage(questName: completeQuests.first!.name)
        } else {
            message = AlertMessage.completeMultipleQuestsMessage(
                firstQuestName: completeQuests.first!.name,
                questCount: completeQuests.count
            )
        }
        
        let questCompleteAlertController = ORBAlertController(
            title: AlertMessage.completeQuestsTitle,
            message: message,
            type: .normal
        )
        questCompleteAlertController.xButton.isHidden = true
        let action = ORBAlertAction(title: "확인", style: .default) { _ in
            AmplitudeManager.shared.trackEvent(withName: AmplitudeEventTitles.questSuccess)
        }
        questCompleteAlertController.addAction(action)
        present(questCompleteAlertController, animated: true)
    }
    
}
