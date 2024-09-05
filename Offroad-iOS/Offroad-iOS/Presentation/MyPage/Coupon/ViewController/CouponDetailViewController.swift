//
//  CouponDetailViewController.swift
//  Offroad-iOS
//
//  Created by  정지원 on 8/27/24.
//

import UIKit

import SnapKit

class CouponDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    private let couponDetailView = CouponDetailView()
    
    // MARK: - Life Cycle
    
    override func loadView() {
        self.view = couponDetailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTarget()
    }
    
    // MARK: - Initializer
    
    init(image: UIImage?, title: String, description: String) {
        super.init(nibName: nil, bundle: nil)
        couponDetailView.couponImageView.image = image
        couponDetailView.couponTitleLabel.text = title
        couponDetailView.couponDescriptionLabel.text = description
        couponDetailView.couponDescriptionLabel.setLineSpacing(spacing: 5)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTarget() {
        couponDetailView.useButton.addTarget(self, action: #selector(didTapUseButton), for: .touchUpInside)
        
        couponDetailView.couponUsagePopupView.setupCloseButton { [weak self] in
            self?.dismissCouponUsagePopupView()
        }
    }
    
    @objc private func didTapUseButton() {
        presentCouponUsagePopupView()
    }
    
    private func presentCouponUsagePopupView() {
        couponDetailView.couponUsagePopupView.isHidden = false
        couponDetailView.couponUsagePopupView.layer.zPosition = 999
        couponDetailView.couponUsagePopupView.presentPopupView()
    }
    
    private func dismissCouponUsagePopupView() {
        couponDetailView.couponUsagePopupView.dismissPopupView()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.couponDetailView.couponUsagePopupView.isHidden = true
        }
    }
}

