//
//  AcquiredCharactersViewController.swift
//  Offroad-iOS
//
//  Created by  정지원 on 8/11/24.
//

import UIKit

final class AcquiredCharactersViewController: UIViewController {
    
    // MARK: - Properties
    
    private let acquiredCharactersView = AcquiredCharactersView()
    private var combinedCharacterList: [(isGained: Bool, character: Any)] = []
    
    private var gainedCharacterList: [GainedCharacterList]?
    private var notGainedCharacterList: [NotGainedCharacterList]?
    
    // MARK: - Life Cycle
    
    override func loadView() {
        self.view = acquiredCharactersView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTarget()
        setupDelegate()
        getAcquiredCharacterInfo()
    }
    
    // MARK: - Private Func
    
    private func setupTarget() {
        acquiredCharactersView.customBackButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    private func setupDelegate() {
        acquiredCharactersView.collectionView.delegate = self
        acquiredCharactersView.collectionView.dataSource = self
    }
    
    func getAcquiredCharacterInfo() {
        NetworkService.shared.acquiredCharacterService.getAcquiredCharacterInfo { response in
            switch response {
            case .success(let data):
                self.gainedCharacterList = data?.data.gainedCharacters
                self.notGainedCharacterList = data?.data.notGainedCharacters
                
                //gainedCharacterList와 notGainedCharacterList 통합한 배열
                //isGained로 획득 여부 표현
                self.combinedCharacterList = []
                self.gainedCharacterList?.forEach { gainedCharacter in
                    self.combinedCharacterList.append((isGained: true, character: gainedCharacter))
                }
                self.notGainedCharacterList?.forEach { notGainedCharacter in
                    self.combinedCharacterList.append((isGained: false, character: notGainedCharacter))
                }
                
                DispatchQueue.main.async {
                    self.acquiredCharactersView.collectionView.reloadData()
                }
            default:
                break
            }
        }
    }
}

extension AcquiredCharactersViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: - CollectionView Func
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return combinedCharacterList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AcquiredCharactersCell", for: indexPath) as! AcquiredCharactersCell
        let characterData = combinedCharacterList[indexPath.item]
        if characterData.isGained, let gainedCharacter = characterData.character as? GainedCharacterList {
            cell.gainedCharacterCell(data: gainedCharacter)
        } else if let notGainedCharacter = characterData.character as? NotGainedCharacterList {
            cell.notGainedCharacterCell(data: notGainedCharacter)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Cell \(indexPath.item) selected")
        let characterData = combinedCharacterList[indexPath.item]
        
        self.combinedCharacterList = []
        self.gainedCharacterList?.forEach { gainedCharacter in
            self.combinedCharacterList.append((isGained: true, character: gainedCharacter))
        }
        self.notGainedCharacterList?.forEach { notGainedCharacter in
            self.combinedCharacterList.append((isGained: false, character: notGainedCharacter))
        }
        
        let button = UIButton().then { button in
            button.setImage(.backBarButton, for: .normal)
            button.addTarget(self, action: #selector(executePop), for: .touchUpInside)
            button.imageView?.contentMode = .scaleAspectFill
            button.snp.makeConstraints { make in
                make.width.equalTo(30)
                make.height.equalTo(44)
            }
        }
        
        let detailViewController: CharacterDetailViewController
        
        if characterData.isGained, let gainedCharacter = characterData.character as? GainedCharacterList {
            detailViewController = CharacterDetailViewController(imageName: gainedCharacter.characterThumbnailImageUrl, characterId: gainedCharacter.characterId)
        } else if let notGainedCharacter = characterData.character as? NotGainedCharacterList {
            detailViewController = CharacterDetailViewController(imageName: notGainedCharacter.characterThumbnailImageUrl, characterId: notGainedCharacter.characterId)
        } else {
            return
        }
        let customBackBarButton = UIBarButtonItem(customView: button)
        detailViewController.navigationItem.leftBarButtonItem = customBackBarButton
        
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
}

extension AcquiredCharactersViewController {
    
    // MARK: - @Objc Func
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func executePop() {
        navigationController?.popViewController(animated: true)
    }
}


