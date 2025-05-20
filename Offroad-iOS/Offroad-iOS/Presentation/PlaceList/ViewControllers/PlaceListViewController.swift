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
    
    /// 안 가본 곳 목록을 나타내는 목록을 나타내는 뷰 컨트롤러
    private lazy var unvisitedPlaceViewController = PlaceListCollectionViewController(
        place: currentCoordinate,
        showVisitCount: false
    )
    /// 전체 장소 목록을 나타내는 뷰 컨트롤러
    private lazy var allPlacesViewController = PlaceListCollectionViewController(
        place: currentCoordinate,
        showVisitCount: true
    )
    
    private lazy var rootView = PlaceListView(
        viewAllPlaces: allPlacesViewController.view,
        viewUnvisitedPlaces: unvisitedPlaceViewController.view
    )
    
    private let locationManager = CLLocationManager()
    private var disposeBag = DisposeBag()
    private var distanceCursor: Double?
    
    // 사용자 위치 불러올 수 없을 시 초기 위치 설정
    // 초기 위치: 광화문광장 (37.5716229, 126.9767879)
    private lazy var currentCoordinate = locationManager.location?.coordinate ?? .init(latitude: 37.5716229,
                                                                                       longitude: 126.9767879)
    
    //MARK: - Life Cycle
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupButtonsActions()
        handleRxEvents()
        setupDelegates()
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
        unvisitedPlaceViewController.lastCellWillBeDisplayed
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
        rootView.scrollView.delegate = self
    }
    
    private func loadAdditionalPlaces(limit: Int) {
        rootView.segmentedControl.isUserInteractionEnabled = false
        if distanceCursor == nil {
            rootView.scrollView.startCenterLoading(withoutShading: true)
        } else {
            unvisitedPlaceViewController.placeListCollectionView.startBottomScrollLoading()
            allPlacesViewController.placeListCollectionView.startBottomScrollLoading()
        }
        
        NetworkService.shared.placeService.getRegisteredListPlaces(
            latitude: currentCoordinate.latitude,
            longitude: currentCoordinate.longitude,
            limit: limit,
            cursorDistance: distanceCursor
        ) { [weak self] result in
            guard let self else { return }
            
            defer {
                rootView.scrollView.stopCenterLoading()
                unvisitedPlaceViewController.placeListCollectionView.stopBottomScrollLoading()
                allPlacesViewController.placeListCollectionView.stopBottomScrollLoading()
                
                self.rootView.segmentedControl.isUserInteractionEnabled = true
                self.rootView.scrollView.isUserInteractionEnabled = true
            }
            
            switch result {
            case .success(let response):
                guard let responsePlaces = response?.data.places else { return }
                guard responsePlaces.count != 0 else { return }
                distanceCursor = responsePlaces.last?.distanceFromUser
                do {
                    let newModels = try responsePlaces.map { try PlaceModel($0) }
                    allPlacesViewController.appendNewItems(newPlaces: newModels)
                    unvisitedPlaceViewController.appendNewItems(newPlaces: newModels.filter({ $0.visitCount == 0 }))
                } catch {
                    fatalError(error.localizedDescription)
                }
            default:
                return
            }
        }
    }
    
}

//MARK: - ORBSegmentedControlDelegate

extension PlaceListViewController: ORBSegmentedControlDelegate {
    
    func segmentedControlDidSelect(segmentedControl: ORBSegmentedControl, selectedIndex: Int) {
        // NOTE: scrollView에서 setContentOffset(...animated: true) 를 사용할 경우 underbar 위치가 튀는 현상 발생
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1) { [weak self] in
            guard let self else { return }
            self.rootView.scrollView.contentOffset.x = self.rootView.scrollView.bounds.width * CGFloat(selectedIndex)
        }
        // 아이폰 미러링 시 popGesture(screenEdgeGesture)와 스크롤 뷰의 가로 스크롤 제스처가 동시에 적용되는 문제 방지
        navigationController?.interactivePopGestureRecognizer?.isEnabled = (selectedIndex == 0)
    }
    
}

extension PlaceListViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let xOffset = scrollView.contentOffset.x
        let process = xOffset / scrollView.frame.width
        rootView.segmentedControl.setUnderbarPosition(process: process)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let process = scrollView.contentOffset.x / scrollView.frame.width
        let targetIndex: Int = Int(round(process))
        rootView.segmentedControl.selectSegment(index: targetIndex)
    }
    
}
