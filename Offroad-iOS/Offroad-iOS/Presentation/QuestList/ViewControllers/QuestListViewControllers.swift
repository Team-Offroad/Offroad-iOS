//
//  QuestListViewControllers.swift
//  Offroad-iOS
//
//  Created by 김민성 on 8/10/24.
//

import UIKit

class QuestListViewController: UIViewController {
    
    //MARK: - Properties
    
#if DevTarget
    private var courseQuests: [CourseQuest] = []
#endif
    private var questListService = QuestListService()
    private var allQuestList: [Quest] = []
    private var activeQuestList: [Quest] = []
    private var extendedListSize = 20
    private var lastCursorID = 0
    
    private var isActive = true {
        didSet {
            if isActive {
                activeQuestList = []
            } else {
                allQuestList = []
            }
            extendedListSize = 20
            getInitialQuestList(isActive: isActive)
            rootView.questListCollectionView.reloadData()
        }
    }
    
    private let operationQueue = OperationQueue()
    
    //MARK: - UI Properties
    
    private let rootView = QuestListView()
    
    //MARK: - Life Cycle
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupControlsTarget()
#if DevTarget
        loadDummyCourseQuests()
#endif
        rootView.questListCollectionView.getInitialQuestList(isActive: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let offroadTabBarController = self.tabBarController as? OffroadTabBarController else { return }
        offroadTabBarController.hideTabBarAnimation()
    }
    
#if DevTarget
    private func loadDummyCourseQuests() {
        courseQuests = CourseQuest.dummy
        rootView.questListCollectionView.reloadData()
    }
    
    private func getSortedQuestList() -> [Any] {
        let sortedGeneralQuests = isActive ? activeQuestList : allQuestList
        
        // 코스 퀘스트는 항상 activeQuestList의 최상단에 위치
        return isActive ? (courseQuests + sortedGeneralQuests) : sortedGeneralQuests
    }
    
    func addCourseQuest(_ newQuest: CourseQuest) {
        courseQuests.insert(newQuest, at: 0) // 리스트 최상단에 추가
        rootView.questListCollectionView.reloadData()
    }
#endif
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
    }
    
    private func setupCollectionView() {
        rootView.questListCollectionView.register(
            QuestListCollectionViewCell.self,
            forCellWithReuseIdentifier: QuestListCollectionViewCell.className
        )
        
#if DevTarget
        rootView.questListCollectionView.register(
            CourseQuestCollectionViewCell.self,
            forCellWithReuseIdentifier: CourseQuestCollectionViewCell.className
        )
#endif
    }
}
