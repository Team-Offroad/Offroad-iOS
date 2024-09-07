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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let offroadTabBarController = self.tabBarController as? OffroadTabBarController else { return }
        offroadTabBarController.hideTabBarAnimation()
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
    
    // MARK: - Private Func
    
    private func setupTarget() {
        couponDetailView.customBackButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        couponDetailView.useButton.addTarget(self, action: #selector(didTapUseButton), for: .touchUpInside)
        couponDetailView.couponUsagePopupView.codeTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        couponDetailView.couponUsagePopupView.closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        couponDetailView.couponUsagePopupView.checkButton.addTarget(self, action: #selector(checkButtonTapped), for: .touchUpInside)
        
        
        setupCloseButton { [weak self] in
            self?.dismissCouponUsagePopupView()
        }
    }
    
    private func presentCouponUsagePopupView() {
        couponDetailView.couponUsagePopupView.isHidden = false
        couponDetailView.couponUsagePopupView.layer.zPosition = 999
        presentPopupView()
    }
    
    private func dismissCouponUsagePopupView() {
        dismissPopupView()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.couponDetailView.couponUsagePopupView.isHidden = true
        }
    }
    
    private func setupCloseButton(action: @escaping CouponUsagePopupView.CloseButtonAction) {
        couponDetailView.couponUsagePopupView.closeButtonAction = action
    }
    
    private func presentPopupView() {
        couponDetailView.couponUsagePopupView.backgroundColor = .blackOpacity(.black55)
        couponDetailView.couponUsagePopupView.popupView.executePresentPopupAnimation()
    }
    
    private func dismissPopupView() {
        couponDetailView.couponUsagePopupView.backgroundColor = .clear
        couponDetailView.couponUsagePopupView.popupView.executeDismissPopupAnimation()
    }
}

extension CouponDetailViewController {
    
    //MARK: - @objc Method
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func textFieldDidChange() {
        let isTextFieldEmpty = couponDetailView.couponUsagePopupView.codeTextField.text?.isEmpty ?? true
        
        if isTextFieldEmpty {
            couponDetailView.couponUsagePopupView.checkButton.changeState(forState: .isDisabled)
        } else {
            couponDetailView.couponUsagePopupView.checkButton.changeState(forState: .isEnabled)            }
    }
    
    @objc private func didTapUseButton() {
        presentCouponUsagePopupView()
    }
    
    @objc private func closeButtonTapped() {
        couponDetailView.couponUsagePopupView.closeButtonAction?()
        dismissPopupView()
    }
    
    @objc private func checkButtonTapped() {
        couponDetailView.couponUsagePopupView.closeButtonAction?()
        dismissPopupView()
    }
}

