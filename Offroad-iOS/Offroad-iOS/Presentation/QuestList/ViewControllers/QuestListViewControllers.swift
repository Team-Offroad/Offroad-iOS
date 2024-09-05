//
//  QuestListViewControllers.swift
//  Offroad-iOS
//
//  Created by 김민성 on 8/10/24.
//

import UIKit

class QuestListViewController: UIViewController {

    //MARK: - Properties

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
// (이 주석은 Issue 해결 후 삭제할 예정)
// 서버의 API가 어떤 식으로 나올 지 아직 몰라서,
// 우선 현재는 모든 퀘스트 정보를 불러오고, 스위치를 토글하면, 받아온 진행 정보를 바탕으로 필터링하여 보여주는 방식으로 구현하였습니다.
// 만약 서버의 API에서 '전체 퀘스트'와 '진행 중인 퀘스트'만을 요청하는 API가 존재한다면, 해당 API를 사용하여 구현하여도 좋습니다.

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
