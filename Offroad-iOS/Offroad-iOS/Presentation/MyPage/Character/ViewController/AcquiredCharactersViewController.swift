//
//  AcquiredCharactersViewController.swift
//  Offroad-iOS
//
//  Created by  정지원 on 8/11/24.
//

import UIKit
import SnapKit

class AcquiredCharactersViewController: UIViewController {
    var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    private func configureUI() {
        view.backgroundColor = UIColor.white // Setting the background color to match the screenshot
        setupCollectionView()
    }
}

extension AcquiredCharactersViewController {
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let padding: CGFloat = 20 // Updated padding as needed
        layout.itemSize = CGSize(width: 162, height: 214)  // Ensure this matches cell constraints
        layout.minimumLineSpacing = padding
        layout.minimumInteritemSpacing = padding
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(AcquiredCharactersCell.self, forCellWithReuseIdentifier: "AcquiredCharactersCell")
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
        
        // Calculate the total width used by cells and their spacing
        let totalCellWidth = 2 * layout.itemSize.width
        let totalSpacingWidth = layout.minimumInteritemSpacing
        
        // Calculate the collectionView width including spacing
        let collectionViewWidth = totalCellWidth + totalSpacingWidth
        
        // Center the collectionView in its superview
        collectionView.snp.makeConstraints { make in
            make.centerX.equalToSuperview() // Center horizontally
            make.top.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().offset(-20)
            make.width.equalTo(collectionViewWidth) // Set the width of the collectionView
        }
    }
}

extension AcquiredCharactersViewController: UICollectionViewDelegate, UICollectionViewDataSource {
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



