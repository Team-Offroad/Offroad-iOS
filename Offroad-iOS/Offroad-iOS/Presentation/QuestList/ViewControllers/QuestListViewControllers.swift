//
//  QuestListViewControllers.swift
//  Offroad-iOS
//
//  Created by 김민성 on 8/10/24.
//

import UIKit

class QuestListViewController: UIViewController {

    //MARK: - Properties

    var dummyDataSource: [QuestDTO] = []
    let questListDummyData: [QuestDTO] = QuestListDummyDataManager().makeDummyData()

    let operationQueue = OperationQueue()
    private(set) var isSearchingAllList: Bool = false

    //MARK: - UI Properties

    let rootView = QuestListView()

    //MARK: - Life Cycle

    override func loadView() {
        view = rootView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setNavigationController()
        setupNavigationControllerGesture()
        setupButtonsActions()
        setupSwitchActions()
        setupCollectionView()
        setupDelegates()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let offroadTabBarController = self.tabBarController as? OffroadTabBarController else { return }
        offroadTabBarController.hideTabBarAnimation()
    }

}

extension QuestListViewController {

    //MARK: - Private Func

    private func setNavigationController() {
        self.navigationItem.setHidesBackButton(true, animated: false)
    }

    private func setupNavigationControllerGesture() {
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }

    private func setupButtonsActions() {
        rootView.customBackButton.addTarget(self, action: #selector(customBackButtonTapped), for: .touchUpInside)
    }
    
    private func setupSwitchActions() {
        rootView.ongoingQuestToggle.addTarget(self, action: #selector(ongoingQuestSwitchValueChanged(sender:)), for: .valueChanged)
    }

    @objc private func customBackButtonTapped() {
        print(#function)
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func ongoingQuestSwitchValueChanged(sender: UISwitch) {
        rootView.questListCollectionView.reloadData()
        //rootView.questListCollectionView.collectionViewLayout.invalidateLayout()
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
            return questListDummyData.filter({ $0.process > 0 && $0.process < $0.totalProcess }).count
        } else {
            return questListDummyData.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: QuestListCollectionViewCell.className,
            for: indexPath
        ) as? QuestListCollectionViewCell else { fatalError("cell dequeing Failed!") }
        
        if rootView.ongoingQuestToggle.isOn {
            cell.configureCell(
                with: questListDummyData.filter({ $0.process > 0 && $0.process < $0.totalProcess })[indexPath.item]
            )
        } else {
            cell.configureCell(with: questListDummyData[indexPath.item])
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
