//
//  ORBScrollLoadingStyle.swift
//  Offroad-iOS
//
//  Created by 김민성 on 4/2/25.
//

import UIKit

import Lottie
import SnapKit

/// 무한스크롤 시 scroll view 컨텐츠 아래에 로딩 화면을 띄우고자 할 경우, 해당 scroll view에서 이 프로토콜을 채택하세요.
public protocol ORBScrollLoadingStyle: UIScrollView {
    
    /// scroll view의 loading lottie가 content로부터 떨어져 있는 값.
    var scrollLoadingLottieOffset: CGFloat { get }
    
    /// loading lottie의 한 변의 길이 (scroll loading lottie는 정방형 비율)
    var scrollLoadingLottieSideLength: CGFloat { get }
    
    /// 로딩 시 스크롤 방향으로 추가될 영역의 길이.
    var additionalContentInset: CGFloat { get }
    
    func startBottomScrollLoading()
    func stopBottomScrollLoading()
    
}

public extension ORBScrollLoadingStyle {
    
    var scrollLoadingLottieOffset: CGFloat { 18 }
    var scrollLoadingLottieSideLength: CGFloat { 38 }
    var additionalContentInset: CGFloat { scrollLoadingLottieSideLength + (scrollLoadingLottieOffset * 2) }
    
    /// scroll view 아래쪽의 무한 스크롤 로딩 화면을 띄웁니다.
    func startBottomScrollLoading() {
        let scrollLoadingView = ORBScrollLoadingView()
        contentInset.bottom += additionalContentInset
        addSubview(scrollLoadingView)
        layoutIfNeeded()
        scrollLoadingView.frame = .init(
            x: bounds.width/2 - scrollLoadingLottieSideLength/2,
            y: contentSize.height + scrollLoadingLottieOffset,
            width: scrollLoadingLottieSideLength,
            height: scrollLoadingLottieSideLength
        )
    }
    
    /// scroll view 컨텐츠 아래쪽에 무한 스크롤 로딩이 있다면 로딩을 멈추고 추가된 영역을 없앱니다.
    func stopBottomScrollLoading() {
        var isScrollLoading: Bool = false
        subviews.forEach { view in
            if let scrollLoadingView = view as? ORBScrollLoadingView {
                scrollLoadingView.removeFromSuperview()
                isScrollLoading = true
            }
        }
        if isScrollLoading {
            // contentInset.bottom을 바꾸는 동작을 동기적으로 구현하면 scrollView의 스크롤 애니메이션이 끊기는 현상이 있어서,
            // DispatchQueue.main 큐에 비동기로 보냄.
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.contentInset.bottom -= self.additionalContentInset
                layoutSubviews()
            }
        }
    }
    
}


/// ORBScrollLoadinStyle에 사용될 lottie를 포함하는 뷰. 이 뷰의 크기가 곧 로티의 크기에 해당.
fileprivate final class ORBScrollLoadingView: UIView {
    
    private let lottie = Lottie.LottieAnimationView(name: "loading1")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // setup style
        isUserInteractionEnabled = false
        lottie.loopMode = .loop
        lottie.play()
        
        // setup view hierarchy
        addSubview(lottie)
        
        // setup view layout
        lottie.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
