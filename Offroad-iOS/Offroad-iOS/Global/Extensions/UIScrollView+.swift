//
//  UIScrollView+.swift
//  Offroad-iOS
//
//  Created by 김민성 on 11/25/24.
//

import UIKit

import Lottie
import SnapKit

extension UIScrollView {
    
    @objc override func startLoading(withoutShading: Bool = false) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
        // 이미 로딩중인 경우, 추가 로딩 뷰 띄우는 것 방지
            for subView in subviews {
                if subView is LoadingView { return }
            }
            let loadingView = LoadingView()
            loadingView.shadeView.isHidden = withoutShading
            loadingView.isHidden = true
            self.addSubview(loadingView)
            loadingView.snp.makeConstraints { $0.edges.equalTo(self.frameLayoutGuide) }
            UIView.animate(withDuration: 0.2) {
                loadingView.isHidden = false
            }
        }
    }
    
}
