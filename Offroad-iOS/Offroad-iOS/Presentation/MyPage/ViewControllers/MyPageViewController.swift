//
//  MyPageViewController.swift
//  Offroad-iOS
//
//  Created by 김민성 on 2024/07/15.
//

import UIKit

final class MyPageViewController: UIViewController {
    
    //MARK: - Properties
    
    private let rootView = MyPageView()
    
    private var menuModelList = MyPageMenuModel.dummy()
    
    // MARK: - Life Cycle
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDelegate()
    }
}

extension MyPageViewController {
    
    // MARK: - Private Method
    
    private func setupDelegate() {
        rootView.myPageMenuCollectionView.dataSource = self
        rootView.myPageMenuCollectionView.delegate = self
    }
}

//MARK: - UICollectionViewDataSource

extension MyPageViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuModelList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyPageMenuCollectionViewCell.className, for: indexPath) as? MyPageMenuCollectionViewCell else { return UICollectionViewCell() }
        cell.configureCell(data: menuModelList[indexPath.item])

        return cell
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension MyPageViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (rootView.getBackgroundViewWidth() - 13) / 2, height: 138)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.cellForItem(at: indexPath)?.isSelected = true
    }
}
