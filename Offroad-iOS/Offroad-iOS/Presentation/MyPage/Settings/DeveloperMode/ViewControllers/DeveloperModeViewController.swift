//
//  DeveloperModeViewController.swift
//  ORB
//
//  Created by 김민성 on 4/4/25.
//

import UIKit

import RxSwift
import RxCocoa

final class DeveloperModeViewController: UIViewController {
    
    enum Sections: Int, CaseIterable {
        case switchingModels
        case normal
    }
    
    private let rootView = DeveloperModeView()
    private let switchableModels: [any DeveloperSettingModelToggleable] = [LocationBypassing(), LogPrinterSettingModel()]
    private let normalStyleModels: [any DeveloperSettingModelNormal] = [VersionCheckSettingModel()]
    
    private var disposeBag = DisposeBag()
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupButtonsAction()
        setupCollectionView()
    }
    
}

private extension DeveloperModeViewController {
    
    private func setupButtonsAction() {
        rootView.customBackButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }).disposed(by: disposeBag)
    }
    
    private func setupCollectionView() {
        rootView.settingBaseCollectionView.register(
            DeveloperModeSwitchCell.self,
            forCellWithReuseIdentifier: DeveloperModeSwitchCell.className
        )
        rootView.settingBaseCollectionView.register(
            DeveloperModeNormalCell.self,
            forCellWithReuseIdentifier: DeveloperModeNormalCell.className
        )
        rootView.settingBaseCollectionView.dataSource = self
    }
    
}

// MARK: - UICollectionViewDataSource

extension DeveloperModeViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        Sections.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let section = Sections(rawValue: section) else { return 0 }
        switch section {
        case .switchingModels:
            return switchableModels.count
        case .normal:
            return normalStyleModels.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionView.deselectItem(at: indexPath, animated: false)
        guard let section = Sections(rawValue: indexPath.section) else {
            assertionFailure("Attempted to access invalid section: \(indexPath.section)")
            return UICollectionViewCell()
        }
        switch section {
        case .switchingModels:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: DeveloperModeSwitchCell.className,
                for: indexPath
            ) as? DeveloperModeSwitchCell else { fatalError() }
            
            let model = switchableModels[indexPath.item]
            if model.isEnabled {
                // switchable한 항목은 cell의 선택 여부로 값을 표시 및 저장하므로 select하여 초깃값 설정.
                collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
            }
            cell.configure(with: model)
            return cell
            
        case .normal:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: DeveloperModeNormalCell.className,
                for: indexPath
            ) as? DeveloperModeNormalCell else { fatalError() }
            
            let model = normalStyleModels[indexPath.item]
            cell.configure(with: model)
            return cell
        }
    }
    
}
