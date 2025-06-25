//
//  QuestListCollectionView.swift
//  Offroad-iOS
//
//  Created by 김민성 on 4/4/25.
//

import UIKit

import ExpandableCell
import RxSwift
import RxRelay

/// 퀘스트 목록을 보여줄 collection view
final class QuestListCollectionView: ExpandableCellCollectionView, ORBEmptyCaseStyle, ORBCenterLoadingStyle, ORBScrollLoadingStyle {
    
    typealias placeholder = QuestListEmptyPlaceholder
    
    //MARK: - Properties
    
    private var questListService = NetworkService.shared.questListService
    private var allQuestList: [Quest] = []
    private var activeQuestList: [Quest] = []
    private var extendedListSize = 20
    private var lastCursorID = 0
    let shouldAlertMessage = PublishRelay<String>.init()
    
#if DevTarget
    private var courseQuests: [Quest] = []
    private var generalQuests: [Quest] = []
    private var generalActiveQuestList: [Quest] {
        return activeQuestList.filter { !$0.isCourse }
    }
    private var visibleQuests: [Quest] {
        return isActive ? (courseQuests + generalActiveQuestList) : (courseQuests + generalQuests)
    }
#endif
    
    var isActive = true {
        didSet {
            extendedListSize = 20
            getInitialQuestList(isActive: isActive)
        }
    }
    
    var onTapCourseQuestDetail: ((Quest) -> Void)?
    
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
        delegate = self
        animationSpeed = UIAccessibility.isReduceMotionEnabled ? .none : .medium
    }
    
    func getInitialQuestList(isActive: Bool, cursor: Int = 0, size: Int = 20) {
        startCenterLoading(withoutShading: true)
        removeEmptyPlaceholder()
        questListService.getQuestList(isActive: isActive, cursor: cursor, size: size) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let decodedData):
                let questListFromServer = decodedData.data.questList
                
#if DevTarget
                self.courseQuests = questListFromServer.filter { $0.isCourse }
                               self.generalQuests = questListFromServer.filter { !$0.isCourse }

                               self.activeQuestList = self.generalQuests.filter { $0.currentCount > 0 }
                               self.allQuestList = self.generalQuests

                               if self.visibleQuests.isEmpty {
                                   showEmptyPlaceholder(view: emptyPlaceholder)
                               }
#else
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
#endif
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
            case .failure(let networkError):
                self.stopCenterLoading()
                switch networkError {
                case .httpError, .decodingFailed, .unknownURLError, .unknown:
                    shouldAlertMessage.accept("퀘스트 목록을 받아오는 데 실패했습니다. 잠시 후 다시 시도해 주세요.")
                case .notConnectedToInternet, .timeout:
                    shouldAlertMessage.accept("퀘스트 목록을 받아오지 못했습니다.\n네트워크 연결 상태를 확인해주세요.")
                case .networkCancelled:
                    return
                }
            }
        }
    }
    
    private func getExtendedQuestList(isActive: Bool, cursor: Int, size: Int) {
        startBottomScrollLoading()
        removeEmptyPlaceholder()
        questListService.getQuestList(isActive: isActive, cursor: cursor, size: size) { [weak self] result in
            guard let self else { return }
#if DevTarget
            switch result {
            case .success(let response):
                let questListFromServer = response.data.questList
                let newGeneralQuests = questListFromServer.filter { !$0.isCourse }
                
                let currentCount = isActive ? self.activeQuestList.count : self.allQuestList.count
                
                if isActive {
                    let newItems = newGeneralQuests.filter { $0.currentCount > 0 }
                    self.activeQuestList.append(contentsOf: newItems)
                    if self.activeQuestList.isEmpty {
                        showEmptyPlaceholder(view: emptyPlaceholder)
                    }
                    
                    let newIndices = (currentCount..<(currentCount + newItems.count)).map { IndexPath(item: $0 + self.courseQuests.count, section: 0) }
                    self.insertItems(at: newIndices)
                    
                } else {
                    let newItems = newGeneralQuests
                    self.allQuestList.append(contentsOf: newItems)
                    if self.allQuestList.isEmpty {
                        showEmptyPlaceholder(view: emptyPlaceholder)
                    }
                    
                    let newIndices = (currentCount..<(currentCount + newItems.count)).map { IndexPath(item: $0, section: 0) }
                    self.insertItems(at: newIndices)
                }
                
                self.stopBottomScrollLoading()
                self.lastCursorID = questListFromServer.last?.cursorId ?? 0
                
            case .failure(let error):
                self.stopBottomScrollLoading()
                switch error {
                case .httpError, .decodingFailed, .unknownURLError, .unknown:
                    shouldAlertMessage.accept("퀘스트 목록을 받아오는 데 실패했습니다. 잠시 후 다시 시도해 주세요.")
                case .notConnectedToInternet, .timeout:
                    shouldAlertMessage.accept("퀘스트 목록을 받아오는 데 실패했습니다. 네트워크 연결 상태를 확인해주세요.")
                case .networkCancelled:
                    return
                }
            }
#else
            switch result {
            case .success(let response):
                let questListFromServer = response.data.questList
                
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
                
            case .failure(let networkError):
                self.stopBottomScrollLoading()
                switch networkError {
                case .httpError, .decodingFailed, .unknownURLError, .unknown:
                    shouldAlertMessage.accept("퀘스트 목록을 받아오는 데 실패했습니다. 잠시 후 다시 시도해 주세요.")
                case .notConnectedToInternet, .timeout:
                    shouldAlertMessage.accept("퀘스트 목록을 받아오는 데 실패했습니다. 네트워크 연결 상태를 확인해주세요.")
                case .networkCancelled:
                    return
                }
            }
#endif
        }
    }
    
}

// MARK: - UICollectionViewDataSource

extension QuestListCollectionView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
#if DevTarget
        return visibleQuests.count
#else
        return isActive ? activeQuestList.count : allQuestList.count
#endif
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
#if DevTarget
        let quest = visibleQuests[indexPath.item]
        
        if quest.isCourse {
                    guard let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: CourseQuestCollectionViewCell.className,
                        for: indexPath
                    ) as? CourseQuestCollectionViewCell else {
                        fatalError("CourseQuestCollectionViewCell dequeuing failed!")
                    }
                    cell.configureCell(with: quest)
                    cell.onTapDetailButton = { [weak self] in
                        self?.onTapCourseQuestDetail?(quest)
                    }
                    return cell
                } else {
                    guard let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: QuestListCell.className,
                        for: indexPath
                    ) as? QuestListCell else {
                        fatalError("QuestListCell dequeuing failed!")
                    }
                    cell.configureCell(with: quest)
                    return cell
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

extension QuestListCollectionView: UICollectionViewDelegate {
    
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
