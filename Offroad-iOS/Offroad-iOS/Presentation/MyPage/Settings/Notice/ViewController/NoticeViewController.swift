//
//  NoticeViewController.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 8/7/24.
//

import UIKit

final class NoticeViewController: UIViewController {
    
    //MARK: - Properties
    
    private let rootView = NoticeView()
    
    private var noticeModelList = SettingBaseModel.settingNoticeModel
    
    // MARK: - Life Cycle
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDelegate()
    }
}

extension NoticeViewController {
    
    // MARK: - Private Method
    
    private func setupDelegate() {
        rootView.settingBaseCollectionView.dataSource = self
        rootView.settingBaseCollectionView.delegate = self
    }
}

//MARK: - UICollectionViewDataSource

extension NoticeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return noticeModelList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SettingBaseCollectionViewCell.className, for: indexPath) as? SettingBaseCollectionViewCell else { return UICollectionViewCell() }
        cell.configureCell(data: noticeModelList[indexPath.item])
        
        return cell
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension NoticeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.cellForItem(at: indexPath)?.isSelected = true
    }
}
