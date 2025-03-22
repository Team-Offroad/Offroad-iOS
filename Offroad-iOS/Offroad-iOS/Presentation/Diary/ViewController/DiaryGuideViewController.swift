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
    
    //MARK: - API Method
    
    func patchDiaryTutorialCheckStatus() {
        NetworkService.shared.diarySettingService.patchDiaryTutorialCheckStatus { response in
            switch response {
            case .success:
                MyDiaryManager.shared.didSuccessUpdateTutorialCheckStatus.accept(())
                print("일기 가이드 확인 여부 업데이트 완료")
            default:
                break
            }
        }
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
            patchDiaryTutorialCheckStatus()
        }
    }
}

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


extension DiaryGuideViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: rootView.guideCollectionView.bounds.width, height: rootView.guideCollectionView.bounds.height)
    }
}
