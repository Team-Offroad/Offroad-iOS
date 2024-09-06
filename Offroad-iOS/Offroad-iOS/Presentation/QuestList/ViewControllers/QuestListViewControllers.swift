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
    private var questArray: [Quest] = []

    private var dummyDataSource: [QuestDTO] = []
    private let questListDummyData: [QuestDTO] = QuestListDummyDataManager().makeDummyData()

    private let operationQueue = OperationQueue()

    //MARK: - UI Properties

    private let rootView = QuestListView()

    //MARK: - Life Cycle

    override func loadView() {
        view = rootView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setNavigationController()
        setupNavigationControllerGesture()
        setupControlsTarget()
        setupCollectionView()
        setupDelegates()
        reloadCollectionView()
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
        rootView.questListCollectionView.reloadData()
    }
    
    @objc private func refreshCollectionView() {
        reloadCollectionView()
    }

    //MARK: - Private Func

    private func setNavigationController() {
        self.navigationItem.setHidesBackButton(true, animated: false)
    }

    private func setupNavigationControllerGesture() {
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
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
        
        rootView.questListCollectionView.reloadData()
    }

    private func setupDelegates() {
        rootView.questListCollectionView.dataSource = self
        rootView.questListCollectionView.delegate = self
    }
    
    private func reloadCollectionView(isActive: Bool = false) {
        questListService.getQuestList(isActive: isActive) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let response):
                guard let questListFromServer = response?.data.questList else { return }
                self.questArray = questListFromServer
                self.rootView.activityIndicatorView.stopAnimating()
                self.rootView.questListCollectionView.refreshControl?.endRefreshing()
                self.rootView.questListCollectionView.reloadData()
                
            default:
                return
            }
        }
    }

}

//MARK: - UIGestureRecognizerDelegate

extension QuestListViewController: UIGestureRecognizerDelegate {

    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        // Navigation stack에서 root view controller가 아닌 경우에만 pop 제스처를 허용
        return navigationController!.viewControllers.count > 1
    }

}

//MARK: - UICollectionViewDataSource

extension QuestListViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if rootView.ongoingQuestToggle.isOn {
            return questArray.filter({ $0.currentCount > 0 && $0.currentCount < $0.totalCount }).count
        } else {
            return questArray.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: QuestListCollectionViewCell.className,
            for: indexPath
        ) as? QuestListCollectionViewCell else { fatalError("cell dequeing Failed!") }
        
        if rootView.ongoingQuestToggle.isOn {
            cell.configureCell(
                with: questArray.filter({ $0.currentCount > 0 && $0.currentCount < $0.totalCount })[indexPath.item]
            )
        } else {
            cell.configureCell(with: questArray[indexPath.item])
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

}
