//
//  ORBRecommendationMainViewController.swift
//  ORB_Dev
//
//  Created by 김민성 on 4/20/25.
//

import Combine
import UIKit

import NMapsMap
import RxSwift
import RxCocoa

final class ORBRecommendationMainViewController: UIViewController {
    
    // MARK: - Properties
    
    private let rootView = ORBRecommendationMainView()
    private var disposeBag = DisposeBag()
    // RxSwift의 DisposeBag 역할
    private var cancellables = Set<AnyCancellable>()
    private var markers: [PlaceMapMarker] = []
    
    // MARK: - Life Cycle
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupButtonActions()
        updateFixedPhrase()
        updateRecommendedPlaces()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let offroadTabBarController = self.tabBarController as? OffroadTabBarController else { return }
        offroadTabBarController.hideTabBarAnimation()
    }
    
    private func setupButtonActions() {
        rootView.backButton.rx.tap.subscribe { _ in
            self.navigationController?.popViewController(animated: true)
        }.disposed(by: disposeBag)
        
        rootView.orbMessageButton.rx.tap.subscribe { [weak self] _ in
            guard let self else { return }
            if UserDefaults.standard.bool(forKey: "useORBRecommendationChat") {
                let chatViewController = ORBRecommendationChatViewController(
                    firstChatText: self.rootView.orbMessageButton.message
                )
                
                // 추천소 채팅 뷰컨트롤러의 Combine 구독
                chatViewController.shouldUpdatePlaces
                    .sink { [weak self] in
                        self?.updateRecommendedPlaces()
                    }.store(in: &cancellables)
                
                chatViewController.view.layoutIfNeeded()
                chatViewController.transitioningDelegate = self
                chatViewController.modalPresentationStyle = .custom
                self.present(chatViewController, animated: true)
            } else {
                self.navigationController?.pushViewController(ORBRecommendationOrderViewController(), animated: true)
            }
        }.disposed(by: disposeBag)
    }
    
}


// Custom Transition 관련
extension ORBRecommendationMainViewController {
    
    /// present 트랜지션이 시작할 때 버튼을 숨기기
    func hideORBMessageButtonBeforePresent() {
        rootView.orbMessageButton.isHidden = true
    }
    
    /// dismiss 트랜지션이 시작할 때 버튼 보이기
    func showORBMessageButtonBeforeDismiss() {
        rootView.orbMessageButton.isHidden = false
    }
    
}


extension ORBRecommendationMainViewController: UIViewControllerTransitioningDelegate {
    
    func presentationController(
        forPresented presented: UIViewController,
        presenting: UIViewController?,
        source: UIViewController
    ) -> UIPresentationController? {
        guard let chatViewController = presented as? ORBRecommendationChatViewController,
              let mainViewController = source as? ORBRecommendationMainViewController
        else {
            fatalError()
        }
        return ORBRecommendationViewPresentationController(
            presentedViewController: chatViewController,
            presenting: presenting,
            sourceViewController: mainViewController
        )
    }
    
    func animationController(
        forPresented presented: UIViewController,
        presenting: UIViewController,
        source: UIViewController
    ) -> (any UIViewControllerAnimatedTransitioning)? {
        if UIAccessibility.isReduceMotionEnabled {
            return nil
        } else {
            return ORBRecommendationChatViewPresentingTransition(
                buttonFrame: rootView.orbMessageButton.frame,
                buttonText: rootView.orbMessageButton.message
            )
        }
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> (any UIViewControllerAnimatedTransitioning)? {
        return ORBRecommendationChatViewDismissingTransition()
    }
    
}

// 뷰의 컨텐츠 업데이트 관련
private extension ORBRecommendationMainViewController {
    
    func updateFixedPhrase() {
        Task { [weak self] in
            let networkService = NetworkService.shared.orbRecommendationService
            let fixedPhrase = try? await networkService.getFixedPhrase()
            // 에러 종류에 상관없이 고정 문구 받아오는 데 실패한 경우 에러를 사용자에게 안내하는 대신 다음과 같이 기본값 적용.
            self?.rootView.orbMessageButton.message =
            fixedPhrase ?? "어라! 어디 가고 싶은 곳이 있는 표정이야! 나 추천 오브 츄링이한테 말해봐 츄츄~"
        }
    }
    
    func updateRecommendedPlaces() {
        Task { [weak self] in
            let networkService = NetworkService.shared.orbRecommendationService
            do {
                let recommendedPlaces = try await networkService.getRecommendedPlaces()
                // 장소 목록 셀 업데이트하기
                self?.rootView.recommendedContentView.places = recommendedPlaces
                self?.rootView.recommendedContentView.reloadData()
                
                // 지도에 마커 추가
                let newMarkers = recommendedPlaces.map {
                    let marker = PlaceMapMarker(place: $0)
                    (marker.width, marker.height) = (26, 32)
                    marker.mapView = self?.rootView.orbMapView.mapView
                    marker.touchHandler = { overlay in
                        self?.rootView.orbMapView.showTooltip(marker)
                        return true
                    }
                    return marker
                }
                self?.markers = newMarkers
                
                // 모든 장소가 모두 보일 곳으로 이동하기
                let naverMapCoordinates: [NMGLatLng] = recommendedPlaces.map { place in
                    NMGLatLng(from: place.coordinate)
                }
                self?.rootView.orbMapView.moveCamera(placesToShow: naverMapCoordinates, padding: 50)
                
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
}
