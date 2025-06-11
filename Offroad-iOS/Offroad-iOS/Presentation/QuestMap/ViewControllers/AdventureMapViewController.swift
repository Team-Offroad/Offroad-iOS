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
    private var currentPositionTarget: NMGLatLng {
        rootView.orbMapView.mapView.cameraPosition.target
    }
    
    private var locationAuthorizationStatus: AdventureMapViewModel.LocationAuthorizationCase {
        get async { await viewModel.locationAuthorizationStatus }
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
        
        Task { [weak self] in
            guard let self else { return }
            let locationAuthorizationStatus = await self.viewModel.locationAuthorizationStatus
            switch locationAuthorizationStatus {
            case .fullAccuracy, .reducedAccuracy:
                self.viewModel.updateRegisteredPlaces(at: self.currentPositionTarget)
            default:
                // 사용자 위치 불러올 수 없을 시 초기 위치 설정
                // 초기 위치: 광화문광장 (37.5716229, 126.9767879)
                self.rootView.orbMapView.moveCamera(scrollTo: .init(lat: 37.5716229, lng: 126.9767879), animationDuration: 0)
                self.viewModel.updateRegisteredPlaces(at: .init(lat: 37.5716229, lng: 126.9767879))
                
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
        guard let offroadTabBarController = tabBarController as? OffroadTabBarController else { return }
        offroadTabBarController.showTabBarAnimation()
        
        rootView.orbMapView.trackingMode = .normal
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let orangeLocationOverlayImage = rootView.locationOverlayImage
        rootView.orbMapView.mapView.locationOverlay.icon = orangeLocationOverlayImage
    }
    
}

extension AdventureMapViewController {
    
    // MARK: - Private Func
    
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
        
        viewModel.locationServicesDisabledRelay
            .observe(on: MainScheduler.instance)
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
                let okAction = ORBAlertAction(title: "설정으로 이동", style: .default) { _ in
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                }
                alertController.addAction(okAction)
                self.present(alertController, animated: true)
            }.disposed(by: disposeBag)
        
        // 새 위치 정보(마커 정보)를 받아왔을 때 뷰에 바인딩.
        viewModel.markers
            .asDriver()
            .do(onNext: { [weak self] _ in self?.rootView.stopCenterLoading() })
            .drive(onNext: { [weak self] markers in
                guard let self else { return }
                markers.forEach { marker in
                    // 마커 탭 시 동작 정의 (툴팁 띄우도록)
                    marker.touchHandler = { [weak self] overlay in
                        guard let marker = overlay as? ORBNMFMarker else { return false }
                        self?.rootView.orbMapView.showTooltip(marker)
                        return true
                    }
                    // 마커 지도에 표시
                    marker.mapView = self.rootView.orbMapView.mapView
                }
            }).disposed(by: disposeBag)
        
        // 새 위치 정보(마커 정보)를 받아오는 과정에서 에러가 발생한 경우.
        viewModel.markersError
            .observe(on: MainScheduler.instance)
            .do(onNext: { [weak self] _ in self?.rootView.stopCenterLoading() })
            .subscribe(onNext: {  [weak self] error in
                if let networkResultError = error as? NetworkResultError {
                    switch networkResultError {
                    case .timeout, .notConnectedToInternet, .unknownURLError:
                        self?.showToast(message: "장소 목록을 받아오지 못했어요. \(ErrorMessages.networkError)", inset: 66)
                    case .httpError, .decodingFailed, .networkCancelled, .unknown:
                        self?.showToast(message: "장소 목록을 받아오지 못했어요. 잠시 후 다시 시도해 주세요.", inset: 66)
                    }
                } else {
                    self?.showToast(message: "장소 목록을 받아오지 못했어요. 잠시 후 다시 시도해 주세요.", inset: 66)
                }
            }).disposed(by: disposeBag)
        
        // 위치 기반 탐험 결과를 성공적으로 받아온 경우 실행할 동작 정의
        viewModel.placeAuthenticationResult
            .observe(on: MainScheduler.instance)
            .do(onNext: { [weak self] _ in self?.rootView.stopCenterLoading() })
            .subscribe(onNext: { [weak self] adventureResult in
                guard let self else { return }
                // 탐험이 성공하면? -> 위치 정보를 업데이트하고, 툴팁을 숨기고, 홈 화면의 캐릭터 애니메이션 종류 업데이트.
                if adventureResult.isAdventureSuccess {
                    self.viewModel.updateRegisteredPlaces(at: self.currentPositionTarget)
                    self.rootView.orbMapView.hideTooltip()
                    MyInfoManager.shared.shouldUpdateCharacterAnimation.accept(
                        adventureResult.place.placeCategory.rawValue
                    )
                }
                self.popupAdventureResult(adventureResult)
            }).disposed(by: disposeBag)
        
        // 위치 기반 탐험 결과를 받아오는 과정에서 발생하는 에러를 구독
        viewModel.placeAuthenticationError
            .observe(on: MainScheduler.instance)
            .do(onNext: { [weak self] _ in self?.rootView.stopCenterLoading() })
            .subscribe(onNext: {  [weak self] error in
                if let networkResultError = error as? NetworkResultError {
                    switch networkResultError {
                    case .timeout, .notConnectedToInternet, .unknownURLError:
                        self?.showToast(message: "탐험에 실패했어요.\n\(ErrorMessages.networkError)", inset: 66)
                    case .httpError, .decodingFailed, .networkCancelled, .unknown:
                        self?.showToast(message: "탐험에 실패했어요. 잠시 후 다시 시도해 주세요.", inset: 66)
                    }
                } else {
                    self?.showToast(message: "탐험에 실패했어요. 잠시 후 다시 시도해 주세요.", inset: 66)
                }
            }).disposed(by: disposeBag)
        
        rootView.reloadPlaceButton.rx.tap.bind { [weak self] _ in
            guard let self else { return }
            self.rootView.reloadPlaceButton.isEnabled = false
            self.viewModel.updateRegisteredPlaces(at: self.currentPositionTarget)
            self.rootView.orbMapView.hideTooltip()
        }.disposed(by: disposeBag)
        
        rootView.switchTrackingModeButton.rx.tap.bind { [weak self] _ in
            guard let self else { return }
            Task { [weak self] in
                guard let self else { return }
                switch await self.locationAuthorizationStatus {
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
        
        rootView.orbMapView.tooltipWillShow.subscribe(onNext: { [weak self] in
            self?.rootView.compass.isHidden = true
        }).disposed(by: disposeBag)
        
        rootView.orbMapView.tooltipDidHide.subscribe(onNext: { [weak self] in
            self?.rootView.compass.isHidden = false
        }).disposed(by: disposeBag)
        
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
        rootView.orbMapView.exploreButtonTapped.subscribe(
            // 툴팁의 탐험하기 버튼 탭 후 정상적으로 장소 데이터와 함께 이벤트를 받아온 경우
            onNext: { [weak self] place in
                Task { [weak self] in
                    guard let self else { return }
                    switch await self.locationAuthorizationStatus {
                    case .notDetermined:
                        return
                    case .fullAccuracy:
                        self.viewModel.authenticatePlaceAdventure(placeInfo: place)
                    case .reducedAccuracy:
                        self.viewModel.locationUnauthorizedMessage.accept(AlertMessage.locationReducedAccuracyMessage)
                    case .denied, .restricted:
                        self.viewModel.locationUnauthorizedMessage.accept(AlertMessage.locationUnauthorizedAdventureMessage)
                    case .servicesDisabled:
                        self.viewModel.locationServicesDisabledRelay.accept(())
                    }
                }
            }
        ).disposed(by: disposeBag)
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
    
    private func popupAdventureResult(
        _ result: AdventureResult
    ) {
        let title: String = (
            result.isAdventureSuccess
            ? AlertMessage.adventureSuccessTitle
            : AlertMessage.adventureFailureTitle
        )
        let message: String
        let buttonTitle: String
        let isValidPosition = result.isValidPosition
        let isFirstVisitToday = result.isFirstVisitToday
        
        switch (isValidPosition, isFirstVisitToday) {
        case (true, true):
            // 탐험 성공
            message = AlertMessage.adventureSuccessMessage
            buttonTitle = "홈으로"
        case (true, false):
            // 위치는 맞으나, 해당 날짜에 두 번째 방문인 경우
            message = AlertMessage.adventureFailureVisitCountMessage
            buttonTitle = "확인"
        default:
            // isValidLocation이 false인 경우 (위치 인증 실패)
            message = AlertMessage.adventureFailureLocationMessage
            buttonTitle = "확인"
        }
        
        let alertController = ORBAlertController(title: title, message: message, type: .explorationResult)
        alertController.configureExplorationResultImage { $0.image = result.resultImage }
        alertController.configureMessageLabel {
            $0.highlightText(targetText: "위치", font: .offroad(style: .iosTextBold))
            $0.highlightText(targetText: "내일 다시", font: .offroad(style: .iosTextBold))
            if isValidPosition && !isFirstVisitToday {
                $0.highlightText(targetText: "한 번", font: .offroad(style: .iosTextBold))
            }
        }
        alertController.xButton.isHidden = true
        let okAction = ORBAlertAction(title: buttonTitle, style: .default) { [weak self] _ in
            guard isValidPosition && isFirstVisitToday else { return }
            self?.tabBarController?.selectedIndex = 0
            if let completeQuests = result.completedQuests {
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

// MARK: - CLLocationManagerDelegate

extension AdventureMapViewController: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
        func setLocationOverlayHiddenState(to isHidden: Bool) {
            DispatchQueue.main.async { [weak self] in
                self?.rootView.orbMapView.mapView.locationOverlay.hidden = isHidden
            }
        }
        
        Task { [weak self] in
            guard let self else { return }
            switch await self.locationAuthorizationStatus {
            case .notDetermined, .reducedAccuracy:
                return
            case .fullAccuracy:
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    self.rootView.orbMapView.hideTooltip()
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

