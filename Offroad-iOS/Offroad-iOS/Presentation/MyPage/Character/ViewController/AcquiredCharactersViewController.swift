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
    private let acquiredCharactersCell = AcquiredCharactersCell()
    
    private var gainedCharacterList: [GainedCharacterList]?
    private var notGainedCHaracterList: [NotGainedCharacterList]?
    
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
                self.gainedCharacterList = data?.data.isGainedCharacters
                self.notGainedCHaracterList = data?.data.isNotGainedCharacters
                
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
        return gainedCharacterList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AcquiredCharactersCell", for: indexPath) as! AcquiredCharactersCell
        if let characterData = gainedCharacterList?[indexPath.item] {
                    cell.configureCell(data: characterData)
                }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Cell \(indexPath.item) selected")
        let characterData = gainedCharacterList?[indexPath.item]
        
        let button = UIButton().then { button in
            button.setImage(.backBarButton, for: .normal)
            button.addTarget(self, action: #selector(executePop), for: .touchUpInside)
            button.imageView?.contentMode = .scaleAspectFill
            button.snp.makeConstraints { make in
                make.width.equalTo(30)
                make.height.equalTo(44)
            }
        }
        
        let detailViewController = CharacterDetailViewController(imageName: characterData?.characterThumbnailImageUrl ?? "")
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
