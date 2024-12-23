//
//  CouponListViewController.swift
//  Offroad-iOS
//
//  Created by  정지원 on 8/27/24.
//

import UIKit

import RxSwift

final class CouponListViewController: UIViewController {
    
    // MARK: - Properties
    private var disposBag = DisposeBag()
    private var availableCouponsCount = 0
    private var usedCouponsCount = 0
    private var lastCursorIDForAvailableCoupons: Int = 0
    private var lastCursorIDForUsedCoupons: Int = 0
    private var lastIndexPathForAvailableCoupons: IndexPath? = nil
    private var lastIndexPathForUsedCoupons: IndexPath? = nil
    private var availableCouponDataSource: [CouponInfo] = []
    private var usedCouponDataSource: [CouponInfo] = []
    
    private var pageViewController: UIPageViewController {
        rootView.pageViewController
    }
    
    // MARK: - UI Properties
    
    private let rootView = CouponListView()
    
    lazy var viewControllerList: [UIViewController] = [
        CouponCollectionViewController(collectionView: rootView.collectionViewForAvailableCoupons),
        CouponCollectionViewController(collectionView: rootView.collectionViewForUsedCoupons)
    ]
    
    // MARK: - Life Cycle
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTarget()
        setupDelegate()
        bindData()
        rootView.segmentedControl.selectSegment(index: 0)
        setPageViewControllerPage(to: 0)
        getCouponListsFromServer(isUsed: false, size: 14, cursor: lastCursorIDForAvailableCoupons)
        getCouponListsFromServer(isUsed: true, size: 14, cursor: lastCursorIDForUsedCoupons)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let offroadTabBarController = self.tabBarController as? OffroadTabBarController else { return }
        offroadTabBarController.hideTabBarAnimation()
    }
}

extension CouponListViewController{
    
    // MARK: - @objc Method
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Private Func
    
    private func setupTarget() {
        rootView.customBackButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    private func setupDelegate() {
        rootView.collectionViewForAvailableCoupons.delegate = self
        rootView.collectionViewForAvailableCoupons.dataSource = self
        rootView.collectionViewForUsedCoupons.delegate = self
        rootView.collectionViewForUsedCoupons.dataSource = self
        rootView.segmentedControl.delegate = self
        pageViewController.dataSource = self
        pageViewController.delegate = self
    }
    
    private func bindData() {
        NetworkMonitoringManager.shared.networkConnectionChanged.subscribe(onNext: { [weak self] isConnected in
            guard let self else { return }
            guard isConnected else {
                self.showToast(message: ErrorMessages.networkError, inset: 66)
                return
            }
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                //무한스크롤로 불러왔던 데이터 모두 초기화 후 다시 처음부터 불러오기
                self.availableCouponDataSource = []
                self.usedCouponDataSource = []
                self.rootView.collectionViewForAvailableCoupons.reloadData()
                self.rootView.collectionViewForAvailableCoupons.startLoading(withoutShading: true)
                self.rootView.collectionViewForUsedCoupons.reloadData()
                self.rootView.collectionViewForUsedCoupons.startLoading(withoutShading: true)
                self.getCouponListsFromServer(isUsed: false, size: 14, cursor: 0)
                self.getCouponListsFromServer(isUsed: true, size: 14, cursor: 0)
            }
        }).disposed(by: disposBag)
    }
    
    private func setPageViewControllerPage(to targetIndex: Int) {
        rootView.pageViewController.view.isUserInteractionEnabled = false
        guard let currentViewCotnroller = pageViewController.viewControllers?.first else {
            // viewDidLoad에서 호출될 때 (처음 한 번)
            pageViewController.setViewControllers([viewControllerList.first!], direction: .forward, animated: false)
            rootView.pageViewController.view.isUserInteractionEnabled = true
            return
        }
        guard let currentIndex = viewControllerList.firstIndex(of: currentViewCotnroller) else { return }
        guard targetIndex >= 0 else { return }
        guard targetIndex < rootView.segmentedControl.titles.count,
              targetIndex < viewControllerList.count
        else {
            rootView.pageViewController.view.isUserInteractionEnabled = true
            return
        }
        
        pageViewController.setViewControllers(
            [viewControllerList[targetIndex]],
            direction: targetIndex > currentIndex ? .forward : .reverse,
            animated: true,
            completion: { [weak self] isCompleted in
                guard let self else { return }
                self.rootView.pageViewController.view.isUserInteractionEnabled = true
            }
        )
    }
    
    private func getCouponListsFromServer(isUsed: Bool, size: Int, cursor: Int) {
        NetworkService.shared.couponService.getAcquiredCouponList(isUsed: isUsed, size: size, cursor: cursor) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let response):
                guard let response else {
                    return
                }
                guard response.data.coupons.count > 0 else {
                    if isUsed {
                        self.rootView.collectionViewForUsedCoupons.emptyState = true
                    } else {
                        self.rootView.collectionViewForAvailableCoupons.emptyState = true
                    }
                    return
                }
                if isUsed {
                    self.rootView.collectionViewForUsedCoupons.stopLoading()
                    self.rootView.collectionViewForUsedCoupons.emptyState = false
                } else {
                    self.rootView.collectionViewForAvailableCoupons.stopLoading()
                    self.rootView.collectionViewForAvailableCoupons.emptyState = false
                }
                
