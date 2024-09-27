//
//  PlaceListViewController.swift
//  Offroad-iOS
//
//  Created by 김민성 on 8/3/24.
//

import UIKit
import CoreLocation

class PlaceListViewController: UIViewController {
    
    //MARK: - Properties
    
    let locationManager = CLLocationManager()
    let placeService = RegisteredPlaceService()
    var places: [RegisteredPlaceInfo] = []
    var placesNeverVisited: [RegisteredPlaceInfo] { places.filter { $0.visitCount == 0 } }
    var currentCoordinate: CLLocationCoordinate2D? { locationManager.location?.coordinate }
    
    let operationQueue = OperationQueue()
    
    //MARK: - UI Properties
    
    let rootView = PlaceListView()
    
    //MARK: - Life Cycle
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationController()
        setupNavigationControllerGesture()
        setupButtonsActions()
        setupCollectionView()
        setupDelegates()
        
        reloadCollectionViewData(limit: 100, isBounded: false)
        rootView.segmentedControl.selectSegment(index: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let offroadTabBarController = self.tabBarController as? OffroadTabBarController else { return }
        offroadTabBarController.hideTabBarAnimation()
    }
        
}

extension PlaceListViewController {
    
    //MARK: - @objc Func
    
    @objc private func customBackButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func refreshCollectionView() {
        reloadCollectionViewData(limit: 100, isBounded: true)
    }
    
    //MARK: - Private Func
    
    private func setNavigationController() {
        self.navigationController?.navigationBar.isHidden = true
        self.navigationItem.setHidesBackButton(true, animated: false)
    }
    
    private func setupNavigationControllerGesture() {
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    private func setupButtonsActions() {
        rootView.customBackButton.addTarget(self, action: #selector(customBackButtonTapped), for: .touchUpInside)
    }
    
    private func setupCollectionView() {
        rootView.placeNeverVisitedListCollectionView.register(
            PlaceCollectionViewCell.self,
            forCellWithReuseIdentifier: PlaceCollectionViewCell.className
        )
        rootView.placeNeverVisitedListCollectionView.refreshControl = UIRefreshControl()
        rootView.placeNeverVisitedListCollectionView.refreshControl?.tintColor = .sub(.sub)
        rootView.placeNeverVisitedListCollectionView.refreshControl?
            .addTarget(self, action: #selector(refreshCollectionView), for: .valueChanged)
        
        rootView.allPlaceListCollectionView.register(
            PlaceCollectionViewCell.self,
            forCellWithReuseIdentifier: PlaceCollectionViewCell.className
        )
        rootView.allPlaceListCollectionView.refreshControl = UIRefreshControl()
        rootView.allPlaceListCollectionView.refreshControl?.tintColor = .sub(.sub)
        rootView.allPlaceListCollectionView.refreshControl?
            .addTarget(self, action: #selector(refreshCollectionView), for: .valueChanged)
    }
    
    private func setupDelegates() {
        rootView.segmentedControl.delegate = self
        
        rootView.placeNeverVisitedListCollectionView.dataSource = self
        rootView.placeNeverVisitedListCollectionView.delegate = self
        
        rootView.allPlaceListCollectionView.dataSource = self
        rootView.allPlaceListCollectionView.delegate = self
    }
    
    private func reloadCollectionViewData(coordinate: CLLocationCoordinate2D? = nil, limit: Int, isBounded: Bool) {
        guard let currentCoordinate else {
            print("현재 위치 좌표를 구할 수 없음")
            // 위치 정보 불러올 수 없을 경우 피드백 논의하기
            return
        }
        let placeRequestDTO = RegisteredPlaceRequestDTO(
            currentLatitude: currentCoordinate.latitude,
            currentLongitude: currentCoordinate.longitude,
            limit: limit,
            isBounded: isBounded
        )
        placeService.getRegisteredLocation(requestDTO: placeRequestDTO) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let response):
                guard let responsePlaceArray = response?.data.places else { return }
                places = responsePlaceArray
                self.rootView.activityIndicator.stopAnimating()
                
                self.rootView.allPlaceListCollectionView.refreshControl?.endRefreshing()
                self.rootView.placeNeverVisitedListCollectionView.refreshControl?.endRefreshing()

                self.rootView.allPlaceListCollectionView.reloadData()
                self.rootView.placeNeverVisitedListCollectionView.reloadData()
            default:
                return
            }
        }
    }
    
}

//MARK: - UIGestureRecognizerDelegate

extension PlaceListViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        // Navigation stack에서 root view controller가 아닌 경우에만 pop 제스처를 허용
        return navigationController!.viewControllers.count > 1
    }
    
}

//MARK: - OFRSegmentedControlDelegate

extension PlaceListViewController: OFRSegmentedControlDelegate {
    
    func segmentedControlDidSelected(segmentedControl: OFRSegmentedControl, selectedIndex: Int) {
        rootView.placeNeverVisitedListCollectionView.isHidden = selectedIndex != 0
        rootView.allPlaceListCollectionView.isHidden = selectedIndex != 1
    }
    
}

//MARK: - UICollectionViewDataSource

extension PlaceListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == rootView.placeNeverVisitedListCollectionView {
            return placesNeverVisited.count
        } else {
            return places.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PlaceCollectionViewCell.className,
            for: indexPath
        ) as? PlaceCollectionViewCell else { fatalError("cell dequeing Failed!") }
        
        if collectionView == rootView.placeNeverVisitedListCollectionView {
            cell.configureCell(with: placesNeverVisited[indexPath.item], showingVisitingCount: false)
        } else if collectionView == rootView.allPlaceListCollectionView {
            cell.configureCell(with: places[indexPath.item], showingVisitingCount: true)
        }
        return cell
    }
    
}

//MARK: - UICollectionViewDelegate

extension PlaceListViewController: UICollectionViewDelegate {
    
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
