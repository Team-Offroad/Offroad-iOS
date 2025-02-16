//
//  PlaceListViewController.swift
//  Offroad-iOS
//
//  Created by 김민성 on 8/3/24.
//

import CoreLocation
import UIKit

import RxSwift
import RxCocoa
import SnapKit

class PlaceListViewController: UIViewController {
    
    //MARK: - Properties
    
    private let rootView = PlaceListView()
    private let operationQueue = OperationQueue()
    private let locationManager = CLLocationManager()
    
    private var disposeBag = DisposeBag()
    private var distanceCursor: Double?
    private var pageViewController: UIPageViewController { rootView.pageViewController }
    
    // 사용자 위치 불러올 수 없을 시 초기 위치 설정
    // 초기 위치: 광화문광장 (37.5716229, 126.9767879)
    private lazy var currentCoordinate = locationManager.location?.coordinate ?? .init(latitude: 37.5716229,
                                                                                       longitude: 126.9767879)
    private lazy var unvistedPlaceViewController = PlaceListCollectionViewController(
        place: currentCoordinate,
        showVisitCount: false
    )
    private lazy var allPlacesViewController = PlaceListCollectionViewController(
        place: currentCoordinate,
        showVisitCount: true
    )
    private lazy var viewControllerList: [UIViewController] = [unvistedPlaceViewController, allPlacesViewController]
    
    //MARK: - Life Cycle
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupButtonsActions()
        handleRxEvents()
        setupDelegates()
        setPageViewControllerPage(to: 0)
        
        loadAdditionalPlaces(limit: 12)
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
    
    //MARK: - Private Func
        
    private func setupButtonsActions() {
        rootView.customBackButton.addTarget(self, action: #selector(customBackButtonTapped), for: .touchUpInside)
    }
    
    private func handleRxEvents() {
        unvistedPlaceViewController.lastCellWillBeDisplayed
            .subscribe(onNext: { [weak self] in
                self?.loadAdditionalPlaces(limit: 12)
            }).disposed(by: disposeBag)
        
        allPlacesViewController.lastCellWillBeDisplayed
            .subscribe(onNext: { [weak self] in
                self?.loadAdditionalPlaces(limit: 12)
            }).disposed(by: disposeBag)
    }
    
    private func setupDelegates() {
        rootView.segmentedControl.delegate = self
        
        rootView.pageViewController.dataSource = self
        rootView.pageViewController.delegate = self
    }
    
    private func loadAdditionalPlaces(limit: Int) {
        rootView.segmentedControl.isUserInteractionEnabled = false
        if distanceCursor == nil {
            rootView.pageViewController.view.startLoading(withoutShading: true)
        } else {
            unvistedPlaceViewController.placeListCollectionView.startScrollLoading(direction: .bottom)
            allPlacesViewController.placeListCollectionView.startScrollLoading(direction: .bottom)
        }
        
        NetworkService.shared.placeService.getRegisteredListPlaces(
            latitude: currentCoordinate.latitude,
            longitude: currentCoordinate.longitude,
            limit: limit,
            cursorDistance: distanceCursor
        ) { [weak self] result in
            guard let self else { return }
            
            defer {
                rootView.pageViewController.view.stopLoading()
                unvistedPlaceViewController.placeListCollectionView.stopScrollLoading(direction: .bottom)
                allPlacesViewController.placeListCollectionView.stopScrollLoading(direction: .bottom)
                
                self.rootView.segmentedControl.isUserInteractionEnabled = true
                self.rootView.pageViewController.view.isUserInteractionEnabled = true
            }
            
            switch result {
            case .success(let response):
                guard let responsePlaces = response?.data.places else { return }
                guard responsePlaces.count != 0 else { return }
                distanceCursor = responsePlaces.last?.distanceFromUser
                allPlacesViewController.appendNewItems(newPlaces: responsePlaces)
                unvistedPlaceViewController.appendNewItems(newPlaces: responsePlaces.filter({ $0.visitCount == 0 }))
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
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        guard pageViewController.viewControllers?.first != nil else { return }
        rootView.segmentedControl.isUserInteractionEnabled = false
    }
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool
    ) {
        guard pageViewController.viewControllers?.first != nil else { return }
        rootView.segmentedControl.isUserInteractionEnabled = true
        if let index = viewControllerList.firstIndex(of: pageViewController.viewControllers!.first!) {
            rootView.segmentedControl.selectSegment(index: index)
        }
    }
    
}
