//
//  SettingViewController.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 8/7/24.
//

import UIKit

import SafariServices

final class SettingViewController: UIViewController {
    
    //MARK: - Properties
    
    private let rootView = SettingView()
    
    private var settingModelList = SettingBaseModel.settingListModel
    private let redirectionURLStrings = [
        "https://tan-antlion-a47.notion.site/105120a9d80f80cea574f7d62179bfa8?pvs=4",
        "https://tan-antlion-a47.notion.site/90c70d8bf0974b37a3a4470022df303d?pvs=4",
        "https://tan-antlion-a47.notion.site/105120a9d80f80739f54fa78902015d7?pvs=4"
    ]
    
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
        case 1, 2, 3:
            let redirectionURL = NSURL(string: redirectionURLStrings[indexPath.item - 1])
            let safariView = SFSafariViewController(url: (redirectionURL ?? NSURL()) as URL)
            self.present(safariView, animated: true, completion: nil)
        case 4:
            let marketingConsentViewController = MarketingConsentViewController()
            marketingConsentViewController.modalPresentationStyle = .overCurrentContext
            self.present(marketingConsentViewController, animated: false)
        case 5:
            let logoutViewController = LogoutViewController()
            logoutViewController.modalPresentationStyle = .overCurrentContext
            self.present(logoutViewController, animated: false)
        case 6:
            let deleteAccountViewController = DeleteAccountViewController()
            deleteAccountViewController.modalPresentationStyle = .overCurrentContext
            self.present(deleteAccountViewController, animated: false)
        default: break
        }
    }
}
