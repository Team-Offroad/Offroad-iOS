//
//  DiaryGuideViewController.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 3/4/25.
//

import UIKit

final class DiaryGuideViewController: UIViewController {
    
    // MARK: - Properties
    
    private let rootView = DiaryGuideView()
    
    private let guideCharacterData: [UIImage] = [.imgCharacterDiaryGuide, .imgCharacterDiaryGuide]
    private let guideDescription1 = ["오브와 대화를 나누거나\n함께 탐험을 떠나면,\n매일 기록을 모아 오브가 일기를 써요.", "이건 기억빛이에요."]
    private let guideDescription2 = ["일기를 받기 위해선\n오브와 충분한 시간을 보내야해요.", "그 날의 기억에 따라\n다른 색으로 칠해져요.\n오늘은 어떤 색의 하루였나요?"]
    
    private var currentPage = 0

    // MARK: - Life Cycle
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTarget()
        setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

private extension DiaryGuideViewController {
    
    // MARK: - Private Method
    
    func setupTarget() {
        rootView.closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        rootView.nextConfirmButton.addTarget(self, action: #selector(nextConfirmButtonTapped), for: .touchUpInside)
    }
    
    func setupCollectionView() {
        rootView.guideCollectionView.delegate = self
        rootView.guideCollectionView.dataSource = self
    }
}
    
@objc private extension DiaryGuideViewController {

    // MARK: - @objc Method
    
    func closeButtonTapped() {
        dismiss(animated: false)
    }
    
    func nextConfirmButtonTapped() {
        if currentPage == 0 {
            rootView.guideCollectionView.scrollToItem(at: IndexPath(item: 1, section: 0), at: .centeredHorizontally, animated: true)
        } else {
            dismiss(animated: false)
        }
    }
}

extension DiaryGuideViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return guideCharacterData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GuideCollectionViewCell.className, for: indexPath) as? GuideCollectionViewCell else { return UICollectionViewCell() }
        cell.configureCell(image: guideCharacterData[indexPath.item], description1: guideDescription1[indexPath.item], description2: guideDescription2[indexPath.item])
        
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        currentPage = scrollView.contentOffset.x < view.frame.width ? 0 : 1
        
        rootView.pageControl.currentPage = currentPage
        rootView.nextConfirmButton.setTitle(currentPage == 0 ? "다음" : "확인", for: .normal)
    }
}


extension DiaryGuideViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: rootView.guideCollectionView.bounds.width, height: rootView.guideCollectionView.bounds.height)
    }
}
