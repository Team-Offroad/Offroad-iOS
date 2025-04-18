//
//  QuestListCollectionView.swift
//  Offroad-iOS
//
//  Created by 김민성 on 4/4/25.
//

import UIKit

import ExpandableCell

/// 퀘스트 목록을 보여줄 collection view
final class QuestListCollectionView: ExpandableCellCollectionView, ORBEmptyCaseStyle, ORBCenterLoadingStyle, ORBScrollLoadingStyle {
    
    typealias placeholder = QuestListEmptyPlaceholder
    
    //MARK: - Properties
    
    private var questListService = QuestListService()
    private var allQuestList: [Quest] = []
    private var activeQuestList: [Quest] = []
    private var extendedListSize = 20
    private var lastCursorID = 0
    
#if DevTarget
    // 코스 퀘스트는 항상 activeQuestList의 최상단에 위치
    private var quests: [Any] {
        let sortedGeneralQuests = isActive ? activeQuestList : allQuestList
        return isActive ? (CourseQuest.dummy + sortedGeneralQuests) : sortedGeneralQuests
    }
#endif
    
    var isActive = true {
        didSet {
            if isActive {
                activeQuestList = []
            } else {
                allQuestList = []
            }
            extendedListSize = 20
            getInitialQuestList(isActive: isActive)
            reloadData()
        }
    }
    
    // MARK: - UI Properties
    
    let emptyPlaceholder = QuestListEmptyPlaceholder()
    
    // MARK: - Life Cycle
    
    init() {
        super.init(sectionInset: .init(top: 20, left: 24, bottom: 0, right: 24), minimumLineSpacing: 16)
        
        indicatorStyle = .black
        setupCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 스크롤 로딩 시 로딩 화면이 이상하게 위치하는 현상이 있어서 inset이 바뀔 때마다 위치 재조정
    public override func adjustedContentInsetDidChange() {
        performBatchUpdates(nil)
    }
    
}

extension QuestListCollectionView {
    
    private func setupCollectionView() {
        register(
            QuestListCell.self,
            forCellWithReuseIdentifier: QuestListCell.className
        )
#if DevTarget
        register(
            CourseQuestCollectionViewCell.self,
            forCellWithReuseIdentifier: CourseQuestCollectionViewCell.className
        )
#endif
        dataSource = self
        animationSpeed = UIAccessibility.isReduceMotionEnabled ? .none : .medium
    }
    
    func getInitialQuestList(isActive: Bool, cursor: Int = 0, size: Int = 20) {
        startCenterLoading(withoutShading: true)
        removeEmptyPlaceholder()
        questListService.getQuestList(isActive: isActive, cursor: cursor, size: size) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let response):
                guard let questListFromServer = response?.data.questList else { return }
                if isActive {
                    self.activeQuestList = questListFromServer
                    if self.activeQuestList.isEmpty {
                        showEmptyPlaceholder(view: emptyPlaceholder)
                    }
                } else {
                    self.allQuestList = questListFromServer
                    if self.allQuestList.isEmpty {
                        showEmptyPlaceholder(view: emptyPlaceholder)
                    }
                }
                self.alpha = 0
                self.reloadData()
                CATransaction.begin()
                // 컨텐츠를 불러오면 처음 한 번 셀이 레이아웃을 잡는 애니메이션이 재생됨.
                // 컨텐츠가 처음 뜰 때 애니메이션이 재생되는 것을 숨기기 위해서 레이아웃 애니메이션이 끝난 후에 컨텐츠 표시.
                CATransaction.setCompletionBlock { [weak self] in
                    self?.stopCenterLoading()
                    self?.alpha = 1
                }
                self.performBatchUpdates(nil)
                CATransaction.commit()
                lastCursorID = questListFromServer.last?.cursorId ?? Int()
            default:
                return
            }
        }
    }
    
    private func getExtendedQuestList(isActive: Bool, cursor: Int, size: Int) {
        startBottomScrollLoading()
        removeEmptyPlaceholder()
        questListService.getQuestList(isActive: isActive, cursor: cursor, size: size) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let response):
                guard let questListFromServer = response?.data.questList else { return }
                
                let currentCount = isActive ? self.activeQuestList.count : self.allQuestList.count
                let newItems = questListFromServer
                
                if isActive {
                    self.activeQuestList.append(contentsOf: newItems)
                    if self.activeQuestList.isEmpty {
                        showEmptyPlaceholder(view: emptyPlaceholder)
                    }
                } else {
                    self.allQuestList.append(contentsOf: newItems)
                    if self.allQuestList.isEmpty {
                        showEmptyPlaceholder(view: emptyPlaceholder)
                    }
                }
                
                let newIndices = (currentCount..<(currentCount + newItems.count)).map { IndexPath(item: $0, section: 0) }
                
                self.stopBottomScrollLoading()
                self.insertItems(at: newIndices)
                self.lastCursorID = newItems.last?.cursorId ?? Int()
                
            default:
                self.stopBottomScrollLoading()
            }
        }
    }
    
}

// MARK: - UICollectionViewDataSource

extension QuestListCollectionView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isActive {
            return activeQuestList.count
        } else {
            return allQuestList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
#if DevTarget
        let quest = quests[indexPath.item]

        switch quest {
        case let quest as Quest:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: QuestListCell.className,
                for: indexPath
            ) as? QuestListCell else { fatalError("QuestListCell dequeuing failed!") }
            cell.configureCell(with: quest)
            return cell
            
        case let courseQuest as CourseQuest:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CourseQuestCollectionViewCell.className,
                for: indexPath
            ) as? CourseQuestCollectionViewCell else {
                fatalError("CourseQuestCollectionViewCell dequeuing failed!")
            }
            cell.configureCell(with: courseQuest)
            return cell
            
        default:
            fatalError("Unknown quest type found in quest list.")
        }
#else
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: QuestListCell.className,
            for: indexPath
        ) as? QuestListCell else { fatalError("cell dequeing Failed!") }
        
        if isActive {
            cell.configureCell(with: activeQuestList[indexPath.item])
        } else {
            cell.configureCell(with: allQuestList[indexPath.item])
        }
        
        return cell
#endif
    }
    
}


// MARK: - UICollectionViewDelegate

extension QuestListCollectionView {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height
        let triggerPosition: CGFloat = 150
        if offsetY >= contentHeight - frameHeight - triggerPosition {
            if extendedListSize == lastCursorID {
                extendedListSize += 12
                getExtendedQuestList(isActive: isActive, cursor: lastCursorID, size: 12)
            }
        }
    }
    
}

// MARK: - ORBEmptyCaseStyle

extension QuestListCollectionView {
    
    func showEmptyPlaceholder() {
        showEmptyPlaceholder(view: emptyPlaceholder)
    }
    
    func setEmptyState(_ emptyState: Bool) {
        if emptyState {
            showEmptyPlaceholder()
        } else {
            removeEmptyPlaceholder()
        }
    }
    
}
