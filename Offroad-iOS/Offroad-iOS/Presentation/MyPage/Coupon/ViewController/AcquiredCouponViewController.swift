//
//  AcquiredCouponViewController.swift
//  Offroad-iOS
//
//  Created by  정지원 on 8/27/24.
//

import UIKit

enum SelectedState {
    case available
    case used
    
    var state: Bool {
        switch self {
        case .available:
            return false
        case .used:
            return true
        }
    }
    
    mutating func toggle() {
        self = (self == .available) ? .used : .available
    }
}

final class AcquiredCouponViewController: UIViewController {
    
    // MARK: - Properties
    
    private var availableCouponList: [CouponInfo]? {
        didSet {
            reloadCollectionViews()
        }
    }
    private var usedCouponList: [CouponInfo]? {
        didSet {
            reloadCollectionViews()
        }
    }
    private var availableCouponsCount = 0
    private var usedCouponsCount = 0
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
        fetchAcquiredCouponsData(isUsed: false)
        fetchAcquiredCouponsData(isUsed: true)
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
        
//        fetchAcquiredCouponsData()
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
    
    private func fetchAcquiredCouponsData(isUsed: Bool, cursor: Int = 0) {
        acquiredCouponView.segmentedControl.isUserInteractionEnabled = false
        acquiredCouponView.pageViewController.view.isUserInteractionEnabled = false
        NetworkService.shared.couponService.getAcquiredCouponList(isUsed: false, size: 14, cursor: 0) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let response):
                guard let response else {
                    return
                }
                
                self.availableCouponsCount = response.data.availableCouponsCount
                self.usedCouponsCount = response.data.usedCouponsCount
                
                if isUsed {
                    self.usedCouponList = response.data.coupons
                } else {
                    self.availableCouponList = response.data.coupons
                }
                
                self.acquiredCouponView.segmentedControl.isUserInteractionEnabled = true
                self.acquiredCouponView.pageViewController.view.isUserInteractionEnabled = true
            default:
                return
            }
        }
    }
    
    private func reloadCollectionViews() {
        acquiredCouponView.collectionViewForAvailableCoupons.reloadData()
        acquiredCouponView.collectionViewForUsedCoupons.reloadData()
        acquiredCouponView.segmentedControl.changeSegmentTitle(at: 0, to: "사용 가능 \(availableCouponsCount)")
        acquiredCouponView.segmentedControl.changeSegmentTitle(at: 1, to: "사용 완료 \(usedCouponsCount)")
    }
    
    private func setPageViewControllerPage(to targetIndex: Int) {
        acquiredCouponView.pageViewController.view.isUserInteractionEnabled = false
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
            animated: true,
            completion: { [weak self] isCompleted in
                guard let self else { return }
                self.acquiredCouponView.pageViewController.view.isUserInteractionEnabled = true
            }
        )
    }
    
}

//MARK: - UICollectionViewDataSource

extension AcquiredCouponViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == acquiredCouponView.collectionViewForAvailableCoupons {
            if let availableCouponList {
                return availableCouponList.count
            }
        } else if collectionView == acquiredCouponView.collectionViewForUsedCoupons {
            if let usedCouponList {
                return usedCouponList.count
            }
        } else {
            fatalError()
        }
        return Int()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == acquiredCouponView.collectionViewForAvailableCoupons {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: AvailableCouponCell.className,
                for: indexPath
            ) as? AvailableCouponCell else { fatalError() }
            
            if let availableCouponList {
                cell.configure(with: availableCouponList[indexPath.item])
            }
            return cell
            
        } else if collectionView == acquiredCouponView.collectionViewForUsedCoupons {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: UsedCouponCell.className,
                for: indexPath
            ) as? UsedCouponCell else { fatalError() }
            
            if let usedCouponList {
                cell.configure(with: usedCouponList[indexPath.item])
            }
            return cell
            
        } else {
            fatalError()
        }
        
    }
    
}

//MARK: - UICollectionViewDelegate

extension AcquiredCouponViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard collectionView.cellForItem(at: indexPath) is AvailableCouponCell else { return }
        if let availableCouponList {
            let couponDetailViewController = CouponDetailViewController(coupon: availableCouponList[indexPath.item])
            navigationController?.pushViewController(couponDetailViewController, animated: true)
        }
    }
    
}

//MARK: - ORBSegmentedControlDelegate

extension AcquiredCouponViewController: ORBSegmentedControlDelegate {
    
    func segmentedControlDidSelect(segmentedControl: ORBSegmentedControl, selectedIndex: Int) {
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
