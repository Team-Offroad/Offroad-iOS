//
//  AdventureMapViewController.swift
//  Offroad-iOS
//
//  Created by 김민성 on 12/26/24.
//

import CoreLocation
import UIKit

import NMapsMap
import RxSwift
import RxCocoa
import SnapKit
import Then

class AdventureMapViewController: OffroadTabBarViewController {
    
    //MARK: - Properties
    
    private let viewModel = AdventureMapViewModel()
    private let rootView = AdventureMapView()
    private let locationService = RegisteredPlaceService()
    
    private var disposeBag = DisposeBag()
    private var searchedPlaceArray: [RegisteredPlaceInfo] = []
    private var latestCategory: String?
    
    private var locationManager: CLLocationManager { viewModel.locationManager }
//    private var selectedMarker: ORBNMFMarker? = nil
    private var markerPoint: CGPoint? {
        guard let selectedMarker = rootView.orbMapView.selectedMarker else { return nil }
        let selectedMarkerPosition = rootView.orbMapView.mapView.projection.point(from: selectedMarker.position)
        return self.rootView.orbMapView.mapView.convert(selectedMarkerPosition, to: self.rootView)
    }
    
    private var currentPositionTarget: NMGLatLng {
        rootView.orbMapView.mapView.cameraPosition.target
    }
    
    //MARK: - Life Cycle
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindData()
        setupTooltipAction()
        setupDelegates()
        rootView.orbMapView.mapView.positionMode = .direction
        locationManager.startUpdatingHeading()
        rootView.orbMapView.mapView.moveCamera(.init(heading: 0))
        viewModel.checkLocationAuthorizationStatus { [weak self] authorizationCase in
            guard let self else { return }
            if authorizationCase != .fullAccuracy && authorizationCase != .reducedAccuracy {
                // 사용자 위치 불러올 수 없을 시 초기 위치 설정
                // 초기 위치: 광화문광장 (37.5716229, 126.9767879)
                rootView.orbMapView.moveCamera(scrollTo: .init(lat: 37.5716229, lng: 126.9767879), animationDuration: 0)
                self.viewModel.updateRegisteredPlaces(at: .init(lat: 37.5716229, lng: 126.9767879))
            }
        }
        viewModel.updateRegisteredPlaces(at: currentPositionTarget)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
        guard let offroadTabBarController = tabBarController as? OffroadTabBarController else { return }
        offroadTabBarController.showTabBarAnimation()
        
//        rootView.orbMapView.isCompassMode = false
        rootView.orbMapView.trackingMode = .normal
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let orangeLocationOverlayImage = rootView.locationOverlayImage
        rootView.orbMapView.mapView.locationOverlay.icon = orangeLocationOverlayImage
    }
    
}

extension AdventureMapViewController {
    
    //MARK: - Private Func
    
