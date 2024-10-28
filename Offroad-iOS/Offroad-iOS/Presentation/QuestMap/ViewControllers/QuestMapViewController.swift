//
//  QuestMapViewController.swift
//  Offroad-iOS
//
//  Created by 김민성 on 2024/07/07.
//

import CoreLocation
import UIKit

import NMapsMap
import RxSwift
import RxCocoa
import SnapKit
import Then

class QuestMapViewController: OffroadTabBarViewController {
    
    //MARK: - Properties
    
    private let viewModel = QuestMapViewModel()
    private let rootView = QuestMapView()
    
    private let locationManager = CLLocationManager()
    private let locationService = RegisteredPlaceService()
    private var currentZoomLevel: Double = 14
    private var searchedPlaceArray: [RegisteredPlaceInfo] = []
//    private var viewModel.selectedMarker: NMFMarker? = nil
    private var isFocused: Bool = false
    private var currentLocation: NMGLatLng = NMGLatLng(lat: 0, lng: 0)
    
    private var disposeBag = DisposeBag()
    
    private var markerPoint: CGPoint? {
        guard let selectedMarker = viewModel.selectedMarker else { return nil }
        let selectedMarkerPosition = rootView.naverMapView.mapView.projection.point(from: selectedMarker.position)
        return self.rootView.naverMapView.mapView.convert(selectedMarkerPosition, to: self.rootView)
    }
    
    private var currentPositionTarget: NMGLatLng {
        rootView.naverMapView.mapView.cameraPosition.target
    }
    
    
    //MARK: - UI Properties
    
    var tooltipWindow: PlaceInfoTooltipWindow!
    
    //MARK: - Life Cycle
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindData()
//        setupButtonsAction()
        setupDelegates()
        rootView.naverMapView.mapView.positionMode = .direction
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
        guard let offroadTabBarController = tabBarController as? OffroadTabBarController else { return }
        offroadTabBarController.showTabBarAnimation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewModel.requestAuthorization()
        viewModel.updateRegisteredPlaces(at: currentPositionTarget)
        rootView.naverMapView.mapView.positionMode = .disabled
        let orangeLocationOverlayImage = rootView.orangeLocationOverlayImage
        rootView.naverMapView.mapView.locationOverlay.icon = orangeLocationOverlayImage
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        guard tooltipWindow == nil else { return }
        let naverMapViewFrame = self.rootView.naverMapView.frame
        let contentFrame = CGRect(
            origin: naverMapViewFrame.origin,
            size: .init(
                width: naverMapViewFrame.width,
                height: naverMapViewFrame.height - (view.safeAreaInsets.bottom + 107)
            )
        )
        tooltipWindow = PlaceInfoTooltipWindow(contentFrame: contentFrame)
        bindTooltip()
        tooltipWindow.makeKeyAndVisible()
    }
    
}

extension QuestMapViewController {
    
    //MARK: - @objc
    
    @objc private func switchTrackingMode() {
        
        if viewModel.selectedMarker != nil {
            tooltipWindow.placeInfoViewController.rootView.tooltipAnchorPoint = markerPoint!
            tooltipWindow.placeInfoViewController.hideTooltip { [weak self] in
                guard let self else { return }
                self.tooltipWindow = nil
            }
        }
        
        if rootView.naverMapView.mapView.positionMode == .normal {
            flyToMyPosition { [weak self] in self?.rootView.naverMapView.mapView.positionMode = .compass }
            rootView.customizeLocationOverlaySubIcon(state: .compass)
        } else {
            rootView.naverMapView.mapView.positionMode = .normal
            let orangeLocationOverlayImage = rootView.orangeLocationOverlayImage
            rootView.naverMapView.mapView.locationOverlay.icon = orangeLocationOverlayImage
            rootView.naverMapView.mapView.locationOverlay.subIcon = nil
        }
        
    }
    
    //MARK: - Private Func
    
    private func bindTooltip() {
        self.tooltipWindow.placeInfoViewController.shouldHideTooltip
            .debug()
            .subscribe(onNext: { [weak self] in
                guard let self else { return }
                self.tooltipWindow.placeInfoViewController.hideTooltip {
                    self.viewModel.selectedMarker = nil
                }
            }).disposed(by: disposeBag)
        
        self.tooltipWindow.placeInfoViewController.rootView.tooltip.exploreButton.rx.tap.bind { [weak self] _ in
            guard let self else { return }
            print("explore!!")
            self.viewModel.authenticatePlaceAdventure(placeInfo: viewModel.selectedMarker!.placeInfo)
            self.tooltipWindow.placeInfoViewController.hideTooltip()
        }.disposed(by: disposeBag)
    }
    
