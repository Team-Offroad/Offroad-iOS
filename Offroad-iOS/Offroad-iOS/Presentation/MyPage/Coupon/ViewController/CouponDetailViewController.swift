//
//  CouponDetailViewController.swift
//  Offroad-iOS
//
//  Created by  정지원 on 8/27/24.
//

import UIKit

import Kingfisher
import SnapKit

class CouponDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    let coupon: AvailableCoupon
    
    // MARK: - UI Properties
    
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
    
    init(coupon: AvailableCoupon) {
        self.coupon = coupon
        super.init(nibName: nil, bundle: nil)
        
        let url = URL(string: coupon.couponImageUrl)
        couponDetailView.couponImageView.kf.setImage(with: url)
        couponDetailView.couponTitleLabel.text = coupon.name
        couponDetailView.couponDescriptionLabel.text = coupon.description
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Func
    
    private func setupTarget() {
        couponDetailView.customBackButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        couponDetailView.useButton.addTarget(self, action: #selector(didTapUseButton), for: .touchUpInside)
    }
    
    private func redeemCoupon(code: String) {
        let requestDTO = CouponRedemptionRequestDTO(code: code, couponId: coupon.id)
        NetworkService.shared.couponService.postCouponRedemption(
            // 현재 result를 받아오지 못하고, 서버에서 404에러를 응답함. (없는 장소 Id라고 뜸)
            body: requestDTO) { result in
                switch result {
                case .success(let response):
                    guard let response else { return }
                    print("쿠폰 사용 결과: " + "\(response.data.success)")
                default:
                    return
                }
            }
    }
    
}

extension CouponDetailViewController {
    
    //MARK: - @objc Method
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func didTapUseButton() {
        let alertController = OFRAlertController(title: "쿠폰 사용", message: "코드를 입력 후 사장님에게 보여주세요", type: .textField)
        let okAction = OFRAlertAction(title: "확인", style: .default) { action in
            print("확인 버튼 눌림")
            alertController.dismiss(animated: true) { [weak self] in
                guard let self else { return }
                let alertController = OFRAlertController(title: "사용 완료", message: "쿠폰 사용이 완료되었어요!", type: .normal)
                let action = OFRAlertAction(title: "확인", style: .default) { action in
                    alertController.dismiss(animated: true)
                }
                alertController.addAction(action)
                self.present(alertController, animated: true)
            }
            return
        }
        alertController.addAction(okAction)
        alertController.showsKeyboardWhenPresented = true
        alertController.configureDefaultTextField { textField in
            textField.placeholder = "매장의 고유 코드를 입력해 주세요"
            textField.keyboardType = .numberPad
        }
        
        present(alertController, animated: true)
    }
    
}

