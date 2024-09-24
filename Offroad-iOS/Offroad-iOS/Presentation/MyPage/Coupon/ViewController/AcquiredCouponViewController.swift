//
//  AcquiredCouponViewController.swift
//  Offroad-iOS
//
//  Created by  정지원 on 8/27/24.
//

import UIKit

class AcquiredCouponViewController: UIViewController {
    
    // MARK: - Properties
    
    private var selectedIndex: Int = 0
    private var availableCoupons: [AvailableCoupon] = []
    private var usedCoupons: [UsedCoupon] = []
    
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
        fetchAcquiredCouponsData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let offroadTabBarController = self.tabBarController as? OffroadTabBarController else { return }
        offroadTabBarController.hideTabBarAnimation()
        
        acquiredCouponView.customSegmentedControl.selectSegment(index: selectedIndex)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        reloadCollectionViews()
    }
}

extension AcquiredCouponViewController{
    
    // MARK: - @objc Method
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
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
    
    private func fetchAcquiredCouponsData() {
        NetworkService.shared.couponService.getAcquiredCouponList { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let response):
                guard let response else {
                    return
                }
                self.availableCoupons = response.data.availableCoupons
                self.usedCoupons = response.data.usedCoupons
                self.reloadCollectionViews()
            default:
                fatalError()
            }
        }
    }
    
    private func reloadCollectionViews() {
        acquiredCouponView.collectionViewForAvailableCoupons.reloadData()
        acquiredCouponView.collectionViewForUsedCoupons.reloadData()
    }
    
}

//MARK: - UICollectionViewDataSource

extension AcquiredCouponViewController: UICollectionViewDataSource {
    
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
        if collectionView == acquiredCouponView.collectionViewForAvailableCoupons {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "AvailableCouponCell",
                for: indexPath
            ) as? AvailableCouponCell else { fatalError() }
            
            cell.configure(with: availableCoupons[indexPath.item])
            return cell
            
        } else if collectionView == acquiredCouponView.collectionViewForUsedCoupons {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "UsedCouponCell",
                for: indexPath
            ) as? UsedCouponCell else { fatalError() }
            
            cell.configure(with: usedCoupons[indexPath.item])
            return cell
            
        } else {
            fatalError()
        }
        
    }
    
}

//MARK: - UICollectionViewDelegate

extension AcquiredCouponViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let couponDetailViewController = CouponDetailViewController(coupon: availableCoupons[indexPath.item])
        navigationController?.pushViewController(couponDetailViewController, animated: true)
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
