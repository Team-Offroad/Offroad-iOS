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
        setupCollectionView()
        setupDelegates()
        getInitialQuestList(isActive: isActive)
#if DevTarget
        loadDummyCourseQuests()
#endif
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let offroadTabBarController = self.tabBarController as? OffroadTabBarController else { return }
        offroadTabBarController.hideTabBarAnimation()
    }
    
#if DevTarget
    private func loadDummyCourseQuests() {
        courseQuests = [
                    CourseQuest(
                        title: "코스 퀘스트 1",
                        progress: "1/5",
                        description: "첫 번째 코스 퀘스트",
                        quests: [
                            QuestDetail(locationName: "장소 A", mission: "미션 1"),
                            QuestDetail(locationName: "장소 B", mission: "미션 2")
                        ],
                        reward: "보상 1"
                    ),
                    CourseQuest(
                        title: "코스 퀘스트 2",
                        progress: "2/5",
                        description: "두 번째 코스 퀘스트",
                        quests: [
                            QuestDetail(locationName: "장소 C", mission: "미션 3"),
                            QuestDetail(locationName: "장소 D", mission: "미션 4")
                        ],
                        reward: "보상 2"
                    )
                ]
        
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
        isActive = sender.isOn
        rootView.questListCollectionView.setContentOffset(.zero, animated: false)
        rootView.questListCollectionView.reloadData()
    }
    
    @objc private func refreshCollectionView() {
        extendedListSize = 20
        getInitialQuestList(isActive: isActive)
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
    
    private func setupDelegates() {
        rootView.questListCollectionView.dataSource = self
        rootView.questListCollectionView.delegate = self
    }
    
    private func getInitialQuestList(isActive: Bool, cursor: Int = 0, size: Int = 20) {
        rootView.questListCollectionView.startLoading(withoutShading: true)
        rootView.questListCollectionView.emptyState = false
        questListService.getQuestList(isActive: isActive, cursor: cursor, size: size) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let response):
                guard let questListFromServer = response?.data.questList else { return }
                if isActive {
                    self.activeQuestList = questListFromServer
                    self.rootView.questListCollectionView.emptyState = self.activeQuestList.isEmpty
                } else {
                    self.allQuestList = questListFromServer
                    self.rootView.questListCollectionView.emptyState = self.allQuestList.isEmpty
                }
                self.rootView.questListCollectionView.stopLoading()
                self.rootView.questListCollectionView.reloadData()
                
                lastCursorID = questListFromServer.last?.cursorId ?? Int()
            default:
                return
            }
        }
    }
    
    private func getExtendedQuestList(isActive: Bool, cursor: Int, size: Int) {
        rootView.startScrollLoading()
        
        questListService.getQuestList(isActive: isActive, cursor: cursor, size: size) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let response):
                guard let questListFromServer = response?.data.questList else { return }
                
                let currentCount = isActive ? self.activeQuestList.count : self.allQuestList.count
                let newItems = questListFromServer
                
                if isActive {
                    self.activeQuestList.append(contentsOf: newItems)
                    self.rootView.questListCollectionView.emptyState = self.activeQuestList.isEmpty
                } else {
                    self.allQuestList.append(contentsOf: newItems)
                    self.rootView.questListCollectionView.emptyState = self.allQuestList.isEmpty
                }
                
                let newIndices = (currentCount..<(currentCount + newItems.count)).map { IndexPath(item: $0, section: 0) }
                
                DispatchQueue.main.async {
                    self.rootView.questListCollectionView.performBatchUpdates({
                        self.rootView.questListCollectionView.insertItems(at: newIndices)
                    }, completion: { finished in
                        print("===스크롤 로딩 완료===")
                        self.rootView.stopScrollLoading()
                    })
                }
                
                self.lastCursorID = newItems.last?.cursorId ?? Int()
                
            default:
                self.rootView.stopScrollLoading()
            }
            self.rootView.stopScrollLoading()
        }
    }
}


//MARK: - UICollectionViewDataSource

extension QuestListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
#if DevTarget
        return getSortedQuestList().count
#else
        return isActive ? activeQuestList.count : allQuestList.count
#endif
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
#if DevTarget
        let quests = getSortedQuestList()
        let quest = quests[indexPath.item]
        
        // 🔹 CourseQuest일 경우 CourseQuestCollectionViewCell을 사용
        if let courseQuest = quest as? CourseQuest {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CourseQuestCollectionViewCell.className,
                for: indexPath
            ) as? CourseQuestCollectionViewCell else {
                fatalError("CourseQuestCollectionViewCell dequeuing failed!")
            }
            cell.configureCell(with: courseQuest)
            return cell
        }
        
        // 🔹 일반 Quest일 경우 QuestListCollectionViewCell을 사용
        if let quest = quest as? Quest {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: QuestListCollectionViewCell.className,
                for: indexPath
            ) as? QuestListCollectionViewCell else { fatalError("QuestListCollectionViewCell dequeuing failed!") }
            
            cell.configureCell(with: quest)
            return cell
        }
        
        fatalError("Unknown quest type found in getSortedQuestList()")
#else
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: QuestListCollectionViewCell.className,
            for: indexPath
        ) as? QuestListCollectionViewCell else { fatalError("QuestListCollectionViewCell dequeuing failed!") }
        
        let quest = isActive ? activeQuestList[indexPath.item] : allQuestList[indexPath.item]
        cell.configureCell(with: quest)
        
        return cell
#endif
    }
}


//MARK: - UICollectionViewDelegate

extension QuestListViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let animator = UIViewPropertyAnimator(duration: 0.3, dampingRatio: 1)
        animator.addAnimations {
            if collectionView.indexPathsForSelectedItems?.contains(indexPath) ?? false {
                collectionView.deselectItem(at: indexPath, animated: false)
            } else {
                collectionView.selectItem(at: indexPath, animated: false, scrollPosition: UICollectionView.ScrollPosition())
            }
            collectionView.performBatchUpdates(nil)
        }
        
        let animationOperation = BlockOperation {
            DispatchQueue.main.async { animator.startAnimation() }
        }
        
        operationQueue.addOperation(animationOperation)
        return false
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height
        
        if offsetY >= contentHeight - frameHeight {
            if extendedListSize == lastCursorID {
                extendedListSize += 12
                getExtendedQuestList(isActive: isActive, cursor: lastCursorID, size: 12)
            }
            //TODO: 로딩 케이스 추가
        }
    }
}
