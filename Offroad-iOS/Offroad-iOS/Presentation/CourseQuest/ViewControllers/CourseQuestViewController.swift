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
    
    private let courseQuestView = CourseQuestView()
    private let courseQuestDetailService = CourseQuestDetailService()
    private var quests: [CourseQuestDetailPlaceDTO] = []
    var questId: Int?
    var deadline: String?
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 48, height: 97)
        layout.minimumLineSpacing = 14
        $0.collectionViewLayout = layout
        $0.backgroundColor = .clear
        $0.contentInset = .init(top: 16, left: 0, bottom: 16, right: 0)
        $0.register(CourseQuestPlaceCell.self, forCellWithReuseIdentifier: "CourseQuestPlaceCell")
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
            courseQuestView.ddayLabel.text = "퀘스트 마감일: \(dateString)   🗓️  \(ddayString)"
        }
        
        if let questId = questId {
            fetchCourseQuestDetail(questId: questId)
        }
    }
    
    private func fetchCourseQuestDetail(questId: Int) {
        courseQuestDetailService.getCourseQuestDetail(questId: questId) { [weak self] result in
            switch result {
            case .success(let dto):
                DispatchQueue.main.async {
                    self?.quests = dto.data.places
                    self?.courseQuestView.courseQuestPlaceCollectionView.reloadData()
                    //지도에 마커 표시
                    self?.courseQuestView.configureMap(with: dto.data.places)
                }
            case .failure(let error):
                print("❌ 코스 퀘스트 상세 정보 로드 실패:", error.localizedDescription)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let offroadTabBarController = self.tabBarController as? OffroadTabBarController else { return }
        offroadTabBarController.hideTabBarAnimation()
    }
    
    private func setupControlsTarget() {
        courseQuestView.customBackButton.addTarget(self, action: #selector(customBackButtonTapped), for: .touchUpInside)
    }
    
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
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        inputFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "yy.MM.dd"
        outputFormatter.locale = Locale(identifier: "ko_KR")
        
        guard let date = inputFormatter.date(from: deadline) else { return "--.--.--" }
        return outputFormatter.string(from: date)
    }
    
    @objc private func customBackButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

//extension CourseQuestViewController: UIScrollViewDelegate {
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let yOffset = scrollView.contentOffset.y
//
//        let maxOffset: CGFloat = 259   // mapView 높이와 동일
//        let threshold: CGFloat = 100   // 디데이 뷰가 어느 정도 올라갔을 때 trigger
//
//        if yOffset > threshold {
//            // 모달처럼 붙임
//            rootView.listTopConstraint?.update(offset: -maxOffset)
//        } else {
//            // 원래 위치
//            rootView.listTopConstraint?.update(offset: 0)
//        }
//    }
//}


extension CourseQuestViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return quests.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CourseQuestPlaceCell", for: indexPath) as? CourseQuestPlaceCell else {
            return UICollectionViewCell()
        }
        let quest = quests[indexPath.item]
        cell.configure(with: quest)
        cell.onVisit = { [weak self] in
            self?.quests[indexPath.item] = CourseQuestDetailPlaceDTO(
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
