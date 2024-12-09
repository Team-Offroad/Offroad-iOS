//
//  ScrollLoading.swift
//  Offroad-iOS
//
//  Created by 김민성 on 12/9/24.
//

import UIKit

import Lottie
import SnapKit

enum ScrollLoadingDirection {
    case top
    case left
    case right
    case bottom
}

protocol ScrollLoading: UIScrollView {
    
    var loadingLottieSize: CGSize { get }
    var loadingLottieOffset: CGFloat { get }
    
    var topLoadingAnimationView: LottieAnimationView { get }
    var leftLoadingAnimationView: LottieAnimationView { get }
    var rightLoadingAnimationView: LottieAnimationView { get }
    var bottomLoadingAnimationView: LottieAnimationView { get }
    
    var currentLoadingDirections: Set<ScrollLoadingDirection> { get set }
    
    func startScrollLoading(direction: ScrollLoadingDirection)
    func stopScrollLoading(direction: ScrollLoadingDirection)
    
    func setLottieFrame(direction: ScrollLoadingDirection)
    
}

extension ScrollLoading {
    
    var loadingLottieSize: CGSize { return .init(width: 38, height: 38) }
    var loadingLottieOffset: CGFloat { return 18 }
    
    func startScrollLoading(direction: ScrollLoadingDirection) {
        let loadingLottie: LottieAnimationView
        switch direction {
        case .top:
            loadingLottie = topLoadingAnimationView
        case .left:
            loadingLottie = leftLoadingAnimationView
        case .right:
            loadingLottie = rightLoadingAnimationView
        case .bottom:
            loadingLottie = bottomLoadingAnimationView
        }
        
        // subview로 추가하려는 loadingLottie가 이미 subview로 들어가 있다면 return
        // 아래 둘 중에 어느 게 더 나을 지 모르겠음.
        guard !currentLoadingDirections.contains(where: { $0 == direction }) else { return }
        guard !subviews.contains(where: { $0 == loadingLottie }) else { return }
        
        addSubview(loadingLottie)
        
        addContentInset(direction: direction)
        setLottieFrame(direction: direction)
        
        loadingLottie.loopMode = .loop
        loadingLottie.play()
        currentLoadingDirections.insert(direction)
    }
    
    func stopScrollLoading(direction: ScrollLoadingDirection) {
        let loadingLottie: LottieAnimationView
        switch direction {
        case .top:
            loadingLottie = topLoadingAnimationView
        case .left:
            loadingLottie = leftLoadingAnimationView
        case .right:
            loadingLottie = rightLoadingAnimationView
        case .bottom:
            loadingLottie = bottomLoadingAnimationView
        }
        
        // 현재 지정한 방향에서 스크롤 로딩 중인 경우인지 확인
        guard currentLoadingDirections.contains(where: { $0 == direction }) else { return }
        guard subviews.contains(where: { $0 == loadingLottie }) else { return }
        
        loadingLottie.snp.removeConstraints()
        loadingLottie.removeFromSuperview()
        currentLoadingDirections.remove(direction)
        subtractContentInset(direction: direction)
    }
    
    private func addContentInset(direction: ScrollLoadingDirection) {
        switch direction {
        case .top: contentInset.top += (loadingLottieSize.height +  loadingLottieOffset)
        case .left: contentInset.left += (loadingLottieSize.width +  loadingLottieOffset)
        case .right: contentInset.right += (loadingLottieSize.width +  loadingLottieOffset)
        case .bottom: contentInset.bottom += (loadingLottieSize.height +  loadingLottieOffset)
        }
    }
    
    private func subtractContentInset(direction: ScrollLoadingDirection) {
        switch direction {
        case .top: contentInset.top -= (loadingLottieSize.height + loadingLottieOffset)
        case .left: contentInset.left -= (loadingLottieSize.width + loadingLottieOffset)
        case .right: contentInset.right -= (loadingLottieSize.width + loadingLottieOffset)
        case .bottom: contentInset.bottom -= (loadingLottieSize.height + loadingLottieOffset)
        }
    }
    
    func setLottieFrame(direction: ScrollLoadingDirection) {
        switch direction {
        case .top:
            topLoadingAnimationView.frame = .init(
                x: self.frame.width/2 - loadingLottieSize.width/2,
                y: -(loadingLottieSize.height + loadingLottieOffset),
                width: loadingLottieSize.width,
                height: loadingLottieSize.height
            )
        case .left:
            leftLoadingAnimationView.frame = .init(
                x: -(loadingLottieSize.width + loadingLottieOffset),
                y: self.frame.height/2 - loadingLottieSize.height/2,
                width: loadingLottieSize.width,
                height: loadingLottieSize.height
            )
        case .right:
            rightLoadingAnimationView.frame = .init(
                x: (self.contentSize.width + loadingLottieOffset),
                y: self.frame.height/2 - loadingLottieSize.height/2,
                width: loadingLottieSize.width,
                height: loadingLottieSize.height
            )
        case .bottom:
            bottomLoadingAnimationView.frame = .init(
                x: self.frame.width/2 - loadingLottieSize.width/2,
                y: (self.contentSize.height + loadingLottieOffset),
                width: loadingLottieSize.width,
                height: loadingLottieSize.height
            )
        }
    }
    
}
