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
        couponDetailView.couponDescriptionLabel.setLineHeight(percentage: 150)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Func
    
    private func setupTarget() {
        couponDetailView.customBackButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        couponDetailView.useButton.addTarget(self, action: #selector(didTapUseButton), for: .touchUpInside)
    }
    
    private func setupCloseButton(action: @escaping CouponCodeInputPopupView.CloseButtonAction) {
        couponDetailView.couponUsagePopupView.closeButtonAction = action
    }
    
}

extension CouponDetailViewController {
    
    //MARK: - @objc Method
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func textFieldDidChange() {
        let isTextFieldEmpty = couponDetailView.couponUsagePopupView.couponCodeTextField.text?.isEmpty ?? true
        
        if isTextFieldEmpty {
            couponDetailView.couponUsagePopupView.okButton.changeState(forState: .isDisabled)
        } else {
            couponDetailView.couponUsagePopupView.okButton.changeState(forState: .isEnabled)            }
    }
    
    @objc private func didTapUseButton() {
//        let popupViewController = CouponCodeInputPopupViewController()
//        present(popupViewController, animated: false)
        
        
        // 케이스 1
//        let alertController = OFRAlertController(title: "로그아웃", message: "정말 로그아웃 하시겠어요?", type: .normal)
//        let cancelAction = OFRAlertAction(title: "아니오", style: .cancel) { _ in return }
//        let okAction = OFRAlertAction(title: "네", style: .default) { _ in return }
//
//        alertController.addAction(cancelAction)
//        alertController.addAction(okAction)
        
        
        //케이스 2
//        let alertController = OFRAlertController(
//            title: "퀘스트 성공!",
//            message: "퀘스트 '퀘스트 이름' 외 n개를 클리어했어요! 마이페이지에서 보상을 확인해보세요.",
//            type: .normal
//        )
//        let okAction = OFRAlertAction(title: "확인", style: .default) { _ in return }
//        alertController.addAction(okAction)
        
        //케이스 3 (쿠폰 코드 입력)
        let alertController = OFRAlertController(title: "쿠폰 사용", message: "코드를 입력 후 사장님에게 보여주세요", type: .textField)
        let okAction = OFRAlertAction(title: "확인", style: .default) { action in
            return
        }
        alertController.addAction(okAction)
        alertController.configureDefaultTextField { textField in
            textField.placeholder = "매장의 고유 코드를 입력해 주세요"
        }
        
        present(alertController, animated: true)
    }
    
}

