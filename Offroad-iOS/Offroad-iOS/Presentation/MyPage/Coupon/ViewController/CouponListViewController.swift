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
        rootView.scrollView.delegate = self
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
                        self.rootView.collectionViewForUsedCoupons.reloadData()
                        self.rootView.collectionViewForUsedCoupons.emptyState = true
                    } else {
                        self.rootView.collectionViewForAvailableCoupons.reloadData()
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
                showToast(message: ErrorMessages.networkError, inset: 54)
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
        // NOTE: scrollView에서 setContentOffset(...animated: true) 를 사용할 경우 underbar 위치가 튀는 현상 발생
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1) { [weak self] in
            guard let self else { return }
            self.rootView.scrollView.contentOffset.x = self.rootView.scrollView.bounds.width * CGFloat(selectedIndex)
        }
        // 아이폰 미러링 시 popGesture(screenEdgeGesture)와 스크롤 뷰의 가로 스크롤 제스처가 동시에 적용되는 문제 방지
        navigationController?.interactivePopGestureRecognizer?.isEnabled = (selectedIndex == 0)
    }
    
}

//MARK: - UIScrollViewDelegate

extension CouponListViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let xOffset = scrollView.contentOffset.x
        let process = xOffset / scrollView.frame.width
        rootView.segmentedControl.setUnderbarPosition(process: process)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let process = scrollView.contentOffset.x / scrollView.frame.width
        let targetIndex: Int = Int(round(process))
        rootView.segmentedControl.selectSegment(index: targetIndex)
    }
    
}
