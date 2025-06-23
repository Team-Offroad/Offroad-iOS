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
    
    private let rootView = CourseQuestView()
    
    private var quests: [CourseQuestPlace] = [
        .init(id: UUID(), imageName: "sampleImage", type: "카페", name: "브릭루즈", address: "경기도 파주시 지목로 143", isVisited: true),
        .init(id: UUID(), imageName: "sampleImage", type: "공원", name: "홍대 중앙공원", address: "경기도 파주시 지목로 143", isVisited: false),
        .init(id: UUID(), imageName: "sampleImage", type: "식당", name: "브릭루즈", address: "경기도 파주시 지목로 143", isVisited: true),
        .init(id: UUID(), imageName: "sampleImage", type: "식당", name: "브릭루즈", address: "경기도 파주시 지목로 143", isVisited: true),
        .init(id: UUID(), imageName: "sampleImage", type: "식당", name: "브릭루즈", address: "경기도 파주시 지목로 143", isVisited: true),
        .init(id: UUID(), imageName: "sampleImage", type: "식당", name: "브릭루즈", address: "경기도 파주시 지목로 143", isVisited: true),
        .init(id: UUID(), imageName: "sampleImage", type: "식당", name: "브릭루즈", address: "경기도 파주시 지목로 143", isVisited: true),
        .init(id: UUID(), imageName: "sampleImage", type: "식당", name: "브릭루즈", address: "경기도 파주시 지목로 143", isVisited: true)
    ]
    
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
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rootView.courseQuestPlaceCollectionView.dataSource = self
        rootView.listContainerView.delegate = self
        setupControlsTarget()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let offroadTabBarController = self.tabBarController as? OffroadTabBarController else { return }
        offroadTabBarController.hideTabBarAnimation()
    }
    
    private func setupControlsTarget() {
        rootView.customBackButton.addTarget(self, action: #selector(customBackButtonTapped), for: .touchUpInside)
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
            self?.quests[indexPath.item].isVisited = true
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
