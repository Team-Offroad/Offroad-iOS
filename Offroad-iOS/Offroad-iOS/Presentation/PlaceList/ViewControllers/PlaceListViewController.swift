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
    // 중복된 네트워크 요청을 막기 위한 flag
    private var isLoadingNewPlaces: Bool = false
    
    // 사용자 위치 불러올 수 없을 시 초기 위치 설정
    // 초기 위치: 광화문광장 (37.5716229, 126.9767879)
    private lazy var currentCoordinate = locationManager.location?.coordinate ?? .init(
        latitude: 37.5716229,
        longitude: 126.9767879
    )
    
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
        // 무한스크롤 중에 trigger로 인해 생기는 중복된 요청 방지
        guard !isLoadingNewPlaces else { return }
        isLoadingNewPlaces = true
        
        if distanceCursor == nil {
            rootView.scrollView.startCenterLoading(withoutShading: true)
        } else {
            unvisitedPlaceViewController.placeListCollectionView.startBottomScrollLoading()
            allPlacesViewController.placeListCollectionView.startBottomScrollLoading()
        }
        
        Task { [weak self] in
            guard let self else { return }
            
            // 네트워크 처리가 끝난 후에 실행할 동작. (로딩 애니메이션 제거)
            defer {
                self.rootView.scrollView.stopCenterLoading()
                self.unvisitedPlaceViewController.placeListCollectionView.stopBottomScrollLoading()
                self.allPlacesViewController.placeListCollectionView.stopBottomScrollLoading()
                self.isLoadingNewPlaces = false
            }
            
            do {
                let newModels = try await NetworkService.shared.placeService.getRegisteredListPlaces(
                    at: currentCoordinate,
                    limit: limit,
                    cursorDistance: distanceCursor
                )
                distanceCursor = newModels.last?.distanceFromUser
                self.allPlacesViewController.appendNewItems(newPlaces: newModels)
                self.unvisitedPlaceViewController.appendNewItems(
                    newPlaces: newModels.filter { $0.visitCount == 0 }
                )
            } catch let error as NetworkResultError {
                print(error.localizedDescription)
                switch error {
                case .httpError(_), .decodingFailed:
                    presentAlertMessage(message: "장소 목록을 받아오는 데 실패했습니다. 잠시 후 다시 시도해 주세요.")
                case .networkFailed, .networkTimeout:
                    presentAlertMessage(message: "장소 목록을 받아오는 데 실패했습니다. 네트워크 연결 상태를 확인해주세요.")
                }
            } catch {
                print("NetworkResultError가 아닌 다른 종류의 에러입니다.")
                print(error.localizedDescription)
            }
        }
    }
    
}

private extension PlaceListViewController {
    
    /// alert 를 띄우는 함수. 장소 목록을 불러오는 데 실패했을 경우 사용
    /// - Parameter message: alert에 띄울 메시지.
    func presentAlertMessage(message: String) {
        let alertController = ORBAlertController(message: message, type: .messageOnly)
        let okAction = ORBAlertAction(title: "확인", style: .default) { _ in return }
        present(alertController, animated: true)
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
