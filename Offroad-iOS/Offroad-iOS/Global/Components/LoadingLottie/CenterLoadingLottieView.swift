//
//  CenterLoadingLottieView.swift
//  Offroad-iOS
//
//  Created by  정지원 on 11/13/24.
//


import UIKit

import SnapKit
import Lottie
import Then

class CenterLoadingLottieView: UIView {
    
    private let backgroundView = UIView().then {
        $0.backgroundColor = .blackOpacity(.black55)
        $0.alpha = 0.0
    }
    
    private let lottieView = LottieAnimationView(name: "loading2").then {
        $0.loopMode = .loop
        $0.contentMode = .scaleAspectFit
        $0.alpha = 0.0
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupHierarchy()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupHierarchy()
        setupLayout()
    }
    
    // MARK: - Private Func
    
    private func setupHierarchy() {
        addSubviews(backgroundView,lottieView)
    }
    
    private func setupLayout() {
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        lottieView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(100)
        }
    }
    
    func showCenterLottieView(in view: UIView) {
        view.addSubview(self)
        self.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            self.backgroundView.alpha = 1.0
            self.lottieView.alpha = 1.0
        }) { _ in
            self.lottieView.play()
        }
    }
    
    func hideCenterLottieView() {
        UIView.animate(withDuration: 0.3, animations: {
            self.backgroundView.alpha = 0.0
            self.lottieView.alpha = 0.0
        }) { _ in
            self.lottieView.stop()
            self.removeFromSuperview()
        }
    }
}
