//
//  CollectedTitlesViewController.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 8/5/24.
//

import UIKit

final class CollectedTitlesViewController: UIViewController {
    
    //MARK: - Properties
    
    private let rootView = CollectedTitlesView()
    
    private var collectedTitleModelList: [EmblemDataList]? {
        didSet {
            rootView.collectedTitleCollectionView.reloadData()
        }
    }
    
    private var notCollectedTitleModelList: [EmblemDataList]? {
        didSet {
            rootView.collectedTitleCollectionView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let offroadTabBarController = self.tabBarController as? OffroadTabBarController else { return }
        offroadTabBarController.hideTabBarAnimation()
    }
    
    // MARK: - Life Cycle
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTarget()
        setupDelegate()
        getEmblemDataList()
    }
}

extension CollectedTitlesViewController {
    
    // MARK: - Private Method
    
    private func setupTarget() {
        rootView.customBackButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    private func setupDelegate() {
        rootView.collectedTitleCollectionView.delegate = self
        rootView.collectedTitleCollectionView.dataSource = self
    }
    
    private func getEmblemDataList() {
        NetworkService.shared.emblemService.getEmblemDataList { response in
            switch response {
            case .success(let data):
                self.collectedTitleModelList = data?.data.gainedEmblems
                self.notCollectedTitleModelList = data?.data.notGainedEmblems
            default:
                break
            }
        }
    }
    
    // MARK: - @objc Method
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

//MARK: - UICollectionViewDataSource

extension CollectedTitlesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let collectedTitleModelList, let notCollectedTitleModelList {
            let titleModelList = collectedTitleModelList + notCollectedTitleModelList
            return titleModelList.count
        }
        return Int()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectedTitleCollectionViewCell.className, for: indexPath) as? CollectedTitleCollectionViewCell else { return UICollectionViewCell() }
        
        if let collectedTitleModelList, let notCollectedTitleModelList {
            if indexPath.item < collectedTitleModelList.count {
                cell.configureCollectedCell(data: collectedTitleModelList[indexPath.item])
            } else {
                cell.configureNotCollectedCell(data: notCollectedTitleModelList[indexPath.item - collectedTitleModelList.count])
            }
        }

        return cell
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension CollectedTitlesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: rootView.bounds.width - 48, height: 79)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.cellForItem(at: indexPath)?.isSelected = true
    }
}