    private func bindData() {
        viewModel.networkFailureSubject
            .subscribe(onNext: { [weak self] in
                guard let self else { return }
                self.showToast(message: "네트워크 연결 상태를 확인해주세요.", inset: 66)
            }).disposed(by: disposeBag)
        
        viewModel.shouldRequestLocationAuthorization
            .subscribe { _ in
                let alertController = ORBAlertController(
                    title: "위치 접근 권한이 막혀있습니다.",
                    message: "위치 정보 권한을 허용해 주세요", type: .normal
                )
                let okAction = ORBAlertAction(title: "확인", style: .default) { _ in return }
                alertController.addAction(okAction)
                self.present(alertController, animated: true)
            }.disposed(by: disposeBag)
        
        viewModel.markersSubject
            .flatMap { Observable.from($0) }
            .subscribe(onNext: { [weak self] marker in
                guard let self else { return }
                marker.touchHandler = { [weak self] overlay in
                    guard let self else { return false }
                    return self.markerTouchHandler(overlay: overlay)
                }
                marker.mapView = self.rootView.naverMapView.mapView
            }).disposed(by: disposeBag)
        
        Observable.combineLatest(
            viewModel.isLocationAdventureAuthenticated,
            viewModel.successCharacterImage,
            viewModel.completeQuestList
        )
        .filter({ success, image, completeQuests in image != nil })
        .observe(on: MainScheduler.instance)
        .subscribe(onNext: { [weak self] success, image, completeQuests in
            guard let self else { return }
            self.popupAdventureResult(isSuccess: success, image: image!)
        }).disposed(by: disposeBag)
        
        rootView.reloadPlaceButton.rx.tap.bind { [weak self] _ in
            guard let self else { return }
            try? self.viewModel.markersSubject.value().forEach({ marker in marker.mapView = nil })
            self.viewModel.updateRegisteredPlaces(at: self.currentPositionTarget)
        }.disposed(by: disposeBag)
        
        rootView.switchTrackingModeButton.rx.tap.bind { [weak self] _ in
            guard let self else { return }
            self.switchTrackingMode()
        }.disposed(by: disposeBag)
        
        rootView.questListButton.rx.tap.bind { [weak self] _ in
            guard let self else { return }
            self.navigationController?.pushViewController(QuestListViewController(), animated: true)
        }.disposed(by: disposeBag)
        
        rootView.placeListButton.rx.tap.bind {  [weak self] _ in
            guard let self else { return }
            self.navigationController?.pushViewController(PlaceListViewController(), animated: true)
        }.disposed(by: disposeBag)
    }
    
    private func setupDelegates() {
        rootView.naverMapView.mapView.addCameraDelegate(delegate: self)
    }
    
    private func focusToMarker(_ marker: NMFMarker) {
        currentZoomLevel = rootView.naverMapView.mapView.zoomLevel
        let markerLatLng = NMGLatLng(lat: marker.position.lat, lng: marker.position.lng)
        let cameraUpdate = NMFCameraUpdate(scrollTo: markerLatLng)
        cameraUpdate.animation = .easeOut
        rootView.naverMapView.mapView.moveCamera(cameraUpdate)
    }
    
    private func flyToMyPosition(completion: @escaping () -> Void) {
        guard let currentCoord = locationManager.location?.coordinate else { return }
        let currentLatLng = NMGLatLng(lat: currentCoord.latitude, lng: currentCoord.longitude)
        let cameraUpdate = NMFCameraUpdate(scrollTo: currentLatLng)
        cameraUpdate.animation = .easeOut
        rootView.naverMapView.mapView.moveCamera(cameraUpdate) { isCancelled in
            completion()
        }
    }
    
    private func markerTouchHandler(overlay: NMFOverlay) -> Bool {
        guard let marker = overlay as? OffroadNMFMarker else { return false }
        self.viewModel.selectedMarker = marker
        self.focusToMarker(marker)
        self.tooltipWindow.placeInfoViewController.rootView.tooltip.configure(with: marker.placeInfo)
        self.tooltipWindow.placeInfoViewController.rootView.tooltipAnchorPoint = markerPoint!
        self.tooltipWindow.placeInfoViewController.showToolTip()
        return true
    }
    
    private func popupAdventureResult(isSuccess: Bool, image: UIImage) {
        let title: String = isSuccess ? "탐험 성공" : "탐험 실패"
        let message: String = isSuccess ? "탐험에 성공했어요!\n이곳에 무엇이 있는지 천천히 살펴볼까요?" : "탐험에 실패했어요.\n위치를 다시 한 번 확인해주세요."
        let buttonTitle: String = isSuccess ? "홈으로" : "확인"
        let alertController = ORBAlertController(title: title, message: message, type: .explorationResult)
        alertController.configureExplorationResultImage { $0.image = image }
        alertController.configureMessageLabel { $0.highlightText(targetText: "위치") }
        let okAction = ORBAlertAction(title: buttonTitle, style: .default) { _ in
            self.tabBarController?.selectedIndex = 0
        }
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
    
}

//MARK: - NMFMapViewCameraDelegate

extension QuestMapViewController: NMFMapViewCameraDelegate {
    
    func mapView(_ mapView: NMFMapView, cameraWillChangeByReason reason: Int, animated: Bool) {
        print(#function)
        if reason == -2 {
            let orangeLocationOverlayImage = rootView.orangeLocationOverlayImage
            rootView.naverMapView.mapView.locationOverlay.icon = orangeLocationOverlayImage
            rootView.naverMapView.mapView.locationOverlay.subIcon = nil
        }
        
        if viewModel.selectedMarker != nil {
            tooltipWindow.placeInfoViewController.rootView.tooltipAnchorPoint = markerPoint!
            // 사용자 제스처로 움직였을 시
            guard reason == -1 else { return }
            tooltipWindow.placeInfoViewController.hideTooltip { [weak self] in
                guard let self else { return }
                self.viewModel.selectedMarker = nil
            }
        }
    }
    
    func mapView(_ mapView: NMFMapView, cameraIsChangingByReason reason: Int) {
        print(#function)
        if viewModel.selectedMarker != nil {
            tooltipWindow.placeInfoViewController.rootView.tooltipAnchorPoint = markerPoint!
        }
    }
    
    func mapView(_ mapView: NMFMapView, cameraDidChangeByReason reason: Int, animated: Bool) {
        print(#function)
        let orangeLocationOverlayImage = rootView.orangeLocationOverlayImage
        rootView.naverMapView.mapView.locationOverlay.icon = orangeLocationOverlayImage
        if reason == -1 {
            rootView.naverMapView.mapView.locationOverlay.subIcon = nil
        }
    }
    
    func mapViewCameraIdle(_ mapView: NMFMapView) {
        print(#function)
    }
    
    
    
}
