//
//  ScrollLoadingCollectionView.swift
//  Offroad-iOS
//
//  Created by 김민성 on 12/9/24.
//

import UIKit

import Lottie

final class ScrollLoadingCollectionView: UICollectionView, ScrollLoading {
    
    var topLoadingAnimationView: Lottie.LottieAnimationView = LottieAnimationView(name: "loading1")
    var leftLoadingAnimationView: Lottie.LottieAnimationView = LottieAnimationView(name: "loading1")
    var rightLoadingAnimationView: Lottie.LottieAnimationView = LottieAnimationView(name: "loading1")
    var bottomLoadingAnimationView: Lottie.LottieAnimationView = LottieAnimationView(name: "loading1")
    
    var currentLoadingDirections: Set<ScrollLoadingDirection> = []
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        currentLoadingDirections.forEach { setLottieFrame(direction: $0) }
    }
    
}
