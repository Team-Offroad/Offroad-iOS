//
//  ORBRecommendationChatLogCollectionView.swift
//  ORB_Dev
//
//  Created by 김민성 on 5/2/25.
//

import UIKit

final class ORBRecommendationChatLogCollectionView: UICollectionView {
    
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 0
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        super.init(frame: .zero, collectionViewLayout: layout)
        
        contentInset = .init(top: 110, left: 24, bottom: 0, right: 24)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
