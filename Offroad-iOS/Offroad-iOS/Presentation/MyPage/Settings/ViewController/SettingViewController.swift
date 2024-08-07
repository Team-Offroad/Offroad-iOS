//
//  SettingViewController.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 8/7/24.
//

import UIKit

final class SettingViewController: UIViewController {
    
    //MARK: - Properties
    
    private let rootView = SettingView()
    
    private var settingModelList = SettingListModel.dummy()
    
    // MARK: - Life Cycle
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDelegate()
    }
}

extension SettingViewController {
    
    // MARK: - Private Method
    
    private func setupDelegate() {
        rootView.settingListCollectionView.dataSource = self
        rootView.settingListCollectionView.delegate = self
    }
}

//MARK: - UICollectionViewDataSource

extension SettingViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return settingModelList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SettingListCollectionViewCell.className, for: indexPath) as? SettingListCollectionViewCell else { return UICollectionViewCell() }
        cell.configureCell(data: settingModelList[indexPath.item])
        
        return cell
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension SettingViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width - 48, height: 44)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.cellForItem(at: indexPath)?.isSelected = true
    }
}
