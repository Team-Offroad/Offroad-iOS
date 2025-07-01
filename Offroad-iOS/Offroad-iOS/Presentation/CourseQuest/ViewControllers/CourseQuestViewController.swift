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
    var questId: Int?
    var deadline: String?
    private let locationManager = CLLocationManager()
    
    // MARK: - Life Cycle
    
    init(questId: Int, deadline: String) {
        self.questId = questId
        self.deadline = deadline
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
        
        if let deadline = deadline {
            let ddayString = Self.dday(from: deadline)
            let dateString = formattedDate(from: deadline)
            courseQuestView.deadlineDateLabel.text = "퀘스트 마감일: \(dateString)"
            courseQuestView.ddayBadgeLabel.text = ddayString
        }
        
        if let questId = questId {
            fetchCourseQuestDetail(questId: questId)
        }
        
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
        navigationController?.popViewController(animated: true)
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
            guard let self else { return }
            let place = quest
            
            guard let currentCoordinate = locationManager.location?.coordinate else {
                self.showToast("현재 위치를 가져올 수 없어요. 위치 권한을 확인해주세요.")
                return
            }
            
            let requestDTO = AdventuresPlaceAuthenticationRequestDTO(
                placeId: place.placeId,
                latitude: currentCoordinate.latitude,
                longitude: currentCoordinate.longitude
            )
            
            Task {
                do {
                    let result = try await AdventureService().authenticateAdventurePlace(adventureAuthDTO: requestDTO)
                    
                    // 탐험 결과 메시지
                    let toastMessage: String
                    switch (result.isValidPosition, result.isFirstVisitToday) {
                    case (true, true):
                        toastMessage = "탐험 성공! 보상을 획득했어요!"
                    case (true, false):
                        toastMessage = "이미 오늘 방문했어요.\n다른 장소를 탐험해보세요!"
                    default:
                        toastMessage = "현재 위치에서 인증할 수 없어요.\n장소를 다시 확인해주세요!"
                    }
                    
                    // 방문 성공 시 모델 갱신
                    if result.isValidPosition {
                        self.courseQuestPlaces[indexPath.item] = CourseQuestDetailPlaceDTO(
                            category: place.category,
                            name: place.name,
                            address: place.address,
                            latitude: place.latitude,
                            longitude: place.longitude,
                            isVisited: true,
                            categoryImage: place.categoryImage,
                            description: place.description,
                            placeId: place.placeId
                        )
                        collectionView.reloadItems(at: [indexPath])
                    }
                    // 결과 메시지 표시
                    await MainActor.run {
                        self.showToast(toastMessage)
                    }
                } catch {
                    await MainActor.run {
                        self.showToast("탐험 인증에 실패했어요. 다시 시도해주세요.")
                    }
                }
            }
        }
        return cell
    }
    
    func showToast(_ message: String) {
        let toast = UILabel()
        toast.text = message
        toast.textAlignment = .center
        toast.backgroundColor = UIColor.black.withAlphaComponent(0.55)
        toast.textColor = .white
        toast.font = .offroad(style: .iosText)
        toast.roundCorners(cornerRadius: 10)
        toast.clipsToBounds = true
        
        view.addSubview(toast)
        toast.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(80)
            make.height.equalTo(40)
            make.width.lessThanOrEqualToSuperview().offset(-40)
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            toast.alpha = 1
        }, completion: { _ in
            UIView.animate(withDuration: 0.3, delay: 2, options: [], animations: {
                toast.alpha = 0
            }, completion: { _ in
                toast.removeFromSuperview()
            })
        })
    }
}
