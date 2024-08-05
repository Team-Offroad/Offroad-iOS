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
    
    private var collectedTitleModelList = CollectedTitleModel.dummy()
    
    // MARK: - Life Cycle
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDelegate()
    }
}

extension CollectedTitlesViewController {
    
    // MARK: - Private Method
    
    private func setupDelegate() {
        rootView.collectedTitleCollectionView.delegate = self
        rootView.collectedTitleCollectionView.dataSource = self
    }
}

//MARK: - UICollectionViewDataSource

extension CollectedTitlesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectedTitleModelList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectedTitleCollectionViewCell.className, for: indexPath) as? CollectedTitleCollectionViewCell else { return UICollectionViewCell() }
        cell.configureCell(data: collectedTitleModelList[indexPath.item])

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
