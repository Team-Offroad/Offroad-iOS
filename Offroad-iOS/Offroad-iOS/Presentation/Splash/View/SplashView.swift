//
//  SplashView.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 7/8/24.
//

import UIKit

import SnapKit
import Then

final class SplashView: UIView {
    
    //MARK: - UI Properties
    
    private let offroadLogoImageView = UIImageView(image: UIImage(resource: .imgOffroadLogoSplash))
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupHierarchy()
        setupStyle()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SplashView {
    
    // MARK: - Layout
    
    private func setupStyle() {
        backgroundColor = .main(.main2)
    }
    
    private func setupHierarchy() {
        addSubview(offroadLogoImageView)
    }
    
    private func setupLayout() {
        offroadLogoImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    //MARK: - Private Func
    
    func dismissOffroadLogiView(completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0.4, animations: {
            self.offroadLogoImageView.alpha = 0
        }, completion: { _ in
            completion()
        })
    }
}
