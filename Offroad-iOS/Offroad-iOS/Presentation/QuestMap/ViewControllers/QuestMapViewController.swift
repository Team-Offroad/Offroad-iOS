//
//  QuestMapViewController.swift
//  Offroad-iOS
//
//  Created by 김민성 on 2024/07/07.
//

import CoreLocation
import UIKit

import NMapsMap
import SnapKit
import Then

class QuestMapViewController: OffroadTabBarViewController {
    
    //MARK: - Properties
    
    private let rootView = QuestMapView()
    private let locationManager = CLLocationManager()
    
    let placeArray: [OffroadPlace] = []
    
    //MARK: - Life Cycle
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupButtonsAction()
        requestAuthorization()
        setupDelegates()
    }
    
}

extension QuestMapViewController {
    
    //MARK: - @objc
    
    @objc private func pushQuestListViewController() {
        print(#function)
        navigationController?.pushViewController(QuestQRViewController(), animated: true)
    }
    
    @objc private func pushPlaceListViewController() {
        print(#function)
        navigationController?.pushViewController(QuestQRViewController(), animated: true)
    }
    
    //MARK: - Private Func
    
    private func setupButtonsAction() {
        rootView.questListButton.addTarget(self, action: #selector(pushQuestListViewController), for: .touchUpInside)
        rootView.placeListButton.addTarget(self, action: #selector(pushPlaceListViewController), for: .touchUpInside)
    }
    
    private func requestAuthorization() {
        let status = locationManager.authorizationStatus
        switch status {
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
        case .restricted:
            //추후 에러 메시지 팝업 구현 가능성
            return
        case .denied:
            locationManager.requestAlwaysAuthorization()
        case .authorizedAlways:
            return
        case .authorizedWhenInUse:
            locationManager.requestAlwaysAuthorization()
        @unknown default:
            return
        }
    }
    
    private func setupDelegates() {
        rootView.naverMapView.mapView.addCameraDelegate(delegate: self)
    }
    
}

//MARK: - NMFMapViewCameraDelegate

extension QuestMapViewController: NMFMapViewCameraDelegate {
    
    func mapView(_ mapView: NMFMapView, cameraDidChangeByReason reason: Int, animated: Bool) {
        let orangeLocationOverlayImage = rootView.orangeLocationOverlayImage
        self.rootView.naverMapView.mapView.locationOverlay.icon = orangeLocationOverlayImage
    }
    
}
