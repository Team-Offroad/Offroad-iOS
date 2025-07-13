//
//  CourseQuestViewController.swift
//  Offroad-iOS
//
//  Created by  정지원 on 5/13/25.
//
import UIKit

import SnapKit
import Then
import CoreLocation

class CourseQuestViewController: UIViewController, UICollectionViewDelegate, UIGestureRecognizerDelegate {
    
    // MARK: - Type Methods
    
    /// 이 함수는 CourseQuestViewController 전용 D-Day 계산 함수입니다.
    /// CourseQuestCollectionViewCell에도 유사한 함수가 존재하지만, QuestListViewController에서 D-Day를 표시하기 위한 용도이며,
    /// 책임이 분리되어야 한다고 판단하여 별도로 정의했습니다.
    private static func dday(from deadline: String?) -> String {
        guard let deadline = deadline else {
            return "D-?"
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.locale = Locale(identifier: "ko_KR")
        guard let deadlineDate = formatter.date(from: deadline) else {
            return "D-?"
        }
        
        let today = Calendar.current.startOfDay(for: Date())
        let target = Calendar.current.startOfDay(for: deadlineDate)
        let daysLeft = Calendar.current.dateComponents([.day], from: today, to: target).day ?? 0
        
        return daysLeft >= 0 ? "D-\(daysLeft)" : "종료"
    }
    
    // MARK: - Properties
    
    private let courseQuestView = CourseQuestView()
    private let courseQuestDetailService = CourseQuestDetailService()
    private var courseQuestPlaces: [CourseQuestDetailPlaceDTO] = []
    private let questId: Int
    private let deadline: String
    var totalCount: Int
    var currentCount: Int
    private let locationManager = CLLocationManager()
    private var completedQuests: [CompleteQuest] = []
    var onQuestCompleted: (([CompleteQuest]) -> Void)?
    
    // MARK: - Life Cycle
    
    init(questId: Int, deadline: String, totalCount: Int, currentCount: Int) {
        self.questId = questId
        self.deadline = deadline
        self.totalCount = totalCount
        self.currentCount = currentCount
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = courseQuestView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        courseQuestView.courseQuestPlaceCollectionView.dataSource = self
        courseQuestView.listContainerView.delegate = self
        
        setupControlsTarget()
        
        let ddayString = Self.dday(from: deadline)
        let dateString = formattedDate(from: deadline)
        courseQuestView.deadlineDateLabel.text = "퀘스트 마감일: \(dateString)"
        courseQuestView.ddayBadgeLabel.text = ddayString
        
        fetchCourseQuestDetail(questId: questId)
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let offroadTabBarController = self.tabBarController as? OffroadTabBarController else { return }
        offroadTabBarController.hideTabBarAnimation()
    }
    
    // MARK: - Private Func
    
    private func fetchCourseQuestDetail(questId: Int) {
        courseQuestDetailService.getCourseQuestDetail(questId: questId) { result in
            switch result {
            case .success(let dto):
                DispatchQueue.main.async { [weak self] in
                    self?.courseQuestPlaces = dto.data.places
                    self?.courseQuestView.courseQuestPlaceCollectionView.reloadData()
                    //지도에 마커 표시
                    self?.courseQuestView.configureMap(with: dto.data.places)
                }
            case .failure(let error):
                print("❌ 코스 퀘스트 상세 정보 로드 실패:", error.localizedDescription)
            }
        }
    }
    
    private func setupControlsTarget() {
        courseQuestView.customBackButton.addTarget(self, action: #selector(customBackButtonTapped), for: .touchUpInside)
        courseQuestView.panGesture.addTarget(self, action: #selector(panGestureHandler))
    }
    
    private func formattedDate(from deadline: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.calendar = .init(identifier: .gregorian)
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        inputFormatter.timeZone = TimeZone(secondsFromGMT: 32400)
        
        let outputFormatter = DateFormatter()
        outputFormatter.calendar = .init(identifier: .gregorian)
        outputFormatter.dateFormat = "yy.MM.dd"
        outputFormatter.timeZone = TimeZone(secondsFromGMT: 32400)
        outputFormatter.locale = Locale(identifier: "ko_KR")
        
        guard let date = inputFormatter.date(from: deadline) else { return "--.--.--" }
        return outputFormatter.string(from: date)
    }
    
    @objc private func customBackButtonTapped() {
        onQuestCompleted?(completedQuests)
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func panGestureHandler(sender: UIPanGestureRecognizer) {
        let draggedDistanceY = sender.translation(in: view).y
        
        courseQuestView.listContainerView.contentOffset = .zero
        
        // listContainerView가 얼마나 위로 올라갔는지에 대한 offset
        let currentTopOffset = courseQuestView.listTopConstraint?.layoutConstraints.first?.constant ?? 0
        // 팬 드래그 양만큼 새로운 위치 계산
        let proposedTopOffset = currentTopOffset + draggedDistanceY
        
        ///고정 위치 정의
        /// -fullyCollapsedOffset: navigationBar 아래에 붙은 위치
        /// -fullyExpandedOffset: mapView 아래 기본 위치
        let fullyCollapsedOffset: CGFloat = -courseQuestView.mapView.frame.height
        let fullyExpandedOffset: CGFloat = 0
        
        // 바운스 방지를 위한 offset 제한
        let boundedTopOffset = min(max(proposedTopOffset, fullyCollapsedOffset), fullyExpandedOffset)
        
        courseQuestView.listTopConstraint?.update(offset: boundedTopOffset)
        sender.setTranslation(.zero, in: view)
        
        /// 팬 동작이 끝났을 때: 위로 붙일지, 아래로 내릴지 결정하는 코드
        if sender.state == .ended {
            // 스냅 기준: 위로 얼마만큼 가까이 올라갔는지를 기준으로 결정
            let snapThreshold = courseQuestView.mapView.frame.height / 2
            let distanceToCollapse = abs(boundedTopOffset - fullyCollapsedOffset)
            
            if distanceToCollapse < snapThreshold {
                // 위로 절반 이상 올라갔다면: navigationBar 아래로 딱 붙이기
                courseQuestView.listTopConstraint?.update(offset: fullyCollapsedOffset)
                courseQuestView.listContainerView.isScrollEnabled = true
                courseQuestView.courseQuestPlaceCollectionView.isScrollEnabled = true
            } else {
                // 절반 미만이면: 다시 아래로 내려오기 (기본 위치)
                courseQuestView.listTopConstraint?.update(offset: fullyExpandedOffset)
                courseQuestView.listContainerView.isScrollEnabled = false
                courseQuestView.courseQuestPlaceCollectionView.isScrollEnabled = false
            }
            
            UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseInOut]) {
                self.view.layoutIfNeeded()
            }
        }
    }
}

// MARK: - CLLocationManagerDelegate

extension CourseQuestViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return courseQuestPlaces.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CourseQuestPlaceCell", for: indexPath) as? CourseQuestPlaceCell else {
            return UICollectionViewCell()
        }
        let quest = courseQuestPlaces[indexPath.item]
        cell.configure(with: quest)
        cell.onVisit = { [weak self] in
            self?.handleVisitAction(for: indexPath, in: collectionView)
        }
        return cell
    }
    
    private func handleVisitAction(for indexPath: IndexPath, in collectionView: UICollectionView) {
        let place = courseQuestPlaces[indexPath.item]
        guard let currentCoordinate = locationManager.location?.coordinate else { return }
        
        let locationAuthenticationBypassing = UserDefaults.standard.bool(forKey: "bypassLocationAuthentication")
        let requestDTO = AdventuresPlaceAuthenticationRequestDTO(
            placeId: place.placeId,
            latitude: locationAuthenticationBypassing ? place.latitude : currentCoordinate.latitude,
            longitude: locationAuthenticationBypassing ? place.longitude : currentCoordinate.longitude
        )
        
        Task { [weak self] in
            guard let self else { return }
            
            do {
                let result = try await AdventureService().authenticateAdventurePlace(adventureAuthDTO: requestDTO)
                if let completedList = result.completeQuestList {
                    self.completedQuests = completedList
                }
                
                switch (result.isValidPosition, result.isFirstVisitToday) {
                case (true, true):
                    var updatedPlace = place
                    updatedPlace.isVisited = true
                    self.courseQuestPlaces[indexPath.item] = updatedPlace
                    self.currentCount += 1
                    let remainCount = max(self.totalCount - self.currentCount, 0)
                    collectionView.reloadItems(at: [indexPath])
                    
                    if remainCount == 0 {
                        CourseQuestToastManager.shared.show(
                            message: "퀘스트 클리어! 보상을 받아보세요"
                        ) {
                            $0.highlightText(targetText: "보상", font: .offroad(style: .iosTextBold))
                        }
                    } else {
                        CourseQuestToastManager.shared.show(
                            message: "방문 성공! 앞으로 \(remainCount)곳 남았어요"
                        ) {
                            $0.highlightText(targetText: "\(remainCount)곳", font: .offroad(style: .iosTextBold))
                        }
                    }
                    
                default:
                    let alertController = ORBAlertController(
                        title: AlertMessage.courseQuestFailureLocationTitle,
                        message: AlertMessage.courseQuestFailureLocationMessage,
                        type: .normal
                    )
                    alertController.configureMessageLabel {
                        $0.highlightText(targetText: "위치", font: .offroad(style: .iosTextBold))
                        $0.highlightText(targetText: "내일 다시", font: .offroad(style: .iosTextBold))
                    }
                    alertController.xButton.isHidden = true
                    alertController.addAction(ORBAlertAction(title: "확인", style: .default) { _ in })
                    self.present(alertController, animated: true)
                }
                
            } catch {
                print("탐험 인증에 실패했어요. 다시 시도해주세요.")
            }
        }
    }
}
