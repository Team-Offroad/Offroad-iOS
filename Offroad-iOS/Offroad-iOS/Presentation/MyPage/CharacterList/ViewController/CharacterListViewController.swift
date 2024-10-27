//
//  AcquiredCharactersViewController.swift
//  Offroad-iOS
//
//  Created by  정지원 on 8/11/24.
//

import UIKit

import SVGKit

final class CharacterListViewController: UIViewController {
    
    // MARK: - Properties
    
    private let rootView = CharacterListView()
    
    private var representativeCharacterId: Int?
    private var gainedCharacters: [CharacterListInfo]?
    private var notGainedCharacters: [CharacterListInfo]?
    
    private var characterListDataSource: [CharacterListInfoData] = []
    
    // MARK: - Life Cycle
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTarget()
        setupDelegate()
        getCharacterListInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let offroadTabBarController = self.tabBarController as? OffroadTabBarController else { return }
        offroadTabBarController.hideTabBarAnimation()
    }
    
    // MARK: - Private Func
    
    private func setupTarget() {
        rootView.customBackButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    private func setupDelegate() {
        rootView.collectionView.delegate = self
        rootView.collectionView.dataSource = self
    }
    
    private func getCharacterListInfo() {
        NetworkService.shared.characterService.getCharacterListInfo { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let responseDTO):
                guard let responseDTO else { return }

                let gainedData = responseDTO.data.gainedCharacters.map({ CharacterListInfoData(info: $0, isGained: true) })
                let notGainedData = responseDTO.data.notGainedCharacters.map({ CharacterListInfoData(info: $0, isGained: false) })
                self.representativeCharacterId = responseDTO.data.representativeCharacterId
                self.characterListDataSource = gainedData + notGainedData
                self.rootView.collectionView.reloadData()
            default:
                break
            }
        }
    }
    
    private func convertSvgURLToUIImage(svgUrlString: String) -> UIImage {
        guard let svgURL = URL(string: svgUrlString) else { return UIImage() }
        guard let svgImage = SVGKImage(contentsOf: svgURL) else { return UIImage() }
        return svgImage.renderedUIImage ?? UIImage()
    }
    
}

extension CharacterListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: - CollectionView Func
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        characterListDataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterListCell.className, for: indexPath) as? CharacterListCell else { fatalError() }
        guard let representativeCharacterId else { return cell }
        cell.configure(with: characterListDataSource[indexPath.item], representativeCharacterId: representativeCharacterId)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let representativeCharacterId else { return }
        let characterDetailViewController = CharacterDetailViewController(
            characterId: characterListDataSource[indexPath.item].characterId,
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

extension CharacterListViewController: SelectMainCharacterDelegate {
    
    func didSelectMainCharacter(characterId: Int) {
        representativeCharacterId = characterId
        rootView.collectionView.reloadData()
    }
    
}

protocol SelectMainCharacterDelegate: AnyObject {
    func didSelectMainCharacter(characterId: Int)
}
