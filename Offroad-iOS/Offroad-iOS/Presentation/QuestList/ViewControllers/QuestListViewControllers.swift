//
//  QuestListViewControllers.swift
//  Offroad-iOS
//
//  Created by 김민성 on 8/10/24.
//

import UIKit

class QuestListViewController: UIViewController {

    //MARK: - Properties
    
    private var questListService = QuestListService()
    private var allQuestList: [Quest] = []
    private var activeQuestList: [Quest] = []
    private var arraySize = 12
    private var lastCursorID = Int()
    
    private var isActive = false {
        didSet {
            loadQuestList(isActive: isActive, size: arraySize)
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
        loadQuestList(isActive: isActive, size: 12)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
        isActive = sender.isOn
        rootView.questListCollectionView.setContentOffset(.zero, animated: false)
        rootView.questListCollectionView.reloadData()
    }
    
    @objc private func refreshCollectionView() {
        arraySize = 12
        loadQuestList(isActive: isActive, size: arraySize)
        rootView.questListCollectionView.reloadData()
    }

    //MARK: - Private Func
    
    private func setupControlsTarget() {
        rootView.customBackButton.addTarget(self, action: #selector(customBackButtonTapped), for: .touchUpInside)
        rootView.ongoingQuestToggle.addTarget(self, action: #selector(ongoingQuestSwitchValueChanged(sender:)), for: .valueChanged)
        rootView.questListCollectionView.refreshControl?.addTarget(self, action: #selector(refreshCollectionView), for: .valueChanged)
    }
    
    private func setupCollectionView() {
        rootView.questListCollectionView.register(
            QuestListCollectionViewCell.self,
            forCellWithReuseIdentifier: QuestListCollectionViewCell.className
        )
    }

    private func setupDelegates() {
        rootView.questListCollectionView.dataSource = self
        rootView.questListCollectionView.delegate = self
    }
    
    private func loadQuestList(isActive: Bool, cursor: Int = 1, size: Int) {
        questListService.getQuestList(isActive: isActive, cursor: cursor, size: size) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let response):
                guard let questListFromServer = response?.data.questList else { return }
                if isActive {
                    self.activeQuestList = questListFromServer
                } else {
                    self.allQuestList = questListFromServer
                }
                self.rootView.activityIndicatorView.stopAnimating()
                self.rootView.questListCollectionView.refreshControl?.endRefreshing()
                self.rootView.questListCollectionView.reloadData()
                
                lastCursorID = questListFromServer.last?.cursorId ?? Int()
            default:
                return
            }
        }
    }

}

//MARK: - UICollectionViewDataSource

extension QuestListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isActive {
            return activeQuestList.count
        } else {
            return allQuestList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: QuestListCollectionViewCell.className,
            for: indexPath
        ) as? QuestListCollectionViewCell else { fatalError("cell dequeing Failed!") }
        
        if isActive {
            cell.configureCell(with: activeQuestList[indexPath.item]
            )
        } else {
            cell.configureCell(with: allQuestList[indexPath.item])
        }
        
        return cell
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
            if arraySize < lastCursorID {
                arraySize += 12
                loadQuestList(isActive: isActive, size: arraySize)
            }
        }
    }
}
