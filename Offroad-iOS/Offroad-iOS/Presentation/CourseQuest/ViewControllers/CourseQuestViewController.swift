//
//  CourseQuestViewController.swift
//  Offroad-iOS
//
//  Created by  정지원 on 5/13/25.
//
import UIKit

import SnapKit
import Then

class CourseQuestViewController: UIViewController, UICollectionViewDelegate, UIGestureRecognizerDelegate {
    
    // MARK: - Properties
    
    private let courseQuestView = CourseQuestView()
    private let courseQuestDetailService = CourseQuestDetailService()
    private var courseQuestPlaces: [CourseQuestDetailPlaceDTO] = []
    var questId: Int?
    var deadline: String?
    
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
            self?.courseQuestPlaces[indexPath.item] = CourseQuestDetailPlaceDTO(
                category: quest.category,
                name: quest.name,
                address: quest.address,
                latitude: quest.latitude,
                longitude: quest.longitude,
                isVisited: true,
                categoryImage: quest.categoryImage,
                description: quest.description,
                placeId: quest.placeId
            )
            collectionView.reloadItems(at: [indexPath])
            self?.showToast("방문 성공! 앞으로 N곳 남았어요")
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
