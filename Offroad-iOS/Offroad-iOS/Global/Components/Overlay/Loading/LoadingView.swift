//
//  LoadingView.swift
//  Offroad-iOS
//
//  Created by 김민성 on 11/15/24.
//

import UIKit

import Lottie
import SnapKit

class LoadingView: UIView {
    
    //MARK: - UI Properties
    
    let shadeView = UIView()
    let loadingAnimationView = LottieAnimationView(name: "loading2")
    
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

extension LoadingView {
    
    //MARK: - Layout Func
    
    private func setupLayout() {
        shadeView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        loadingAnimationView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(150)
        }
    }
    
    //MARK: - Private Func
    
    private func setupStyle() {
        shadeView.do { view in
            view.backgroundColor = .blackOpacity(.black55)
        }
        loadingAnimationView.do { animationView in
            animationView.loopMode = .loop
            animationView.contentMode = .scaleAspectFit
            animationView.play()
        }
    }
    
    private func setupHierarchy() {
        addSubviews(shadeView, loadingAnimationView)
    }
    
}

    
   
