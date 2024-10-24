//
//  AcquiredCharactersViewController.swift
//  Offroad-iOS
//
//  Created by  정지원 on 8/11/24.
//

import UIKit

import RxSwift
import RxCocoa
import SVGKit

final class CharacterListViewController: UIViewController, NetworkMonitoring {
    
    var disposeBagForNetworkConnection = DisposeBag()
    var networkConnectionSubject = BehaviorSubject<Bool>(value: false)
    
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
        
        setupTarget()
        setupDelegate()
        viewModel.getCharacterListInfo()
        bindData()
        subscribeNetworkChange()
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
    
    private func setupTarget() {
        rootView.customBackButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    private func setupDelegate() {
        rootView.collectionView.delegate = self
        rootView.collectionView.dataSource = self
    }
    
    private func bindData() {
        viewModel.reloadCollectionView
            .subscribe(on: ConcurrentMainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let self else { return }
                self.rootView.collectionView.reloadData()
            }).disposed(by: disposeBag)
        
        Observable.combineLatest(
            viewDidAppear.take(1),
            viewModel.networkingFailure
        ).subscribe(onNext: { [weak self] _ in
            guard let self else { return }
            self.showToast(message: "네트워크 연결 상태를 확인해주세요.", inset: 66)
        }).disposed(by: disposeBag)
        
        networkConnectionSubject.subscribe(onNext: { [weak self] isConnected in
            guard let self else { return }
            guard isConnected else { return }
            self.viewModel.getCharacterListInfo()
        }).disposed(by: disposeBag)
    }
    
    private func convertSvgURLToUIImage(svgUrlString: String) -> UIImage {
        guard let svgURL = URL(string: svgUrlString) else { return UIImage() }
        guard let svgImage = SVGKImage(contentsOf: svgURL) else { return UIImage() }
        return svgImage.renderedUIImage ?? UIImage()
    }
    
}

//MARK: - UICollectionViewDataSource

extension CharacterListViewController: UICollectionViewDelegate {
    
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

extension CharacterListViewController: UICollectionViewDataSource {
    
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

extension CharacterListViewController {
    
    // MARK: - @Objc Func
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
}

//MARK: - SelectMainCharacterDelegate

extension CharacterListViewController: SelectMainCharacterDelegate {
    
    func didSelectMainCharacter(characterId: Int) {
        viewModel.updateRepresentativeCharacter(id: characterId)
//        representativeCharacterId = characterId
//        rootView.collectionView.reloadData()
    }
    
}

protocol SelectMainCharacterDelegate: AnyObject {
    func didSelectMainCharacter(characterId: Int)
}
