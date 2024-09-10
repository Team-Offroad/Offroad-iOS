//
//  AcquiredCharactersViewController.swift
//  Offroad-iOS
//
//  Created by  정지원 on 8/11/24.
//

import UIKit

final class CharacterListViewController: UIViewController {
    
    // MARK: - Properties
    
    private let characterListView = CharacterListView()
    private var combinedCharacterList: [(isGained: Bool, character: Any)] = [] {
        didSet {
            characterListView.collectionView.reloadData()
        }
    }
    
    private var gainedCharacter: [GainedCharacter]?
    private var notGainedCharacter: [NotGainedCharacter]?
    
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
    
    func getCharacterListInfo() {
        NetworkService.shared.characterListService.getCharacterListInfo { response in
            switch response {
            case .success(let data):
                self.gainedCharacter = data?.data.gainedCharacters
                self.notGainedCharacter = data?.data.notGainedCharacters
                
                //gainedCharacter와 notGainedCharacter 통합한 업데이트된 배열
                //isGained로 획득 여부 표현
                var newCombinedList: [(isGained: Bool, character: Any)] = []
                self.gainedCharacter?.forEach { gainedCharacter in
                    newCombinedList.append((isGained: true, character: gainedCharacter))
                }
                self.notGainedCharacter?.forEach { notGainedCharacter in
                    newCombinedList.append((isGained: false, character: notGainedCharacter))
                }
                self.combinedCharacterList = newCombinedList
            default:
                break
            }
        }
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
        if characterData.isGained, let gainedCharacter = characterData.character as? GainedCharacter {
            cell.gainedCharacterCell(data: gainedCharacter)
        } else if let notGainedCharacter = characterData.character as? NotGainedCharacter {
            cell.notGainedCharacterCell(data: notGainedCharacter)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Cell \(indexPath.item) selected")
        let characterData = combinedCharacterList[indexPath.item]
        
        self.combinedCharacterList = []
        self.gainedCharacter?.forEach { gainedCharacter in
            self.combinedCharacterList.append((isGained: true, character: gainedCharacter))
        }
        self.notGainedCharacter?.forEach { notGainedCharacter in
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
        
        if characterData.isGained, let gainedCharacter = characterData.character as? GainedCharacter {
            detailViewController = CharacterDetailViewController(imageName: gainedCharacter.characterThumbnailImageUrl)
        } else if let notGainedCharacter = characterData.character as? NotGainedCharacter {
            detailViewController = CharacterDetailViewController(imageName: notGainedCharacter.characterThumbnailImageUrl)
        } else {
            return
        }
        let customBackBarButton = UIBarButtonItem(customView: button)
        detailViewController.navigationItem.leftBarButtonItem = customBackBarButton
        
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
}

extension CharacterListViewController {
    
    // MARK: - @Objc Func
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func executePop() {
        navigationController?.popViewController(animated: true)
    }
}


