//
//  ORBRecommendedContentView.swift
//  ORB_Dev
//
//  Created by 김민성 on 4/20/25.
//

import CoreLocation
import UIKit

import ExpandableCell
import SnapKit

final class ORBRecommendedContentView: ExpandableCellCollectionView {
    
    private let topInset: CGFloat = 138.5
    private let locationManager = CLLocationManager()
    private let placeService = RegisteredPlaceService()
    
    // MARK: - UI Properties
    
    private let collectionViewContentBackground = UIView()
    
    var places: [PlaceModel] = []
    
    init() {
        let contentInset: UIEdgeInsets = .init(top: topInset, left: 0, bottom: 0, right: 0)
        let sectionInset: UIEdgeInsets = .init(top: 19.5, left: 24, bottom: 19.5, right: 24)
        super.init(contentInset: contentInset, sectionInset: sectionInset, minimumLineSpacing: 16)
        
        setupStyle()
        setupHierarchy()
        setupLayout()
        locationManager.startUpdatingLocation()
        setupCollectionView()
        getInitialPlaceData()
        panGestureRecognizer.delegate = self
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        sendSubviewToBack(collectionViewContentBackground)
    }
    
}

// Initial Setting
private extension ORBRecommendedContentView {
    
    func setupStyle() {
        backgroundColor = .clear
        delaysContentTouches = false
        collectionViewContentBackground.backgroundColor = .primary(.listBg)
        collectionViewContentBackground.isUserInteractionEnabled = false
    }
    
    func setupHierarchy() {
        addSubviews(
            collectionViewContentBackground
        )
    }
    
    func setupLayout() {
        collectionViewContentBackground.snp.makeConstraints { make in
            make.top.equalTo(contentLayoutGuide)
            make.horizontalEdges.bottom.equalTo(frameLayoutGuide)
        }
    }
    
    func setupCollectionView() {
        dataSource = self
        register(PlaceListCell.self, forCellWithReuseIdentifier: PlaceListCell.className)
    }
    
    func getInitialPlaceData() {
        guard let currentLocation = locationManager.location else { return }
        placeService.getRegisteredListPlaces(
            latitude: currentLocation.coordinate.latitude,
            longitude: currentLocation.coordinate.longitude,
            limit: 100) { [weak self] result in
            switch result {
            case .success(let data):
                guard let data = data?.data else { return }
                do {
                    self?.places = try data.places.map({ try PlaceModel($0) })
                    self?.reloadData()
                } catch {
                    print(error.localizedDescription)
                }
            default:
                return
            }
        }
    }
    
}

extension ORBRecommendedContentView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return places.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PlaceListCell.className, for: indexPath) as? PlaceListCell else { fatalError("PlaceListCell dequeueing failed") }
        cell.configure(with: places[indexPath.item], isVisitCountShowing: true)
        return cell
    }
    
}


// MARK: - UICollectionViewDelegate

extension ORBRecommendedContentView: UIGestureRecognizerDelegate {
    
    // 상단 contentInset 영역 터치 시 제스처 무효화
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let touchPoint = touch.location(in: self)
        if touchPoint.y < 0 {
            // 아래로 땡긴 후 원래 자리로 돌아가는 중에 상단 여백에서 스크롤 시도 시
            if isDecelerating {
                if let mainView = superview as? ORBRecommendationMainView {
                    mainView.showORBMessageButton()
                }
            }
            return false // 스크롤 시작하지 않음
        }
        return true
    }
    
}
