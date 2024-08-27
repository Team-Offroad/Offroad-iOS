//
//  AcquiredCouponViewController.swift
//  Offroad-iOS
//
//  Created by  정지원 on 8/27/24.
//

import UIKit

class AcquiredCouponViewController: UIViewController {
    
    // MARK: - Properties
    
    private let acquiredCouponView = AcquiredCouponView()
    
    // MARK: - Life Cycle
    
    override func loadView() {
        self.view = acquiredCouponView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDelegate()
    }
    
    // MARK: - Private Func
    
    private func setupDelegate() {
        acquiredCouponView.collectionView.delegate = self
        acquiredCouponView.collectionView.dataSource = self
    }
}

extension AcquiredCouponViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: - CollectionView Func
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AcquiredCouponCell", for: indexPath) as! AcquiredCouponCell
        let imageName = "coffee_coupon"
        cell.configureCell(imageName: imageName, isNew: indexPath.item == 0)
        
        return cell
    }
}
