//
//  PlaceInfoPopupViewController.swift
//  Offroad-iOS
//
//  Created by 김민성 on 2024/07/17.
//

import CoreLocation
import UIKit

import SnapKit
import Then

class PlaceInfoPopupViewController: UIViewController {
    
    //MARK: - Properties
    
    let placeInformation: RegisteredPlaceInfo
    let locationManager: CLLocationManager
    
    init(placeInfo: RegisteredPlaceInfo, locationManager: CLLocationManager) {
        self.placeInformation = placeInfo
        self.locationManager = locationManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let rootView = PlaceInfoPopupView()
    var superViewControlller: UIViewController? = nil
    
//    let superView
    
    override func loadView() {
        view = rootView
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupButtonsAction()
    }
    
}


extension PlaceInfoPopupViewController {
    
    //MARK: - @objc Func
    
    @objc private func closePopupView() {
        print(#function)
        dismiss(animated: false)
    }
    
    @objc private func explore() {
        print(#function)
        
        guard let navigationController = superViewControlller as? UINavigationController else {
            print("not navicon")
            return
        }
        
        //분기처리
        let placeCategory = placeInformation.placeCategory.lowercased()
        if
            placeCategory == OffroadPlaceCategory.park.rawValue.lowercased() ||
                placeCategory == OffroadPlaceCategory.culture.rawValue.lowercased() ||
                placeCategory == OffroadPlaceCategory.sport.rawValue.lowercased()
        {
            
            let placeRequestDTO = AdventuresPlaceAuthenticationRequestDTO(
                placeId: placeInformation.id,
                latitude: locationManager.location!.coordinate.latitude,
                longitude: locationManager.location!.coordinate.longitude
            )
            
            print(locationManager.location!.coordinate)
            print(placeInformation)
            // 위치 대조 API
            NetworkService.shared.adventureService.authenticatePlaceAdventure(
                adventureAuthDTO: placeRequestDTO
            ) { [weak self] response in
                switch response {
                case .success(let result):
                    guard let data = result?.data else { return }
                    print(data)
                    let isValidPosition = data.isValidPosition
                    let characterImageURL = data.successCharacterImageUrl
                    self?.showAlert(
                        title: isValidPosition ? "탐험 성공" : "탐험 실패",
                        message: "캐릭터 이미지 URL: \(characterImageURL)"
                    )
                    
                    if isValidPosition {  }
                default:
                    return
                }
            }
            // 결과 반환 후 present
            
        } else {
            navigationController.pushViewController(
                QuestQRViewController(placeInformation: placeInformation),
                animated: true
            )
            self.dismiss(animated: false)
        }
    }
    
    //MARK: - Private Func
    
    private func setupButtonsAction() {
        rootView.closeButton.addTarget(self, action: #selector(closePopupView), for: .touchUpInside)
        rootView.exploreButton.addTarget(self, action: #selector(explore), for: .touchUpInside)
    }
    
    private func showAlert(title: String, message: String) {
        print(#function)
        DispatchQueue.main.async { [weak self] in
            let alertCon = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
            let okAction = UIAlertAction(title: "넵!", style: .default)
            alertCon.addAction(okAction)
            
            self?.present(alertCon, animated: true)
        }
    }
    
    //MARK: - Func
    
    func configurePopupView() {
        rootView.configurePopupView(with: placeInformation)
    }
    
}
