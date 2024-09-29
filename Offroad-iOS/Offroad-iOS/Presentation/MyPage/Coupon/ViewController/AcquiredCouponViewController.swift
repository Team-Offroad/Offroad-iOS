//
//  AcquiredCouponViewController.swift
//  Offroad-iOS
//
//  Created by  정지원 on 8/27/24.
//

import UIKit

class AcquiredCouponViewController: UIViewController {
    
    // MARK: - Properties
    
    private var availableCoupons: [AvailableCoupon] = []
    private var usedCoupons: [UsedCoupon] = []
    private var pageViewController: UIPageViewController {
        acquiredCouponView.pageViewController
    }
    
    // MARK: - UI Properties
    
    private let acquiredCouponView = AcquiredCouponView()
    lazy var viewControllerList: [UIViewController] = [
        CouponCollectionViewController(collectionView: acquiredCouponView.collectionViewForAvailableCoupons),
        CouponCollectionViewController(collectionView: acquiredCouponView.collectionViewForUsedCoupons)
    ]
    
    // MARK: - Life Cycle
    
    override func loadView() {
        view = acquiredCouponView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTarget()
        setupDelegate()
        fetchAcquiredCouponsData()
        acquiredCouponView.segmentedControl.selectSegment(index: 0)
        setPageViewControllerPage(to: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let offroadTabBarController = self.tabBarController as? OffroadTabBarController else { return }
        offroadTabBarController.hideTabBarAnimation()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        fetchAcquiredCouponsData()
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
        acquiredCouponView.segmentedControl.delegate = self
        pageViewController.dataSource = self
        pageViewController.delegate = self
    }
    
    private func fetchAcquiredCouponsData() {
        NetworkService.shared.couponService.getAcquiredCouponList { [weak self] result in
            guard let self else { return }
            
            let alertController: OFRAlertController
            let action = OFRAlertAction(title: "확인", style: .default) { _ in return }
            switch result {
            case .success(let response):
                guard let response else {
                    return
                }
                self.availableCoupons = response.data.availableCoupons
                self.usedCoupons = response.data.usedCoupons
                self.reloadCollectionViews()
            default:
                alertController = OFRAlertController(title: "에러", message: "\(result)", type: .normal)
                alertController.addAction(action)
                alertController.xButton.isHidden = true
                self.present(alertController, animated: true)
            }
        }
    }
    
    private func reloadCollectionViews() {
        acquiredCouponView.collectionViewForAvailableCoupons.reloadData()
        acquiredCouponView.collectionViewForUsedCoupons.reloadData()
    }
    
    private func setPageViewControllerPage(to targetIndex: Int) {
        guard let currentViewCotnroller = pageViewController.viewControllers?.first else {
            // viewDidLoad에서 호출될 때 (처음 한 번)
            pageViewController.setViewControllers([viewControllerList.first!], direction: .forward, animated: false)
            return
        }
        guard let currentIndex = viewControllerList.firstIndex(of: currentViewCotnroller) else { return }
        guard targetIndex >= 0 else { return }
        guard targetIndex < acquiredCouponView.segmentedControl.titles.count,
              targetIndex < viewControllerList.count
        else { return }
        
        pageViewController.setViewControllers(
            [viewControllerList[targetIndex]],
            direction: targetIndex > currentIndex ? .forward : .reverse,
            animated: true
        )
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

//MARK: - OFRSegmentedControlDelegate

extension AcquiredCouponViewController: OFRSegmentedControlDelegate {
    
    func segmentedControlDidSelected(segmentedControl: OFRSegmentedControl, selectedIndex: Int) {
        setPageViewControllerPage(to: selectedIndex)
    }
    
}

//MARK: - UIPageViewControllerDataSource

extension AcquiredCouponViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = viewControllerList.firstIndex(of: viewController) else { return nil }
        let previousIndex = index - 1
        if previousIndex < 0 { return nil }
        return viewControllerList[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = viewControllerList.firstIndex(of: viewController) else { return nil }
        let nextIndex = index + 1
        if nextIndex >= viewControllerList.count { return nil }
        return viewControllerList[nextIndex]
    }
    
}

//MARK: - UIPageViewControllerDelegate

extension AcquiredCouponViewController: UIPageViewControllerDelegate {
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool
    ) {
        guard pageViewController.viewControllers?.first != nil else { return }
        if let index = viewControllerList.firstIndex(of: pageViewController.viewControllers!.first!) {
            acquiredCouponView.segmentedControl.selectSegment(index: index)
        }
    }
    
}
