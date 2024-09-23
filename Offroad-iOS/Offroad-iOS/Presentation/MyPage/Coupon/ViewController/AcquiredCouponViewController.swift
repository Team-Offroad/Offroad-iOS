//
//  AcquiredCouponViewController.swift
//  Offroad-iOS
//
//  Created by  정지원 on 8/27/24.
//

import UIKit

class AcquiredCouponViewController: UIViewController {
    
    // MARK: - Properties
    
    var availableCoupons: [AvailableCoupon] = []
    var usedCoupons: [UsedCoupon] = []
    
    // MARK: - UIProperties
    
    private let acquiredCouponView = AcquiredCouponView()
    
    // MARK: - Life Cycle
    
    override func loadView() {
        self.view = acquiredCouponView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTarget()
        setupDelegate()
        getAcquiredCouponsList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let offroadTabBarController = self.tabBarController as? OffroadTabBarController else { return }
        offroadTabBarController.hideTabBarAnimation()
        
        acquiredCouponView.customSegmentedControl.selectSegment(index: 0)
    }
}

extension AcquiredCouponViewController{
    
    // MARK: - Private Func
    
    private func setupTarget() {
        acquiredCouponView.customBackButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    private func setupDelegate() {
        acquiredCouponView.collectionViewForAvailableCoupons.delegate = self
        acquiredCouponView.collectionViewForAvailableCoupons.dataSource = self
    }
    
    private func getAcquiredCouponsList() {
        NetworkService.shared.couponService.getAcquiredCouponList { result in
            switch result {
            case .success(let response):
                guard let response else {
                    print("responseDTO is nil")
                    return
                }
                
            default:
                fatalError()
            }
        }
    }
    
    // MARK: - @objc Method
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

extension AcquiredCouponViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: - CollectionView Func
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AcquiredCouponCell", for: indexPath) as! AcquiredCouponCell
        let imageName = "coffee_coupon"
        cell.configureCell(imageName: imageName, isNew: indexPath.item == 0)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let imageName = "coffee_coupon"
        let image = UIImage(named: imageName)
        let title = "카페 프로토콜 연희점 카페라떼 1잔"
        let description = "프로토콜만의 담백한 맛을 자랑하는 라떼\n카공하기 좋은 프로토콜 카페\n시그니처 카페라떼 한 잔 쿠폰입니다."
        
        let detailVC = CouponDetailViewController(image: image, title: title, description: description)
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}
