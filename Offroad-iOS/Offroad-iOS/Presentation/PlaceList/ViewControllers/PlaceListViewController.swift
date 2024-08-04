//
//  PlaceListViewController.swift
//  Offroad-iOS
//
//  Created by 김민성 on 8/3/24.
//

import UIKit

class PlaceListViewController: UIViewController {
    
    let dummyData: [RegisteredPlaceInfo] = PlaceListDummyDataManager.makeDummyData()
    
    let rootView = PlaceListView()
//    let animator = UIViewPropertyAnimator(duration: 0.3, dampingRatio: 1)
//    let updateAnimator = UIViewPropertyAnimator(duration: 0.3, dampingRatio: 1)
    
    
    let operationQueue = OperationQueue()
    
    var recentDeselectedIndexPath = IndexPath(item: 0, section: 0)
    var isAnimationEnd: Bool = true {
        didSet {
            print("isAnimationEndOldValue: \(oldValue)")
            print("isAnimationEnd: \(isAnimationEnd)")
        }
    }
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setNavigationController()
        setupNavigationControllerGesture()
        setupButtonsActions()
        setupCollectionView()
        setupDelegates()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        rootView.customSegmentedControl.selectSegment(index: 0)
        
        guard let offroadTabBarController = self.tabBarController as? OffroadTabBarController else { return }
        offroadTabBarController.hideTabBarAnimation()
    }
        
}


extension PlaceListViewController {
    
    private func setupNavigationBar() {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    private func setNavigationController() {
        self.navigationItem.setHidesBackButton(true, animated: false)
    }
    
    private func setupNavigationControllerGesture() {
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    private func setupButtonsActions() {
        rootView.customBackButton.addTarget(self, action: #selector(customBackButtonTapped), for: .touchUpInside)
    }
    
    @objc private func customBackButtonTapped() {
        print(#function)
        navigationController?.popViewController(animated: true)
    }
    
    private func setupCollectionView() {
        rootView.placeListCollectionView.register(
            PlaceListCollectionViewCell.self,
            forCellWithReuseIdentifier: PlaceListCollectionViewCell.className
        )
        rootView.placeListCollectionView.reloadData()
    }
    
    private func setupDelegates() {
        rootView.customSegmentedControl.delegate = self
        rootView.placeListCollectionView.dataSource = self
        rootView.placeListCollectionView.delegate = self
    }
    
}


//MARK: - UIGestureRecognizerDelegate

extension PlaceListViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        print(#function)
        
        // Navigation stack에서 root view controller가 아닌 경우에만 pop 제스처를 허용
        return navigationController!.viewControllers.count > 1
    }
    
}

//MARK: - PlaceListSegmentedControlDelegate

extension PlaceListViewController: PlaceListSegmentedControlDelegate {
    
    func segmentedControlDidSelected(segmentedControl: PlaceListSegmentedControl, selectedIndex: Int) {
        print("\(selectedIndex) 선택됨")
    }
    
}


//MARK: - UICollectionViewDataSource

extension PlaceListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dummyData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PlaceListCollectionViewCell.className,
            for: indexPath
        ) as? PlaceListCollectionViewCell else { fatalError("cel dequeing Failed!") }
        cell.configureCell(with: dummyData[indexPath.item])
        return cell
    }
    
    
}

//MARK: - UICollectionViewDelegate

extension PlaceListViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        
        let animator = UIViewPropertyAnimator(duration: 0.4, dampingRatio: 1)
        
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
