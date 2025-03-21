//
//  CouponCollectionViewController.swift
//  Offroad-iOS
//
//  Created by 김민성 on 9/29/24.
//

import UIKit

///  획득 쿠폰 뷰의 PageViewController안에 보여질 view controller
class CouponCollectionViewController: UIViewController {
    
    //MARK: - UI Properties
    
    let collectionView: UICollectionView
    
    //MARK: - Life Cycle
    
    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = collectionView
    }

}
