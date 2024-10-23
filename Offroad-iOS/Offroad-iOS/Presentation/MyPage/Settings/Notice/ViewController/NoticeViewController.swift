//
//  NoticeViewController.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 8/7/24.
//

import UIKit

import RxSwift
import RxCocoa

final class NoticeViewController: UIViewController {
    
    //MARK: - Properties
    
    var disposeBag = DisposeBag()
    
    let netWorkdDidFail = PublishRelay<Void>()
    let viewDidAppear = PublishRelay<Void>()
    
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
        bindData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewDidAppear.accept(())
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
            case .networkFail:
                self.netWorkdDidFail.accept(())
            default:
                break
            }
        }
    }
    
    private func bindData() {
        Observable.combineLatest(viewDidAppear, netWorkdDidFail)
            .subscribe { [weak self] _ in
                guard let self else { return }
                self.showToast(message: "네트워크 연결 상태를 확인해주세요.", inset: 66)
            }
            .disposed(by: disposeBag)
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
        if let noticeModelList {
            let noticePostViewController = NoticePostViewController(noticeInfo: noticeModelList[indexPath.item])
            self.navigationController?.pushViewController(noticePostViewController, animated: true)
        }
    }
}
