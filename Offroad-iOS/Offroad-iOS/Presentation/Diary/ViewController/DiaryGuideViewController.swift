//
//  DiaryGuideViewController.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 3/4/25.
//

import UIKit

protocol GuideConfirmDelegate: AnyObject{
    func toggleIsGuideConfirmed()
}

final class DiaryGuideViewController: UIViewController {
    
    // MARK: - Properties
    
    private let rootView = DiaryGuideView()
    
    weak var delegate: GuideConfirmDelegate?
    
    private let guideCharacterData: [UIImage] = [.imgCharacterDiaryGuide, .imgCharacterDiaryGuide]
    private let guideDescriptions = [DiaryGuideMessage.diaryGuideDescription1, DiaryGuideMessage.diaryGuideDescription2]
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
            delegate?.toggleIsGuideConfirmed()
        }
    }
}

//MARK: - UICollectionViewDataSource

extension DiaryGuideViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return guideCharacterData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GuideCollectionViewCell.className, for: indexPath) as? GuideCollectionViewCell else { return UICollectionViewCell() }
        cell.configureCell(image: guideCharacterData[indexPath.item], description: guideDescriptions[indexPath.item])
        
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        currentPage = scrollView.contentOffset.x < view.frame.width ? 0 : 1
        
        rootView.pageControl.currentPage = currentPage
        rootView.nextConfirmButton.setTitle(currentPage == 0 ? "다음" : "확인", for: .normal)
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension DiaryGuideViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: rootView.guideCollectionView.bounds.width, height: rootView.guideCollectionView.bounds.height)
    }
}
