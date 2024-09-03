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
    
    private var settingModelList = SettingBaseModel.settingListModel
    
    // MARK: - Life Cycle
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTarget()
        setupDelegate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let offroadTabBarController = self.tabBarController as? OffroadTabBarController else { return }
        offroadTabBarController.hideTabBarAnimation()
    }
}

extension SettingViewController {
    
    // MARK: - Private Method
    
    private func setupTarget() {
        rootView.customBackButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    private func setupDelegate() {
        rootView.settingBaseCollectionView.dataSource = self
        rootView.settingBaseCollectionView.delegate = self
    }
    
    // MARK: - @objc Method
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

//MARK: - UICollectionViewDataSource

extension SettingViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return settingModelList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SettingBaseCollectionViewCell.className, for: indexPath) as? SettingBaseCollectionViewCell else { return UICollectionViewCell() }
        cell.configureCell(data: settingModelList[indexPath.item])
        
        return cell
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension SettingViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.item {
        case 0:
            let noticeViewController = NoticeViewController()
            self.navigationController?.pushViewController(noticeViewController, animated: true)
        case 5:
            let logoutViewController = LogoutViewController()
            logoutViewController.modalPresentationStyle = .overCurrentContext
            self.present(logoutViewController, animated: false)
        default: break
        }
    }
}
