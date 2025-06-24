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
    private var markers: [PlaceMapMarker] = [] {
        didSet { places = markers.map(\.place) as! [ORBRecommendationPlaceModel] }
    }
    private var places: [ORBRecommendationPlaceModel] = []
    
    // MARK: - UI Properties
    
    private let emptyCaseView = ORBRecommendationEmptyCaseView()
    
    // MARK: - Life Cycle
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        setupButtonActions()
        updateFixedPhrase()
        initialSettings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let offroadTabBarController = self.tabBarController as? OffroadTabBarController else { return }
        offroadTabBarController.hideTabBarAnimation()
    }
    
    private func setupCollectionView() {
        rootView.recommendedContentView.register(
            PlaceListCell.self,
            forCellWithReuseIdentifier: PlaceListCell.className
        )
        rootView.recommendedContentView.dataSource = self
    }
    
    private func setupButtonActions() {
        rootView.backButton.rx.tap.subscribe { _ in
            self.navigationController?.popViewController(animated: true)
        }.disposed(by: disposeBag)
        
        rootView.orbMessageButton.rx.tap.subscribe { [weak self] _ in
            guard let self else { return }
            if UserDefaults.standard.bool(forKey: "useORBRecommendationChat") {
                self.presentChatViewController()
            } else {
                self.navigationController?.pushViewController(ORBRecommendationOrderViewController(), animated: true)
            }
        }.disposed(by: disposeBag)
        
        emptyCaseView.askButton.rx.tap
            .subscribe { [weak self] _ in
                self?.presentChatViewController()
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

// present 동작
private extension ORBRecommendationMainViewController {
    
    func presentChatViewController() {
        let chatViewController = ORBRecommendationChatViewController(
            firstChatText: self.rootView.orbMessageButton.message
        )
        
        // 추천소 채팅 뷰컨트롤러의 Combine 구독
        chatViewController.shouldUpdatePlaces
            .sink { [weak self] recommendedPlaces in
                self?.updateRecommendedPlaces(recommendedPlaces)
            }.store(in: &cancellables)
        
        chatViewController.view.layoutIfNeeded()
        chatViewController.transitioningDelegate = self
        chatViewController.modalPresentationStyle = .custom
        self.present(chatViewController, animated: true)
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
    
    // 오브의 추천소 초기 세팅. 처음 오브의 추천소 화면이 뜰 때 한 번만 호출됨. (viewDidLoad에서)
    // 실패 시 팝업 띄우도록 구현함. (추천소 채팅 화면에서는 실패 시 팝업이 아닌, 채팅 문구로 피드백)
    func initialSettings() {
        rootView.recommendedContentView.startCenterLoading(withoutShading: true)
        rootView.contentToolBar.isUserInteractionEnabled = false
        Task {
            defer {
                self.rootView.recommendedContentView.stopCenterLoading()
                self.rootView.contentToolBar.isUserInteractionEnabled = true
            }
            do {
                let networkService = NetworkService.shared.orbRecommendationService
                let recommendedPlaces = try await networkService.getRecommendedPlaces()
                self.updateRecommendedPlaces(recommendedPlaces)
            } catch let error as NetworkResultError {
                let message: String
                switch error {
                case .httpError, .decodingFailed, .networkCancelled, .unknown:
                    message = "오브의 추천 장소 목록을 불러오는데 실패했습니다.\n잠시 후 다시 시도해 주세요."
                case .timeout, .notConnectedToInternet, .unknownURLError:
                    message = "오브의 추천 장소 목록을 불러오는데 실패했습니다.\n\(ErrorMessages.networkError)"
                }
                
                // 데이터 불러오기 실패 시 alert 팝업 띄우는 코드.
                let alertController = ORBAlertController(message: message, type: .messageOnly)
                let okAction = ORBAlertAction(title: "확인", style: .default) { _ in return }
                alertController.addAction(okAction)
                alertController.xButton.isHidden = true
                self.present(alertController, animated: true)
            }
        }
    }
    
    func updateRecommendedPlaces(_ places: [ORBRecommendationPlaceModel]) {
        self.places = places
        rootView.recommendedContentView.reloadData()
        
        // 현재 떠 있는 마커 지도에서 지우기
        markers.forEach { $0.mapView = nil }
        // 지도에 새 장소들 마커 추가
        let newMarkers = places.map {
            let marker = PlaceMapMarker(place: $0)
            (marker.width, marker.height) = (26, 32)
            marker.mapView = rootView.orbMapView.mapView
            marker.touchHandler = { [weak self] _ in
                self?.rootView.orbMapView.showTooltip(marker)
                return true
            }
            return marker
        }
        markers = newMarkers
        
        // 새로 추천된 장소가 빈 경우 엠티 케이스 표시
        if newMarkers.isEmpty {
            rootView.recommendedContentView.showEmptyPlaceholder(view: emptyCaseView)
        } else {
            rootView.recommendedContentView.removeEmptyPlaceholder()
            let naverMapCoordinates: [NMGLatLng] = places.map { place in
                NMGLatLng(from: place.coordinate)
            }
            rootView.orbMapView.moveCamera(placesToShow: naverMapCoordinates, padding: 50)
        }
    }
    
}


// MARK: - UICollectionViewDataSource
extension ORBRecommendationMainViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return places.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PlaceListCell.className, for: indexPath) as? PlaceListCell else { fatalError("PlaceListCell dequeueing failed") }
        cell.configure(with: places[indexPath.item], isVisitCountShowing: false)
        return cell
    }
    
}
