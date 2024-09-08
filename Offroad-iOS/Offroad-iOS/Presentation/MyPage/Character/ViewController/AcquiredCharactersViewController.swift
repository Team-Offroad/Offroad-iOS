//
//  AcquiredCharactersViewController.swift
//  Offroad-iOS
//
//  Created by  정지원 on 8/11/24.
//

import UIKit

class AcquiredCharactersViewController: UIViewController {
    
    // MARK: - Properties
    
    private let acquiredCharactersView = AcquiredCharactersView()
    
    // MARK: - Life Cycle
    
    override func loadView() {
        self.view = acquiredCharactersView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTarget()
        setupDelegate()
    }
    
    // MARK: - Private Func
    
    private func setupTarget() {
        acquiredCharactersView.customBackButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    private func setupDelegate() {
        acquiredCharactersView.collectionView.delegate = self
        acquiredCharactersView.collectionView.dataSource = self
    }
}

extension AcquiredCharactersViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: - CollectionView Func
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AcquiredCharactersCell", for: indexPath) as! AcquiredCharactersCell
        let imageNameIndex = (indexPath.item % 3) + 1
        let imageName = "character_\(imageNameIndex)"
        cell.configureCell(imageName: imageName)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Cell \(indexPath.item) selected")
        let imageNameIndex = (indexPath.item % 3) + 1
        let imageName = "character_\(imageNameIndex)"
        
        let button = UIButton().then { button in
            button.setImage(.backBarButton, for: .normal)
            button.addTarget(self, action: #selector(executePop), for: .touchUpInside)
            button.imageView?.contentMode = .scaleAspectFill
            button.snp.makeConstraints { make in
                make.width.equalTo(30)
                make.height.equalTo(44)
            }
        }
        
        let detailViewController = CharacterDetailViewController(imageName: imageName)
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
