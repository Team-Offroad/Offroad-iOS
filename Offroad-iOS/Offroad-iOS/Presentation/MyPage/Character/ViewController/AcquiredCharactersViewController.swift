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
        return 10 // Adjust based on your data
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AcquiredCharactersCell", for: indexPath) as! AcquiredCharactersCell
        // Configure the cell here, e.g., setting an image or text if needed
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Handle cell tap, navigate to detail screen
        // Example: Pushing a new view controller or presenting it
    }
}


