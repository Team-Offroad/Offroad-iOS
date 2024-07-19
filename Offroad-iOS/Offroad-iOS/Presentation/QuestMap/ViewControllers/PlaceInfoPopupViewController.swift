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
    
    let tapGestureRecognizer = UITapGestureRecognizer()
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
        setupGestures()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        rootView.popupView.excutePresentPopupAnimation(anchorPoint: .init(x: 0.5, y: 1))
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
//        let placeCategory = placeInformation.placeCategory.lowercased()
//        if
//            placeCategory == OffroadPlaceCategory.park.rawValue.lowercased() ||
//                placeCategory == OffroadPlaceCategory.culture.rawValue.lowercased() ||
//                placeCategory == OffroadPlaceCategory.sport.rawValue.lowercased()
//        {
//            
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
                guard let self else { return }
                switch response {
                case .success(let result):
                    guard let data = result?.data else { return }
                    print(data)
                    let isValidPosition = data.isValidPosition
                    let characterImageURL = data.successCharacterImageUrl
                    
                    let tabBarController = navigationController.tabBarController
                    
                    let questResultViewController: QuestResultViewController
                    if isValidPosition {
                        
                        let placeCategory = placeInformation.placeCategory.lowercased()
                        if 
                            placeCategory == OffroadPlaceCategory.caffe.rawValue.lowercased() ||
                            placeCategory == OffroadPlaceCategory.restaurant.rawValue.lowercased() {
                            
                            navigationController.pushViewController(
                                QuestQRViewController(placeInformation: placeInformation),
                                animated: true
                            )
                            self.dismiss(animated: false)
                            
                        }
                        
                        return
//                        questResultViewController = QuestResultViewController(
//                            result: .success,
//                            superViewController: tabBarController,
//                            placeInfo: placeInformation,
//                            imageURL: characterImageURL
//                        )
                    } else {
                        questResultViewController = QuestResultViewController(
                            result: .wrongLocation,
                            superViewController: tabBarController,
                            placeInfo: placeInformation,
                            imageURL: characterImageURL
                        )
                    }
                    
                    guard let tabBarController = self.presentingViewController as? UITabBarController else {
                        return
                    }
                    
                    self.dismiss(animated: false) {
                        tabBarController.present(questResultViewController, animated: true)
                    }
                    
                default:
                    return
                }
            }
            // 결과 반환 후 present
            
//        } else {
//            navigationController.pushViewController(
//                QuestQRViewController(placeInformation: placeInformation),
//                animated: true
//            )
//            self.dismiss(animated: false)
//        }
    }
    
    @objc private func tapped() {
        print(#function)
        
        self.dismiss(animated: false)
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
    
    private func setupGestures() {
        rootView.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer.addTarget(self, action: #selector(tapped))
        tapGestureRecognizer.delegate = self
    }
    
    //MARK: - Func
    
    func configurePopupView() {
        rootView.configurePopupView(with: placeInformation)
    }
    
}


extension PlaceInfoPopupViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        print(#function)
        if gestureRecognizer == tapGestureRecognizer {
            if touch.view!.isDescendant(of: rootView.popupView)  {
                return true
            }
            return false
        }
        return false
    }
    
}
