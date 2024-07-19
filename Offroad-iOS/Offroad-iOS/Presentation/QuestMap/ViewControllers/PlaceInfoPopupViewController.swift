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
    let marker: OffroadNMFMarker
    let rootView = PlaceInfoPopupView()
    var superViewControlller: UIViewController? = nil
    
    //MARK: - Life Cycle
    
    init(placeInfo: RegisteredPlaceInfo, locationManager: CLLocationManager, marker: OffroadNMFMarker) {
        self.placeInformation = placeInfo
        self.locationManager = locationManager
        self.marker = marker
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupButtonsAction()
        setupGestures()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        rootView.popupView.executePresentPopupAnimation(
            initialAlpha: 1,
            initialScale: 0,
            duration: 0.3,
            delay: 0.1,
            dampingRatio: 0.8,
            anchorPoint: .init(x: 0.5, y: 1)
        )
        
        // tooptip에 popup animation이 들어가서 tooltip과 함께 배경색의 변화도 애니메이션을 줌>
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.rootView.backgroundColor = .blackOpacity(.black15)
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tapGestureRecognizer.isEnabled = true
    }
    
}


extension PlaceInfoPopupViewController {
    
    //MARK: - @objc Func
    
    @objc private func closePopupView() {
        // tooptip에 popup animation이 들어가서 tooltip과 함께 배경색의 변화도 애니메이션을 줌>
        UIView.animate(withDuration: 0.2) { [weak self] in self?.rootView.backgroundColor = .clear }
        
        tapGestureRecognizer.isEnabled = false
        marker.hidden = false
        rootView.popupView.executeDismissPopupAnimation(
            destinationAlpha: 0.3,
            destinationScale: 0.01,
            duration: 0.3,
            delay: 0,
            dampingRatio: 1,
            anchorPoint: CGPoint(x: 0.5, y: 1)) { [weak self] _ in self?.dismiss(animated: false) }
    }
    
    @objc private func explore() {
        print(#function)
        
        guard let navigationController = superViewControlller as? UINavigationController else {
            print("not navicon")
            return
        }
        
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
                
                guard !isValidPosition else {
                    let placeCategory = placeInformation.placeCategory.lowercased()
                    if
                        placeCategory == OffroadPlaceCategory.caffe.rawValue.lowercased() || 
                        placeCategory == OffroadPlaceCategory.restaurant.rawValue.lowercased()
                    {
                        navigationController.pushViewController(
                            QuestQRViewController(placeInformation: placeInformation),
                            animated: true
                        )
                        marker.hidden = false
                        self.dismiss(animated: false)
                    }
                    return
                }
                
                let questResultViewController = QuestResultViewController(
                    result: .wrongLocation,
                    superViewController: tabBarController,
                    placeInfo: placeInformation,
                    imageURL: characterImageURL
                )
                questResultViewController.modalPresentationStyle = .formSheet
                guard let tabBarController = self.presentingViewController as? UITabBarController else {
                    return
                }
                marker.hidden = false
                self.dismiss(animated: false) {
                    tabBarController.present(questResultViewController, animated: true)
                }
                
            default:
                return
            }
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
    
    private func setupGestures() {
        rootView.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer.addTarget(self, action: #selector(closePopupView))
        tapGestureRecognizer.delegate = self
    }
    
    //MARK: - Func
    
    func configurePopupView() {
        rootView.configurePopupView(with: placeInformation)
    }
    
}

//MARK: - UIGestureRecognizerDelegate

extension PlaceInfoPopupViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if gestureRecognizer == tapGestureRecognizer && !touch.view!.isDescendant(of: rootView.popupView) {
            return true
        }
        //closePopupView()
        return false
    }
    
}