                self.availableCouponsCount = response.data.availableCouponsCount
                self.usedCouponsCount = response.data.usedCouponsCount
                
                if isUsed {
                    self.usedCouponDataSource.append(contentsOf: response.data.coupons)
                    self.lastCursorIDForUsedCoupons = response.data.coupons.last!.cursorId
                    self.rootView.collectionViewForUsedCoupons.stopScrollLoading(direction: .bottom)
                    self.rootView.collectionViewForUsedCoupons.reloadData()
                    self.rootView.segmentedControl.changeSegmentTitle(at: 1, to: "사용 완료 \(usedCouponsCount)")
                    self.lastIndexPathForUsedCoupons = IndexPath(item: self.usedCouponDataSource.count - 1, section: 0)
                } else {
                    self.availableCouponDataSource.append(contentsOf: response.data.coupons)
                    self.lastCursorIDForAvailableCoupons = response.data.coupons.last!.cursorId
                    self.rootView.collectionViewForAvailableCoupons.stopScrollLoading(direction: .bottom)
                    self.rootView.collectionViewForAvailableCoupons.reloadData()
                    self.rootView.segmentedControl.changeSegmentTitle(at: 0, to: "사용 가능 \(availableCouponsCount)")
                    self.lastIndexPathForAvailableCoupons = IndexPath(item: self.availableCouponDataSource.count - 1, section: 0)
                }
            default:
                return
            }
        }
    }
    
}

//MARK: - UICollectionViewDataSource

extension CouponListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == rootView.collectionViewForUsedCoupons {
            return usedCouponDataSource.count
        } else if collectionView == rootView.collectionViewForAvailableCoupons {
            return availableCouponDataSource.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CouponCell.className, for: indexPath) as? CouponCell else { fatalError() }
        
        if collectionView == rootView.collectionViewForUsedCoupons {
            cell.configureUsedCell(with: usedCouponDataSource[indexPath.item])
        } else if collectionView == rootView.collectionViewForAvailableCoupons {
            cell.configureAvailableCell(with: availableCouponDataSource[indexPath.item])
        }
        return cell
    }
    
}

//MARK: - UICollectionViewDelegate

extension CouponListViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        guard collectionView == rootView.collectionViewForAvailableCoupons
                || collectionView == rootView.collectionViewForUsedCoupons else { return false }
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CouponCell else { return }
        guard let couponInfo = cell.couponInfo else { return }
        let couponDetailViewController = CouponDetailViewController(coupon: couponInfo)
        couponDetailViewController.afterCouponRedemptionRelay
            .filter({ $0 == true })
            .subscribe(onNext: { [weak self] isCouponSuccess in
                guard let self else { return }
                self.usedCouponDataSource = []
                self.availableCouponDataSource = []
                self.getCouponListsFromServer(isUsed: false, size: 14, cursor: 0)
                self.getCouponListsFromServer(isUsed: true, size: 14, cursor: 0)
            }).disposed(by: disposBag)
        if collectionView == rootView.collectionViewForUsedCoupons {
            couponDetailViewController.disableUseButton()
        }
        navigationController?.pushViewController(couponDetailViewController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView == rootView.collectionViewForUsedCoupons {
            guard usedCouponDataSource.count < usedCouponsCount else { return }
            guard indexPath == lastIndexPathForUsedCoupons else { return }
            let scrollLoadingCollectionView = collectionView as! ScrollLoadingCollectionView
            scrollLoadingCollectionView.startScrollLoading(direction: .bottom)
            getCouponListsFromServer(isUsed: true, size: 14, cursor: lastCursorIDForUsedCoupons)
        } else if collectionView == rootView.collectionViewForAvailableCoupons {
            guard availableCouponDataSource.count < availableCouponsCount else { return }
            guard indexPath == lastIndexPathForAvailableCoupons else { return }
            let scrollLoadingCollectionView = collectionView as! ScrollLoadingCollectionView
            scrollLoadingCollectionView.startScrollLoading(direction: .bottom)
            getCouponListsFromServer(isUsed: false, size: 14, cursor: lastCursorIDForAvailableCoupons)
            
        }
    }
    
}

//MARK: - ORBSegmentedControlDelegate

extension CouponListViewController: ORBSegmentedControlDelegate {
    
    func segmentedControlDidSelect(segmentedControl: ORBSegmentedControl, selectedIndex: Int) {
        setPageViewControllerPage(to: selectedIndex)
    }
    
}

//MARK: - UIPageViewControllerDataSource

extension CouponListViewController: UIPageViewControllerDataSource {
    
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

extension CouponListViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        guard pageViewController.viewControllers?.first != nil else { return }
        rootView.segmentedControl.isUserInteractionEnabled = false
    }
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool
    ) {
        guard pageViewController.viewControllers?.first != nil else { return }
        rootView.segmentedControl.isUserInteractionEnabled = true
        if let index = viewControllerList.firstIndex(of: pageViewController.viewControllers!.first!) {
            rootView.segmentedControl.selectSegment(index: index)
        }
    }
    
}
