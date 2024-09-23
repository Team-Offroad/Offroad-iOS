//
//  AcquiredCouponViewController.swift
//  Offroad-iOS
//
//  Created by  정지원 on 8/27/24.
//

import UIKit

class AcquiredCouponViewController: UIViewController {
    
    // MARK: - Properties
    
    var selectedIndex: Int = 0
    
    var availableCoupons: [AvailableCoupon] = [
        AvailableCoupon(id: 0, name: "사용가능 쿠폰", couponImageUrl: "", description: "사용 가능 쿠폰입니다", isNewGained: false, placeId: 0),
        AvailableCoupon(id: 1, name: "사용가능 쿠폰", couponImageUrl: "", description: "사용 가능 쿠폰입니다", isNewGained: false, placeId: 1),
        AvailableCoupon(id: 2, name: "사용가능 쿠폰", couponImageUrl: "", description: "사용 가능 쿠폰입니다", isNewGained: false, placeId: 2),
        AvailableCoupon(id: 3, name: "사용가능 쿠폰", couponImageUrl: "", description: "사용 가능 쿠폰입니다", isNewGained: false, placeId: 3),
        AvailableCoupon(id: 4, name: "사용가능 쿠폰", couponImageUrl: "", description: "사용 가능 쿠폰입니다", isNewGained: false, placeId: 4),
        AvailableCoupon(id: 5, name: "사용가능 쿠폰", couponImageUrl: "", description: "사용 가능 쿠폰입니다", isNewGained: false, placeId: 5)
    ]
    
    var usedCoupons: [UsedCoupon] = [
        UsedCoupon(name: "이미 사용된 쿠폰", couponImageUrl: ""),
        UsedCoupon(name: "이미 사용된 쿠폰", couponImageUrl: ""),
        UsedCoupon(name: "이미 사용된 쿠폰", couponImageUrl: ""),
        UsedCoupon(name: "이미 사용된 쿠폰", couponImageUrl: "")
    ]
    
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
        
        acquiredCouponView.customSegmentedControl.selectSegment(index: selectedIndex)
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
        acquiredCouponView.collectionViewForUsedCoupons.delegate = self
        acquiredCouponView.collectionViewForUsedCoupons.dataSource = self
        acquiredCouponView.customSegmentedControl.delegate = self
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
        if collectionView == acquiredCouponView.collectionViewForAvailableCoupons {
            return availableCoupons.count
        } else if collectionView == acquiredCouponView.collectionViewForUsedCoupons {
            return usedCoupons.count
        } else {
            fatalError()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let imageName = "coffee_coupon"
        
        if collectionView == acquiredCouponView.collectionViewForAvailableCoupons {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AvailableCouponCell", for: indexPath) as? AvailableCouponCell else { fatalError() }
            
            //cell.configureCell(imageName: imageName, isNew: indexPath.item == 0)
            cell.configure(with: availableCoupons[indexPath.item])
            return cell
            
        } else if collectionView == acquiredCouponView.collectionViewForUsedCoupons {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UsedCouponCell", for: indexPath) as? UsedCouponCell else { fatalError() }
            
            //cell.configureCell(imageName: imageName, isNew: indexPath.item == 0)
            cell.configure(with: usedCoupons[indexPath.item])
            return cell
            
        } else {
            fatalError()
        }
        
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

//MARK: - CustomSegmentedControlDelegate

extension AcquiredCouponViewController: CustomSegmentedControlDelegate {
    func segmentedControlDidSelected(segmentedControl: CustomSegmentedControl, selectedIndex: Int) {
        print(#function, selectedIndex)
        self.selectedIndex = selectedIndex
        
        acquiredCouponView.collectionViewForAvailableCoupons.isHidden = selectedIndex == 1
        acquiredCouponView.collectionViewForUsedCoupons.isHidden = selectedIndex == 0
        
        acquiredCouponView.collectionViewForAvailableCoupons.reloadData()
        acquiredCouponView.collectionViewForUsedCoupons.reloadData()
    }
}
