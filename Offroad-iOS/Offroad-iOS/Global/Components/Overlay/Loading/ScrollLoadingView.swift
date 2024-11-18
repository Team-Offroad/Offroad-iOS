//
//  ScrollLoadingView.swift
//  Offroad-iOS
//
//  Created by  정지원 on 11/17/24.
//

import UIKit

import Lottie
import SnapKit

class ScrollLoadingView: UIView {
    
    //MARK: - UI Properties
    
    let backgroundView = UIView()
    let loadingAnimationView = LottieAnimationView(name: "loading1")
    
    //MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupStyle()
        setupHierarchy()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ScrollLoadingView {
    
    //MARK: - Layout Func
    
    private func setupLayout() {
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        loadingAnimationView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(18)
            make.size.equalTo(38)
        }
    }
    
    //MARK: - Private Func
    
    private func setupStyle() {
        backgroundView.do { view in
            view.backgroundColor = .clear
        }
        
        loadingAnimationView.do { animationView in
            animationView.loopMode = .loop
            animationView.contentMode = .scaleAspectFit
            animationView.play()
        }
    }
    
    private func setupHierarchy() {
        addSubviews(backgroundView, loadingAnimationView)
    }
}
