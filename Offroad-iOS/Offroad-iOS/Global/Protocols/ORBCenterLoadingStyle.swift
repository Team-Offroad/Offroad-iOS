//
//  ORBCenterLoadingStyle.swift
//  Offroad-iOS
//
//  Created by 김민성 on 4/2/25.
//

import UIKit

import Lottie
import SnapKit

/// 어떤 뷰의 중앙에 로딩 화면을 띄우고자 할 경우, 해당 뷰에서 이 프로토콜을 채택하세요.
public protocol ORBCenterLoadingStyle: UIView {
    
    func startCenterLoading(withoutShading: Bool)
    func stopCenterLoading()
    
}

public extension ORBCenterLoadingStyle {
    
    /// 화면 중앙 로딩 시작.
    /// - Parameter withoutShading: 로딩 시 배경을 어둡게 할 지 여부. true일 경우 어두워지지 않음. false인 경우 어두워짐.
    ///
    /// 만약 화면 중앙 로딩중인 경우, 추가적인 로딩 뷰를 띄우지 않으며, withoutShading 값에 따라 업데이트할 뿐.
    func startCenterLoading(withoutShading: Bool) {
        for subview in subviews {
            if let _ = subview as? ORBLoadingView {
                subview.backgroundColor = withoutShading ? .clear : .black.withAlphaComponent(0.55)
                return
            }
        }
        
        let loadingView = ORBLoadingView()
        if !withoutShading { loadingView.backgroundColor = .black.withAlphaComponent(0.55) }
        
        addSubview(loadingView)
        
        if let scrollView = self as? UIScrollView {
            loadingView.snp.makeConstraints { $0.edges.equalTo(scrollView.frameLayoutGuide) }
        } else {
            loadingView.snp.makeConstraints { $0.edges.equalToSuperview() }
        }
    }
    
    /// 화면 중앙 로딩중일 경우, 로딩을 종료.
    func stopCenterLoading() {
        subviews.forEach { view in
            if let loadingView = view as? ORBLoadingView { loadingView.removeFromSuperview() }
        }
    }
    
}

/// 화면 중앙 로딩에 사용될 로딩 뷰. 
fileprivate final class ORBLoadingView: UIView {
    
    let lottie = Lottie.LottieAnimationView(name: "loading2")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        lottie.loopMode = .loop
        lottie.play()
        addSubview(lottie)
        lottie.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(150)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
