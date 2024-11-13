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
    private var extendedListSize = 14
    private var lastCursorID = 0
    
    private var pageViewController: UIPageViewController {
        rootView.pageViewController
    }
    
    private var selectedState: SelectedState = .available {
        didSet {
            if selectedState.state {
                availableCouponList = []
            } else {
                usedCouponList = []
            }
            extendedListSize = 14
            getInitialCouponList(isUsed: selectedState.state)
            reloadCollectionViews()
        }
    }
    
    // MARK: - UI Properties
    
    private let rootView = AcquiredCouponView()
    
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
        rootView.segmentedControl.selectSegment(index: 0)
        setPageViewControllerPage(to: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let offroadTabBarController = self.tabBarController as? OffroadTabBarController else { return }
        offroadTabBarController.hideTabBarAnimation()

        getInitialCouponList(isUsed: false)
        getInitialCouponList(isUsed: true)
    }
}

extension AcquiredCouponViewController{
    
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
    
    private func getInitialCouponList(isUsed: Bool, cursor: Int = 0, size: Int = 14) {
        rootView.segmentedControl.isUserInteractionEnabled = false
        rootView.pageViewController.view.isUserInteractionEnabled = false
        NetworkService.shared.couponService.getAcquiredCouponList(isUsed: false, size: size, cursor: cursor) { [weak self] result in
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
                
                lastCursorID = response.data.coupons.last?.cursorId ?? Int()
                
                self.rootView.segmentedControl.isUserInteractionEnabled = true
                self.rootView.pageViewController.view.isUserInteractionEnabled = true
            default:
                return
            }
        }
    }
    
    private func getExtendedCouponList(isUsed: Bool, cursor: Int, size: Int) {
        rootView.segmentedControl.isUserInteractionEnabled = false
        rootView.pageViewController.view.isUserInteractionEnabled = false
        NetworkService.shared.couponService.getAcquiredCouponList(isUsed: false, size: size, cursor: cursor) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let response):
                guard let response else {
                    return
                }
                
                self.availableCouponsCount = response.data.availableCouponsCount
                self.usedCouponsCount = response.data.usedCouponsCount
                
                if isUsed {
                    self.usedCouponList?.append(contentsOf: response.data.coupons)
                } else {
                    self.availableCouponList?.append(contentsOf: response.data.coupons)
                }
                
                lastCursorID = response.data.coupons.last?.cursorId ?? Int()
                
                self.rootView.segmentedControl.isUserInteractionEnabled = true
                self.rootView.pageViewController.view.isUserInteractionEnabled = true
            default:
                return
            }
        }
    }
    
    private func reloadCollectionViews() {
        rootView.collectionViewForAvailableCoupons.reloadData()
        rootView.collectionViewForUsedCoupons.reloadData()
        rootView.segmentedControl.changeSegmentTitle(at: 0, to: "사용 가능 \(availableCouponsCount)")
        rootView.segmentedControl.changeSegmentTitle(at: 1, to: "사용 완료 \(usedCouponsCount)")
    }
    
    private func setPageViewControllerPage(to targetIndex: Int) {
        rootView.pageViewController.view.isUserInteractionEnabled = false
        guard let currentViewCotnroller = pageViewController.viewControllers?.first else {
            // viewDidLoad에서 호출될 때 (처음 한 번)
            pageViewController.setViewControllers([viewControllerList.first!], direction: .forward, animated: false)
            return
        }
        guard let currentIndex = viewControllerList.firstIndex(of: currentViewCotnroller) else { return }
        guard targetIndex >= 0 else { return }
        guard targetIndex < rootView.segmentedControl.titles.count,
              targetIndex < viewControllerList.count
        else { return }
        
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
    
}

//MARK: - UICollectionViewDataSource

extension AcquiredCouponViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == rootView.collectionViewForAvailableCoupons {
            if let availableCouponList {
                return availableCouponList.count
            }
        } else if collectionView == rootView.collectionViewForUsedCoupons {
            if let usedCouponList {
                return usedCouponList.count
            }
        } else {
            fatalError()
        }
        return Int()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CouponCell.className, for: indexPath) as? CouponCell else { fatalError() }
        
        if collectionView == rootView.collectionViewForAvailableCoupons {
            if let availableCouponList {
                cell.configureAvailableCell(with: availableCouponList[indexPath.item])
            }
        } else if collectionView == rootView.collectionViewForUsedCoupons {
            if let usedCouponList {
                cell.configureUsedCell(with: usedCouponList[indexPath.item])
            }
        }
        return cell
    }
    
}

//MARK: - UICollectionViewDelegate

extension AcquiredCouponViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == rootView.collectionViewForAvailableCoupons {
            guard collectionView.cellForItem(at: indexPath) is CouponCell else { return }
            if let availableCouponList {
                let couponDetailViewController = CouponDetailViewController(coupon: availableCouponList[indexPath.item])
                navigationController?.pushViewController(couponDetailViewController, animated: true)
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height
        
        if offsetY >= contentHeight - frameHeight {
            var dataCount = 0

            if scrollView == rootView.collectionViewForAvailableCoupons {
                dataCount = availableCouponList?.count ?? Int()
            } else if scrollView == rootView.collectionViewForUsedCoupons {
                dataCount = usedCouponList?.count ?? Int()
            }
            
            if extendedListSize == dataCount {
                extendedListSize += 14
                getExtendedCouponList(isUsed: selectedState.state, cursor: lastCursorID, size: 14)
                
                //TODO: 로딩 케이스 추가
            }
        }
        
    }
}

//MARK: - ORBSegmentedControlDelegate

extension AcquiredCouponViewController: ORBSegmentedControlDelegate {
    
    func segmentedControlDidSelect(segmentedControl: ORBSegmentedControl, selectedIndex: Int) {
        setPageViewControllerPage(to: selectedIndex)
        selectedState.toggle()
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
            rootView.segmentedControl.selectSegment(index: index)
            selectedState.toggle()
        }
    }
    
}
