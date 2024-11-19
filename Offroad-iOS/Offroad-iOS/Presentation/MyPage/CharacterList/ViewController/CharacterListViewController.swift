//
//  AcquiredCharactersViewController.swift
//  Offroad-iOS
//
//  Created by  정지원 on 8/11/24.
//

import UIKit

import RxSwift
import RxCocoa

final class CharacterListViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel = CharacterListViewModel()
    private let rootView = CharacterListView()
    private var disposeBag = DisposeBag()
    let viewDidAppear = PublishRelay<Void>()
    
    // MARK: - Life Cycle
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDelegate()
        rootView.viewForLoadingOverlay.startLoading(withoutShading: true)
        viewModel.getCharacterListInfo()
        bindData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let offroadTabBarController = self.tabBarController as? OffroadTabBarController else { return }
        offroadTabBarController.hideTabBarAnimation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewDidAppear.accept(())
    }
    
    // MARK: - Private Func
    
    private func setupDelegate() {
        rootView.collectionView.delegate = self
        rootView.collectionView.dataSource = self
    }
    
    private func bindData() {
        viewModel.reloadCollectionView
            .subscribe(onNext: { [weak self] _ in
                guard let self else { return }
                self.rootView.viewForLoadingOverlay.stopLoading()
                self.rootView.collectionView.reloadData()
            }).disposed(by: disposeBag)
        
        Observable.combineLatest(
            viewDidAppear.take(1),
            viewModel.networkingFailure
        ).subscribe(onNext: { [weak self] _ in
            guard let self else { return }
            self.showToast(message: ErrorMessages.networkError, inset: 66)
        }).disposed(by: disposeBag)
        
        NetworkMonitoringManager.shared.networkConnectionChanged
            .subscribe(onNext: { [weak self] isConnected in
                guard let self else { return }
                if isConnected {
                    self.viewModel.getCharacterListInfo()
                } else {
                    self.showToast(message: ErrorMessages.networkError, inset: 66)
                }
            }).disposed(by: disposeBag)
        
        rootView.customBackButton.rx.tap.bind(onNext: { [weak self] in
            guard let self else { return }
            self.navigationController?.popViewController(animated: true)
        }).disposed(by: disposeBag)
    }
    
    // MARK: - Func
    
    func setupCustomBackButton(buttonTitle: String) {
        rootView.customBackButton.configureButtonTitle(titleString: buttonTitle)
    }
}

//MARK: - UICollectionViewDataSource

extension CharacterListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.characterListDataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterListCell.className, for: indexPath) as? CharacterListCell else { fatalError() }
        guard let representativeCharacterId = viewModel.representativeCharacterId else { return cell }
        cell.configure(with: viewModel.characterListDataSource[indexPath.item], representativeCharacterId: representativeCharacterId)
        return cell
    }
    
}

//MARK: - UICollectionViewDelegate

extension CharacterListViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let representativeCharacterId = viewModel.representativeCharacterId else { return }
        let characterDetailViewController = CharacterDetailViewController(
            characterId: viewModel.characterListDataSource[indexPath.item].characterId,
            representativeCharacterId: representativeCharacterId
        )
        characterDetailViewController.delegate = self
        navigationController?.pushViewController(characterDetailViewController, animated: true)
    }
    
}

//MARK: - SelectMainCharacterDelegate

extension CharacterListViewController: SelectMainCharacterDelegate {
    
    func didSelectMainCharacter(characterId: Int) {
        viewModel.updateRepresentativeCharacter(id: characterId)
    }
    
}

protocol SelectMainCharacterDelegate: AnyObject {
    func didSelectMainCharacter(characterId: Int)
}
