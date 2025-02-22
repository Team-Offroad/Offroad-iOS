//
//  ScrollLoadingCollectionView.swift
//  Offroad-iOS
//
//  Created by 김민성 on 12/9/24.
//

import UIKit

import Lottie

class ScrollLoadingCollectionView: EmptyStateCollectionView, ScrollLoading {
    
    var topLoadingAnimationView: Lottie.LottieAnimationView = LottieAnimationView(name: "loading1")
    var leftLoadingAnimationView: Lottie.LottieAnimationView = LottieAnimationView(name: "loading1")
    var rightLoadingAnimationView: Lottie.LottieAnimationView = LottieAnimationView(name: "loading1")
    var bottomLoadingAnimationView: Lottie.LottieAnimationView = LottieAnimationView(name: "loading1")
    
    var currentLoadingDirections: Set<ScrollLoadingDirection> = []
    
    override init(message: String? = nil, frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(message: message, frame: frame, collectionViewLayout: layout)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        currentLoadingDirections.forEach { setLottieFrame(direction: $0) }
    }
    
}