    private func switchTrackingMode() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            switch rootView.orbMapView.trackingMode {
            case .none:
                rootView.orbMapView.trackingMode = .direction
            case .normal:
                rootView.orbMapView.trackingMode = .direction
            case .direction:
                rootView.orbMapView.trackingMode = .compass
            case .compass:
                rootView.orbMapView.trackingMode = .direction
            @unknown default:
                return
            }
        }
    }
    
    private func bindData() {
        viewModel.startLoading
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: { [weak self] in
                self?.rootView.startCenterLoading(withoutShading: false)
        }).disposed(by: disposeBag)
        
        viewModel.stopLoading
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: { [weak self] in
                self?.rootView.stopCenterLoading()
            }).disposed(by: disposeBag)
        
        viewModel.networkFailureSubject
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: { [weak self] in
                self?.rootView.stopCenterLoading()
            }).disposed(by: disposeBag)
        
        viewModel.locationServicesDisabledRelay
            .observe(on: ConcurrentMainScheduler.instance)
            .subscribe { [weak self] _ in
                guard let self else { return }
                self.showToast(message: AlertMessage.locationServicesDisabledMessage, inset: 66)
            }.disposed(by: disposeBag)
        
        viewModel.locationUnauthorizedMessage
            .asDriver(onErrorJustReturn: "")
            .drive { [weak self] message in
                guard let self else { return }
                self.rootView.orbMapView.trackingMode = .none
                let alertController = ORBAlertController(
                    title: AlertMessage.locationUnauthorizedTitle,
                    message: message, type: .normal
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
                marker.mapView = self.rootView.orbMapView.mapView
            }).disposed(by: disposeBag)
        
        Observable.zip(
            viewModel.isLocationAuthorized.asObservable(),
            viewModel.successCharacterImage.asObservable(),
            viewModel.completeQuestList.asObservable(),
            viewModel.isFirstVisitToday.asObservable()
        )
        .observe(on: MainScheduler.instance)
        .subscribe(onNext: { [weak self] locationValidation, image, completeQuests, isFirstVisitToday in
            guard let self else { return }
            if locationValidation {
                self.viewModel.updateRegisteredPlaces(at: self.currentPositionTarget)
                MyInfoManager.shared.shouldUpdateCharacterAnimation.accept(latestCategory ?? "NONE")
                MyInfoManager.shared.didSuccessAdventure.accept(())
            }
            self.rootView.stopCenterLoading()
            if locationValidation && isFirstVisitToday {
                AmplitudeManager.shared.trackEvent(withName: AmplitudeEventTitles.exploreSuccess)
                rootView.orbMapView.hideTooltipAndUnselectMarker()
            }
            self.popupAdventureResult(isValidLocation: locationValidation,
                                      image: image,
                                      completeQuests: completeQuests,
                                      isFirstVisitToday: isFirstVisitToday)
        }).disposed(by: disposeBag)
        
        rootView.reloadPlaceButton.rx.tap.bind { [weak self] _ in
            guard let self else { return }
            self.rootView.reloadPlaceButton.isEnabled = false
            try? self.viewModel.markersSubject.value().forEach({ marker in marker.mapView = nil })
            self.viewModel.updateRegisteredPlaces(at: self.currentPositionTarget)
            self.rootView.orbMapView.hideTooltipAndUnselectMarker()
        }.disposed(by: disposeBag)
        
        rootView.switchTrackingModeButton.rx.tap.bind { [weak self] _ in
            guard let self else { return }
            
            viewModel.checkLocationAuthorizationStatus { [weak self] authorizationCase in
                guard let self else { return }
                switch authorizationCase {
                case .notDetermined:
                    return
                case .fullAccuracy, .reducedAccuracy:
                    self.switchTrackingMode()
                case .denied, .restricted:
                    self.viewModel.locationUnauthorizedMessage.accept(AlertMessage.locationUnauthorizedMessage)
                case .servicesDisabled:
                    self.viewModel.locationServicesDisabledRelay.accept(())
                }
            }
        }.disposed(by: disposeBag)
        
        rootView.questListButton.rx.tap.bind { [weak self] _ in
            guard let self else { return }
            self.navigationController?.pushViewController(QuestListViewController(), animated: true)
        }.disposed(by: disposeBag)
        
        rootView.placeListButton.rx.tap.bind {  [weak self] _ in
            guard let self else { return }
            self.navigationController?.pushViewController(PlaceListViewController(), animated: true)
        }.disposed(by: disposeBag)
        
        #if DevTarget
        MyDiaryManager.shared.didCompleteCreateDiary
            .bind { _ in
                guard let offroadTabBarController = self.tabBarController as? OffroadTabBarController else { return }
                
                if offroadTabBarController.selectedIndex == 1 {
                    MyDiaryManager.shared.showCompleteCreateDiaryAlert(viewController: self)
                }
            }
            .disposed(by: disposeBag)
        #endif
    }
    
    private func setupTooltipAction() {
        rootView.orbMapView.exploreButtonTapped.subscribe(onNext: { [weak self] _ in
            guard let self else { return }
            
            self.viewModel.checkLocationAuthorizationStatus { [weak self] authorizationCase in
                guard let self else { return }
                switch authorizationCase {
                case .notDetermined:
                    return
                case .fullAccuracy:
                    self.viewModel.authenticatePlaceAdventure(placeInfo: rootView.orbMapView.selectedMarker!.placeInfo)
                case .reducedAccuracy:
                    self.viewModel.locationUnauthorizedMessage.accept(AlertMessage.locationReducedAccuracyMessage)
                case .denied, .restricted:
                    self.viewModel.locationUnauthorizedMessage.accept(AlertMessage.locationUnauthorizedAdventureMessage)
                case .servicesDisabled:
                    self.viewModel.locationServicesDisabledRelay.accept(())
                }
            }
        }).disposed(by: disposeBag)
    }
    
    private func setupDelegates() {
        locationManager.delegate = self
    }
    
    private func focusToMyPosition(completion: ((Bool) -> Void)? = nil) {
        guard let currentCoord = locationManager.location?.coordinate else { return }
        let currentLatLng = NMGLatLng(lat: currentCoord.latitude, lng: currentCoord.longitude)
        rootView.orbMapView.moveCamera(scrollTo: currentLatLng, reason: 1) { isCancelled in
            completion?(isCancelled)
        }
    }
    
    /// 마커를 탭 시 동작할 함수
    ///- Parameters overlay: 탭 이벤트를 받아서 전달하는 NMFOverlay
    /// - Returns: `true`를 반환할 경우 마커를 탭 시 메서드를 실행. 그렇지 않을 경우 `NMFMapView`까지 이벤트가 전달되어 `NMFMapViewTouchDelegate`의 `mapView(_:didTapMap:point:)`가  호출됩니다.
    private func markerTouchHandler(overlay: NMFOverlay) -> Bool {
        guard let marker = overlay as? ORBNMFMarker else { return false }
        rootView.orbMapView.selectedMarker = marker
        rootView.orbMapView.configureTooltip(place: marker.placeInfo)
        rootView.orbMapView.showSelectedMarkerTooltip()
        return true
    }
    
    private func popupAdventureResult(
        isValidLocation: Bool,
        image: UIImage?,
        completeQuests: [CompleteQuest]?,
        isFirstVisitToday: Bool
    ) {
        let title: String = (isValidLocation && isFirstVisitToday
                             ? AlertMessage.adventureSuccessTitle
                             : AlertMessage.adventureFailureTitle)
        let message: String
        let buttonTitle: String
        
        // 탐험 성공
        if isValidLocation && isFirstVisitToday {
            message = AlertMessage.adventureSuccessMessage
            buttonTitle = "홈으로"
            
        // 위치는 맞으나, 해당 날짜에 두 번째 방문인 경우
        } else if isValidLocation && !isFirstVisitToday {
            message = AlertMessage.adventureFailureVisitCountMessage
            buttonTitle = "확인"
            
        // isValidLocation이 false인 경우 (잘못된 위치)
        } else {
            message = AlertMessage.adventureFailureLocationMessage
            buttonTitle = "확인"
        }
        
        let alertController = ORBAlertController(title: title, message: message, type: .explorationResult)
        alertController.configureExplorationResultImage { $0.image = image }
        alertController.configureMessageLabel {
            $0.highlightText(targetText: "위치", font: .offroad(style: .iosTextBold))
            $0.highlightText(targetText: "내일 다시", font: .offroad(style: .iosTextBold))
            if isValidLocation && !isFirstVisitToday {
                $0.highlightText(targetText: "한 번", font: .offroad(style: .iosTextBold))
            }
        }
        alertController.xButton.isHidden = true
        let okAction = ORBAlertAction(title: buttonTitle, style: .default) { [weak self] _ in
            guard isValidLocation && isFirstVisitToday else { return }
            self?.tabBarController?.selectedIndex = 0
            if let completeQuests {
                self?.popupQuestCompletion(completeQuests: completeQuests)
            }
        }
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
    
    private func popupQuestCompletion(completeQuests: [CompleteQuest]) {
        let message: String
        if completeQuests.count <= 0 {
            return
        } else if completeQuests.count == 1 {
            message = AlertMessage.completeSingleQuestMessage(questName: completeQuests.first!.name)
        } else { //if completeQuests.count > 1
            message = AlertMessage.completeMultipleQuestsMessage(
                firstQuestName: completeQuests.first!.name,
                questCount: completeQuests.count
            )
        }
        let questCompleteAlertController = ORBAlertController(
            title: AlertMessage.completeQuestsTitle,
            message: message,
            type: .normal
        )
        questCompleteAlertController.xButton.isHidden = true
        let action = ORBAlertAction(title: "확인", style: .default) { _ in
            AmplitudeManager.shared.trackEvent(withName: AmplitudeEventTitles.questSuccess)
            return
        }
        questCompleteAlertController.addAction(action)
        present(questCompleteAlertController, animated: true)
    }
    
}

//MARK: - CLLocationManagerDelegate

extension AdventureMapViewController: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
        func setLocationOverlayHiddenState(to isHidden: Bool) {
            DispatchQueue.main.async { [weak self] in
                self?.rootView.orbMapView.mapView.locationOverlay.hidden = isHidden
            }
        }
        
        viewModel.checkLocationAuthorizationStatus { authorizationCase in
            switch authorizationCase {
            case .notDetermined, .reducedAccuracy:
                return
            case .fullAccuracy:
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    self.rootView.orbMapView.hideTooltipAndUnselectMarker()
                    self.focusToMyPosition()
                    self.rootView.orbMapView.mapView.positionMode = .direction
                    setLocationOverlayHiddenState(to: false)
                }
            case .denied, .restricted:
                self.showToast(message: AlertMessage.locationUnauthorizedAdventureMessage, inset: 66)
                setLocationOverlayHiddenState(to: true)
            case .servicesDisabled:
                self.viewModel.locationServicesDisabledRelay.accept(())
                setLocationOverlayHiddenState(to: true)
            }
        }
    }
    
}

