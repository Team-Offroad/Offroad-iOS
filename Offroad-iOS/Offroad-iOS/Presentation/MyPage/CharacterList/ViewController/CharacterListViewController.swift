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
    
    private let characterListView = CharacterListView()
    private var combinedCharacterList: [(isGained: Bool, character: Any)] = [] {
        didSet {
            characterListView.collectionView.reloadData()
        }
    }
    private var characterImageList = [UIImage?]()
    
    private var representativeCharacterId: Int?
    private var gainedCharacter: [CharacterListData]?
    private var notGainedCharacter: [CharacterListData]?
    
    // MARK: - Life Cycle
    
    override func loadView() {
        self.view = characterListView
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
        characterListView.customBackButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    private func setupDelegate() {
        characterListView.collectionView.delegate = self
        characterListView.collectionView.dataSource = self
    }
    
    private func getCharacterListInfo() {
        NetworkService.shared.characterListService.getCharacterListInfo { response in
            switch response {
            case .success(let data):
                self.gainedCharacter = data?.data.gainedCharacters
                self.notGainedCharacter = data?.data.notGainedCharacters
                self.representativeCharacterId = data?.data.representativeCharacterId
                //이미지 배열 초기화
                self.characterImageList = Array(repeating: nil, count: (self.gainedCharacter?.count ?? 0) + (self.notGainedCharacter?.count ?? 0))
                
                //gainedCharacter와 notGainedCharacter 통합한 업데이트된 배열
                //isGained로 획득 여부 표현
                var newCombinedList: [(isGained: Bool, character: Any)] = []
                self.gainedCharacter?.forEach { gainedCharacter in
                    newCombinedList.append((isGained: true, character: gainedCharacter))
                    self.characterImageList.append(self.convertSvgURLToUIImage(svgUrlString: gainedCharacter.characterThumbnailImageUrl))
                }
                self.notGainedCharacter?.forEach { notGainedCharacter in
                    newCombinedList.append((isGained: false, character: notGainedCharacter))
                    self.characterImageList.append(self.convertSvgURLToUIImage(svgUrlString: notGainedCharacter.characterThumbnailImageUrl))
                }
                self.combinedCharacterList = newCombinedList
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
        return combinedCharacterList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CharacterListCell", for: indexPath) as! CharacterListCell
        let characterData = combinedCharacterList[indexPath.item]
        
        let image = characterImageList[indexPath.item] ?? UIImage(named: "placeholderImage")
        cell.configureCellImage(image: image)
        
        if characterData.isGained, let gainedCharacter = characterData.character as? CharacterListData {
            cell.configureCharacterCell(data: gainedCharacter, gained: characterData.isGained, representiveCharacterId: self.representativeCharacterId ?? 0)
        } else if let notGainedCharacter = characterData.character as? CharacterListData {
            cell.configureCharacterCell(data: notGainedCharacter, gained: characterData.isGained, representiveCharacterId: self.representativeCharacterId ?? 0)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Cell \(indexPath.item) selected")
        let characterData = combinedCharacterList[indexPath.item]
        
        let detailViewController: CharacterDetailViewController
        if characterData.isGained, let gainedCharacter = characterData.character as? CharacterListData {
            detailViewController = CharacterDetailViewController(characterId: gainedCharacter.characterId, representativeCharacterId: representativeCharacterId ?? 0)
            detailViewController.delegate = self
        }
        else { return }
        
        self.navigationController?.pushViewController(detailViewController, animated: true)
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
        characterListView.collectionView.reloadData()
    }
    
}

protocol SelectMainCharacterDelegate: AnyObject {
    func didSelectMainCharacter(characterId: Int)
}
