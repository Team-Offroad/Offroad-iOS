//
//  CourseQuestViewController.swift
//  Offroad-iOS
//
//  Created by  정지원 on 5/13/25.
//

import UIKit

import SnapKit
import Then

class CourseQuestViewController: UIViewController {

    private var quests: [CourseQuestPlace] = [
        .init(id: UUID(), imageName: "sampleImage", type: "카페", name: "브릭루즈", address: "경기도 파주시 지목로 143", isVisited: true),
        .init(id: UUID(), imageName: "sampleImage", type: "공원", name: "홍대 중앙공원", address: "경기도 파주시 지목로 143", isVisited: false),
        .init(id: UUID(), imageName: "sampleImage", type: "카페", name: "브릭루즈", address: "경기도 파주시 지목로 143", isVisited: true)
    ]

    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 40, height: 100)
        layout.minimumLineSpacing = 16
        $0.collectionViewLayout = layout
        $0.backgroundColor = .clear
        $0.contentInset = .init(top: 16, left: 0, bottom: 16, right: 0)
        $0.register(CourseQuestPlaceCell.self, forCellWithReuseIdentifier: "CourseQuestPlaceCell")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemGray6
        setupLayout()
        collectionView.dataSource = self
    }

    private func setupLayout() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
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
}
