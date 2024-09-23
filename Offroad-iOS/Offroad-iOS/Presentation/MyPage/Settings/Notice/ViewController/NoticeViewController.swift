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
    
    private var noticeModelList: [NoticeInfo]? {
        didSet {
            rootView.settingBaseCollectionView.reloadData()
        }
    }
    
    // MARK: - Life Cycle
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTarget()
        setupDelegate()
        getNoticeList()
    }
}

extension NoticeViewController {
    
    // MARK: - Private Method
    
    private func setupTarget() {
        rootView.customBackButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    private func setupDelegate() {
        rootView.settingBaseCollectionView.dataSource = self
        rootView.settingBaseCollectionView.delegate = self
    }
    
    private func getNoticeList() {
        NetworkService.shared.noticeService.getNoticeList { response in
            switch response {
            case .success(let data):
                self.noticeModelList = data?.data.announcements ?? [NoticeInfo]()
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

extension NoticeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let noticeModelList {
            return noticeModelList.count
        }
        return Int()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SettingBaseCollectionViewCell.className, for: indexPath) as? SettingBaseCollectionViewCell else { return UICollectionViewCell() }
        
        if let noticeModelList {
            cell.configureNoticeCell(data: noticeModelList[indexPath.item])
        }

        return cell
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension NoticeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.item {
        case 0:
            let noticePostViewController = NoticePostViewController()
            self.navigationController?.pushViewController(noticePostViewController, animated: true)
        default: break
        }    }
}
