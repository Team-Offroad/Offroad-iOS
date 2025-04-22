//
//  ORBRecommendedContentView.swift
//  ORB_Dev
//
//  Created by 김민성 on 4/20/25.
//

import CoreLocation
import UIKit

import ExpandableCell
import RxSwift
import RxCocoa
import SnapKit
import Then

final class ORBRecommendedContentView: ExpandableCellCollectionView {
    
    private let topInset: CGFloat = 186.5
    private let toolBarHeight: CGFloat = 48
    private let locationManager = CLLocationManager()
    private var isORBMessageButtonShownWhenList: Bool = true
    private let orbMessageButtonHidingAnimator = UIViewPropertyAnimator(duration: 0.5, dampingRatio: 1)
    private let placeService = RegisteredPlaceService()
    
    // MARK: - UI Properties
    
    private let collectionViewTopInsetBackground = UIView()
    private let orbMessageButton: OBRRecommendationMessageButton
    private let collectionViewContentBackground = UIView()
    private let orbMapView = ORBMapView()
    private let contentToolBar = UIView()
    private let toolBarLeftLabel = UILabel()
    private let selectMapButton = ToolBarButton()
    private let selectListButton = ToolBarButton()
    private let toolBarButtonSeparator = UIView()
    private lazy var buttonStack = UIStackView(
        arrangedSubviews: [selectListButton, toolBarButtonSeparator, selectMapButton]
    )
    private let toolBarDivider = UIView()
    private lazy var orbMapViewTopConstraint = orbMapView.topAnchor.constraint(equalTo: frameLayoutGuide.topAnchor)
    
    var disposeBag = DisposeBag()
    var places: [PlaceModel] = []
    
    init(messageButton: OBRRecommendationMessageButton) {
        self.orbMessageButton = messageButton
        let contentInset: UIEdgeInsets = .init(top: topInset, left: 0, bottom: 0, right: 0)
        let sectionInset: UIEdgeInsets = .init(top: 19.5, left: 24, bottom: 19.5, right: 24)
        super.init(contentInset: contentInset, sectionInset: sectionInset, minimumLineSpacing: 16)
        
        setupStyle()
        setupHierarchy()
        setupLayout()
        setupButtonActions()
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
        sendSubviewToBack(orbMessageButton)
        sendSubviewToBack(collectionViewTopInsetBackground)
    }
    
}

private extension ORBRecommendedContentView {
    
    private func setupStyle() {
        backgroundColor = .primary(.listBg)
        delaysContentTouches = false
        collectionViewTopInsetBackground.backgroundColor = .main(.main1)
        collectionViewTopInsetBackground.isUserInteractionEnabled = false
        collectionViewContentBackground.backgroundColor = .primary(.listBg)
        collectionViewContentBackground.isUserInteractionEnabled = false
        contentToolBar.backgroundColor = .main(.main1)
        toolBarLeftLabel.do { label in
            label.font = .offroad(style: .iosTextContents)
            label.textAlignment = .left
            label.textColor = .main(.main2)
            label.text = "추천 장소"
        }
        toolBarButtonSeparator.backgroundColor = .main(.main2)
        selectMapButton.configuration?.title = "지도"
        selectListButton.configuration?.title = "리스트"
        toolBarDivider.backgroundColor = .grayscale(.gray100)
        
        buttonStack.do { stackView in
            stackView.axis = .horizontal
            stackView.alignment = .center
            stackView.distribution = .fillProportionally
        }
    }
    
    private func setupHierarchy() {
        addSubviews(
            collectionViewTopInsetBackground,
            orbMessageButton,
            collectionViewContentBackground,
            orbMapView,
            contentToolBar
        )
        contentToolBar.addSubviews(toolBarLeftLabel, buttonStack, toolBarDivider)
    }
    
    private func setupLayout() {
        collectionViewTopInsetBackground.snp.makeConstraints { make in
            make.top.equalTo(frameLayoutGuide)
            make.horizontalEdges.equalTo(frameLayoutGuide)
            make.bottom.equalTo(contentLayoutGuide.snp.top)
        }
        
        orbMessageButton.snp.makeConstraints { make in
            make.top.equalTo(frameLayoutGuide).inset(30)
            make.centerX.equalTo(frameLayoutGuide)
            make.width.equalTo(345)
            make.height.equalTo(85)
        }
        
        collectionViewContentBackground.snp.makeConstraints { make in
            make.top.equalTo(contentLayoutGuide)
            make.horizontalEdges.bottom.equalTo(frameLayoutGuide)
        }
        
        contentToolBar.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(frameLayoutGuide)
            make.horizontalEdges.equalTo(frameLayoutGuide)
            make.bottom.greaterThanOrEqualTo(contentLayoutGuide.snp.top)
            make.height.equalTo(toolBarHeight)
        }
        
        toolBarLeftLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(24)
            make.centerY.equalToSuperview()
        }
        
        toolBarButtonSeparator.snp.makeConstraints { make in
            make.width.equalTo(1)
            make.height.equalTo(11)
        }
        
        buttonStack.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(24)
        }
        
        toolBarDivider.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
        
        orbMapViewTopConstraint.isActive = true
        orbMapView.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalTo(frameLayoutGuide)
        }
    }
    
    private func setupButtonActions() {
        selectMapButton.rx.tap.asDriver().drive(onNext: { [weak self] in
            guard let self else { return }
            self.orbMapView.isHidden = false
            self.selectMapButton.isSelected = true
            self.selectListButton.isSelected = false
            self.hideORBMessageButton()
        }).disposed(by: disposeBag)
        
        selectListButton.rx.tap.asDriver().drive(onNext: { [weak self] in
            guard let self else { return }
            self.orbMapView.isHidden = true
            self.selectListButton.isSelected = true
            self.selectMapButton.isSelected = false
            if self.isORBMessageButtonShownWhenList {
                self.showORBMessageButton()
            } else {
                self.hideORBMessageButton()
            }
        }).disposed(by: disposeBag)
        
        selectListButton.isSelected = true
        orbMapView.isHidden = true
    }
    
    private func setupCollectionView() {
        dataSource = self
        register(PlaceListCell.self, forCellWithReuseIdentifier: PlaceListCell.className)
    }
    
    private func getInitialPlaceData() {
        guard let currentLocation = locationManager.location else { return }
        let requestData: RegisteredPlaceRequestDTO = .init(
            currentLatitude: currentLocation.coordinate.latitude,
            currentLongitude: currentLocation.coordinate.latitude,
            limit: 100,
            isBounded: false
        )
        placeService.getRegisteredPlace(requestDTO: requestData) { [weak self] result in
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

private extension ORBRecommendedContentView {
    
    private func showORBMessageButton() {
        orbMessageButtonHidingAnimator.stopAnimation(true)
        orbMessageButtonHidingAnimator.addAnimations { [weak self] in
            guard let self else { return }
            self.setContentOffset(.init(x: 0, y: -self.topInset), animated: false)
            self.layoutIfNeeded()
        }
        orbMessageButtonHidingAnimator.startAnimation()
    }
    
    private func hideORBMessageButton() {
        // 이미 숨겨진 경우 return
        guard contentOffset.y < -toolBarHeight else { return }
        orbMessageButtonHidingAnimator.stopAnimation(true)
        orbMessageButtonHidingAnimator.addAnimations { [weak self] in
            guard let self else { return }
            self.setContentOffset(.init(x: 0, y: -self.toolBarHeight), animated: false)
            self.layoutIfNeeded()
        }
        orbMessageButtonHidingAnimator.startAnimation()
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

extension ORBRecommendedContentView {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yOffset = scrollView.contentOffset.y
        let process = (yOffset + topInset)/(topInset - toolBarHeight)
        let verticalShrinkRatio = 1 - (0.1 * process)
        let horizontalShrinkRatio = 1 - (0.3 * process)
        let alpha = 1 - (process * 1.5)
        orbMessageButton.transform = .init(scaleX: verticalShrinkRatio, y: horizontalShrinkRatio)
        orbMessageButton.alpha = alpha
        orbMessageButton.isUserInteractionEnabled = -(topInset+10) < yOffset && yOffset < -(topInset-10)
        
        if process < 1 {
            orbMapViewTopConstraint.constant = -contentOffset.y
            scrollIndicatorInsets = .init(top: -contentOffset.y, left: 0, bottom: 0, right: 0)
            clipsToBounds = false
        } else {
            orbMapViewTopConstraint.constant = toolBarHeight
            scrollIndicatorInsets = .init(top: toolBarHeight, left: 0, bottom: 0, right: 0)
            clipsToBounds = true
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let threshhold1 = -(topInset*3/4)
        let threshhold2 = -toolBarHeight
        
        switch targetContentOffset.pointee.y {
        case ..<threshhold1:
            targetContentOffset.pointee = .init(x: .zero, y: -topInset)
            isORBMessageButtonShownWhenList = true
        case threshhold1..<threshhold2:
            targetContentOffset.pointee = .init(x: 0, y: -toolBarHeight)
            isORBMessageButtonShownWhenList = false
        default:
            isORBMessageButtonShownWhenList = false
            return
        }
    }
    
    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        
        if contentOffset.y < -toolBarHeight {
            isORBMessageButtonShownWhenList = true
            return true
        } else {
            scrollView.setContentOffset(.init(x: 0, y: -toolBarHeight), animated: true)
            isORBMessageButtonShownWhenList = false
            return false
        }
    }
    
}

extension ORBRecommendedContentView: UIGestureRecognizerDelegate {
    
    // 상단 contentInset 영역 터치 시 제스처 무효화
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let touchPoint = touch.location(in: self)
        if touchPoint.y < 0 {
            if isDecelerating {
                showORBMessageButton()
            }
            return false // 스크롤 시작하지 않음
        }
        return true
    }
    
}


fileprivate final class ToolBarButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configuration = UIButton.Configuration.plain()
        self.configurationUpdateHandler = { button in
            button.configuration!.contentInsets = .init(top: 16, leading: 10, bottom: 16, trailing: 10)
            button.configuration!.baseBackgroundColor = .clear
            button.configuration!.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
                var outgoing = incoming
                switch button.state {
                case .selected:
                    outgoing.foregroundColor = .main(.main2)
                    outgoing.font = .offroad(style: .iosTooltipNumber)
                default:
                    outgoing.foregroundColor = .grayscale(.gray300)
                    outgoing.font = .offroad(style: .iosTextContentsSmall)
                }
                return outgoing
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
