//
//  CourseQuestViewController.swift
//  Offroad-iOS
//
//  Created by  정지원 on 5/13/25.
//
import UIKit

import SnapKit
import Then

class CourseQuestViewController: UIViewController, UICollectionViewDelegate {
    
    private let rootView = CourseQuestView()
    private var panStartY: CGFloat = 0

    private var quests: [CourseQuestPlace] = [
        .init(id: UUID(), imageName: "sampleImage", type: "카페", name: "브릭루즈", address: "경기도 파주시 지목로 143", isVisited: true),
        .init(id: UUID(), imageName: "sampleImage", type: "공원", name: "홍대 중앙공원", address: "경기도 파주시 지목로 143", isVisited: false),
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
        rootView.courseQuestPlaceCollectionView.delegate = self
                setupPanGesture()
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
    
    private func setupPanGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        rootView.listContainerView.addGestureRecognizer(panGesture)
    }
    
    @objc private func customBackButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
            let translation = gesture.translation(in: view)
            switch gesture.state {
            case .began:
                panStartY = rootView.listContainerView.frame.origin.y
            case .changed:
                let offset = panStartY + translation.y
                let maxOffset = rootView.mapView.frame.maxY
                let minOffset = view.safeAreaInsets.top + 112
                if offset >= minOffset && offset <= maxOffset {
                    rootView.listTopConstraint?.update(offset: offset)
                    view.layoutIfNeeded()
                }
            case .ended, .cancelled:
                let currentY = rootView.listContainerView.frame.origin.y
                let maxOffset = rootView.mapView.frame.maxY
                let minOffset = view.safeAreaInsets.top + 112
                let midpoint = (minOffset + maxOffset) / 2
                let shouldSnapUp = currentY < midpoint
                let target = shouldSnapUp ? minOffset : maxOffset

                rootView.listTopConstraint?.update(offset: target)
                UIView.animate(withDuration: 0.25) {
                    self.view.layoutIfNeeded()
                }
            default:
                break
            }
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
