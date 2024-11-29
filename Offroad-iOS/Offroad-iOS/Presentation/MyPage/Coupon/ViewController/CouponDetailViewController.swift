//
//  CouponDetailViewController.swift
//  Offroad-iOS
//
//  Created by  정지원 on 8/27/24.
//

import UIKit

import Kingfisher
import RxSwift
import RxCocoa
import SnapKit

class CouponDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    var disposeBag = DisposeBag()
    
    let coupon: CouponInfo
    let couponCodeInputSubject = PublishSubject<String>()
    let afterCouponRedemptionRelay = PublishRelay<Bool>()
    let networkFailRelay = PublishRelay<Void>()
    
    // MARK: - UI Properties
    
    private let couponDetailView = CouponDetailView()
    
    // MARK: - Life Cycle
    
    override func loadView() {
        self.view = couponDetailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTarget()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let offroadTabBarController = self.tabBarController as? OffroadTabBarController else { return }
        offroadTabBarController.hideTabBarAnimation()
    }
    
    init(coupon: CouponInfo) {
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
    
    private func bind() {
        
        couponCodeInputSubject.subscribe { [weak self] codeInput in
            guard let self else { return }
            self.redeemCoupon(code: codeInput)
            //self.redeemCouponTest(code: codeInput)
        }.disposed(by: disposeBag)
        
        
        afterCouponRedemptionRelay
            .observe(on: ConcurrentMainScheduler.instance)
            .subscribe { [weak self] isSuccess in
                guard let self else { return }
                
                let alertController: ORBAlertController
                if isSuccess {
                    alertController = ORBAlertController(
                        title: AlertMessage.couponRedemptionSuccessTitle,
                        message: AlertMessage.couponRedemptionSuccessMessage,
                        type: .normal
                    )
                    self.couponDetailView.useButton.isEnabled = false
                } else {
                    alertController = ORBAlertController(
                        title: AlertMessage.couponRedemptionFailureTitle,
                        message: AlertMessage.couponRedemptionFailureMessage,
                        type: .normal
                    )
                    alertController.configureMessageLabel { label in
                        label.textColor = .primary(.errorNew)
                        label.font = .offroad(style: .iosSubtitle2Semibold)
                    }
                }
                let action = ORBAlertAction(title: "확인", style: .default) { _ in return }
                alertController.addAction(action)

                self.present(alertController, animated: true)
            }.disposed(by: disposeBag)
    }
    
    private func redeemCoupon(code: String) {
        let requestDTO = CouponRedemptionRequestDTO(code: code, couponId: coupon.id ?? Int())
        NetworkService.shared.couponService.postCouponRedemption(body: requestDTO) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let response):
                guard let response else { return }
                print("쿠폰 사용 결과: " + "\(response.data.success)")
                self.afterCouponRedemptionRelay.accept(response.data.success)
            default:
                self.afterCouponRedemptionRelay.accept(false)
                self.showToast(message: ErrorMessages.networkError, inset: 66)
                return
            }
        }
    }
    
    /**
     테스트용 함수.
     
     코드가 0000일 경우 0.3초 후에 응답값 true, 그렇지 않을 경우 응답값 false.
     */
    private func redeemCouponTest(code: String) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.3) { [weak self] in
            guard let self else { return }
            //completion(code == "0000" ? true : false)
            self.afterCouponRedemptionRelay.accept(code == "0000" ? true : false)
        }
    }
    
}

extension CouponDetailViewController {
    
    //MARK: - @objc Method
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func didTapUseButton() {
        
        let alertController = ORBAlertController(title: "쿠폰 사용", message: "코드를 입력 후 사장님에게 보여주세요", type: .textField)
        let okAction = ORBAlertAction(title: "확인", style: .default) { [weak self] action in
            guard let self else { return }
            
            // 여기서 쿠폰 사용 API 호출하기
            self.couponCodeInputSubject.onNext(alertController.textFieldToBeFirstResponder?.text ?? "")
        }
        
        alertController.addAction(okAction)
        alertController.showsKeyboardWhenPresented = true
        alertController.configureDefaultTextField { textField in
            let attributedPlaceholder = NSAttributedString(
                string: "매장의 고유 코드를 입력해 주세요",
                attributes: [.foregroundColor: UIColor.grayscale(.gray300)]
            )
            textField.attributedPlaceholder = attributedPlaceholder
        }
        
        present(alertController, animated: true)
    }
    
    //MARK: - Func
    
    func disableUseButton() {
        couponDetailView.useButton.isEnabled = false
    }
    
}

