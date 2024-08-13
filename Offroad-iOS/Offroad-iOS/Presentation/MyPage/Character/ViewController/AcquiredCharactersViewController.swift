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
        
        setupDelegate()
    }
    
    // MARK: - Private Func
    
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
        cell.configure(imageName: imageName)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 누르면 이동하는 VC
    }
}
