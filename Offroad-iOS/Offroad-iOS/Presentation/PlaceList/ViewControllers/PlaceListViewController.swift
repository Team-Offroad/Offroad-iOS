//
//  PlaceListViewController.swift
//  Offroad-iOS
//
//  Created by 김민성 on 8/3/24.
//

import UIKit

import CoreLocation
import RxSwift
import RxCocoa

class PlaceListViewController: UIViewController {
    
    //MARK: - Properties
    
    var disposeBag = DisposeBag()
    
    let netWorkdDidFail = PublishRelay<Void>()
    let viewDidAppear = PublishRelay<Void>()
    
    let locationManager = CLLocationManager()
    let placeService = RegisteredPlaceService()
    var places: [RegisteredPlaceInfo] = []
    var placesNeverVisited: [RegisteredPlaceInfo] { places.filter { $0.visitCount == 0 } }
    var currentCoordinate: CLLocationCoordinate2D? { locationManager.location?.coordinate }
    var pageViewController: UIPageViewController {
        rootView.pageViewController
    }
    
    let operationQueue = OperationQueue()
    
    //MARK: - UI Properties
    
    let rootView = PlaceListView()
    lazy var viewControllerList: [UIViewController] = [
        PlaceListCollectionViewController(collectionView: rootView.placeNeverVisitedListCollectionView),
        PlaceListCollectionViewController(collectionView: rootView.allPlaceListCollectionView)
    ]
    
    //MARK: - Life Cycle
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindData()
        
        setupButtonsActions()
        setupCollectionView()
        setupDelegates()
        setPageViewControllerPage(to: 0)
        
        reloadCollectionViewData(limit: 100, isBounded: false)
        rootView.segmentedControl.selectSegment(index: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let offroadTabBarController = self.tabBarController as? OffroadTabBarController else { return }
        offroadTabBarController.hideTabBarAnimation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewDidAppear.accept(())
    }
        
}

extension PlaceListViewController {
    
    //MARK: - @objc Func
    
    @objc private func customBackButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func refreshCollectionView() {
        reloadCollectionViewData(limit: 100, isBounded: false)
    }
    
    //MARK: - Private Func
    
    private func bindData() {
        Observable.combineLatest(netWorkdDidFail, viewDidAppear)
            .subscribe { [weak self] _ in
                guard let self else { return }
                self.showToast(message: ErrorMessages.networkError, inset: 66)
            }
            .disposed(by: disposeBag)
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
        
        rootView.pageViewController.dataSource = self
        rootView.pageViewController.delegate = self
    }
    
    private func reloadCollectionViewData(coordinate: CLLocationCoordinate2D? = nil, limit: Int, isBounded: Bool) {
        rootView.segmentedControl.isUserInteractionEnabled = false
        rootView.pageViewController.view.isUserInteractionEnabled = false
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
        
        rootView.pageViewController.view.startLoading(withoutShading: true)
        placeService.getRegisteredPlace(requestDTO: placeRequestDTO) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let response):
                guard let responsePlaceArray = response?.data.places else { return }
                places = responsePlaceArray
//                self.rootView.activityIndicator.stopAnimating()
                rootView.pageViewController.view.stopLoading()
                
                self.rootView.allPlaceListCollectionView.refreshControl?.endRefreshing()
                self.rootView.placeNeverVisitedListCollectionView.refreshControl?.endRefreshing()

                self.rootView.allPlaceListCollectionView.reloadData()
                self.rootView.placeNeverVisitedListCollectionView.reloadData()
                
                self.rootView.segmentedControl.isUserInteractionEnabled = true
                self.rootView.pageViewController.view.isUserInteractionEnabled = true
                
            case .networkFail:
                netWorkdDidFail.accept(())
            default:
                return
            }
        }
    }
    
    private func setPageViewControllerPage(to targetIndex: Int) {
        rootView.pageViewController.view.isUserInteractionEnabled = false
        guard let currentViewCotnroller = pageViewController.viewControllers?.first else {
            // viewDidLoad에서 호출될 때 (처음 한 번)
            pageViewController.setViewControllers([viewControllerList.first!], direction: .forward, animated: false)
            return
        }
        guard let currentIndex = viewControllerList.firstIndex(of: currentViewCotnroller) else { return }
        guard targetIndex >= 0 else { return }
        guard targetIndex < rootView.segmentedControl.titles.count,
              targetIndex < viewControllerList.count
        else { return }
        
        pageViewController.setViewControllers(
            [viewControllerList[targetIndex]],
            direction: targetIndex > currentIndex ? .forward : .reverse,
            animated: true,
            completion: ({ [weak self] isCompleted in
                guard let self else { return }
                self.rootView.pageViewController.view.isUserInteractionEnabled = true
            })
        )
    }
    
}

//MARK: - ORBSegmentedControlDelegate

extension PlaceListViewController: ORBSegmentedControlDelegate {
    
    func segmentedControlDidSelect(segmentedControl: ORBSegmentedControl, selectedIndex: Int) {
        setPageViewControllerPage(to: selectedIndex)
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

//MARK: - UIPageViewControllerDataSource

extension PlaceListViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = viewControllerList.firstIndex(of: viewController) else { return nil }
        let previousIndex = index - 1
        if previousIndex < 0 { return nil }
        return viewControllerList[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = viewControllerList.firstIndex(of: viewController) else { return nil }
        let nextIndex = index + 1
        if nextIndex >= viewControllerList.count { return nil }
        return viewControllerList[nextIndex]
    }
    
}

//MARK: - UIPageViewControllerDelegate

extension PlaceListViewController: UIPageViewControllerDelegate {
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool
    ) {
        guard pageViewController.viewControllers?.first != nil else { return }
        if let index = viewControllerList.firstIndex(of: pageViewController.viewControllers!.first!) {
            rootView.segmentedControl.selectSegment(index: index)
        }
    }
    
}
