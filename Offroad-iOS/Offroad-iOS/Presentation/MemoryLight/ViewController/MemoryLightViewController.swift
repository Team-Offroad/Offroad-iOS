//
//  MemoryLightViewController.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 3/17/25.
//

import UIKit

final class MemoryLightViewController: UIViewController {
    
    // MARK: - Properties
    
    private let rootView = MemoryLightView()
    private let viewModel = MemoryLightViewModel()
    
    private let firstDisplayedDate: Date
    
    // MARK: - Life Cycle
    
    init(firstDisplayedDate: Date) {
        self.firstDisplayedDate = firstDisplayedDate
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTarget()
        setupCollectionView()
        updateBackgoundView(dateIndex: viewModel.indexforDate(date: firstDisplayedDate))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let lastItemIndex = rootView.memoryLightCollectionView.numberOfItems(inSection: 0) - 1
        let lastIndexPath = IndexPath(item: lastItemIndex, section: 0)

        rootView.memoryLightCollectionView.scrollToItem(at: lastIndexPath, at: .centeredHorizontally, animated: false)
    }
}

private extension MemoryLightViewController {
    
    // MARK: - Private Method
    
    func setupTarget() {
        rootView.closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        rootView.shareButton.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
    }
    
    func setupCollectionView() {
        rootView.memoryLightCollectionView.delegate = self
        rootView.memoryLightCollectionView.dataSource = self
    }
    
    func updateBackgoundView(dateIndex: Int) {
        DispatchQueue.main.async {
            self.rootView.updateBackgroundViewUI(pointColorCode: self.viewModel.MemoryLightData[dateIndex].hexCodes[0].small,
                                                 baseColorCode: self.viewModel.MemoryLightData[dateIndex].hexCodes[0].large)
        }
    }
}
    
@objc private extension MemoryLightViewController {

    // MARK: - @objc Method
    
    func closeButtonTapped() {
        dismiss(animated: false)
    }
    
    func shareButtonTapped() {
        
    }
}

extension MemoryLightViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.MemoryLightData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MemoryLightCollectionViewCell.className, for: indexPath) as? MemoryLightCollectionViewCell else { return UICollectionViewCell() }
        DispatchQueue.main.async {
            cell.configureCell(data: self.viewModel.MemoryLightData[indexPath.item])
        }

        return cell
    }
}


extension MemoryLightViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: rootView.memoryLightCollectionView.bounds.width - 48, height: rootView.memoryLightCollectionView.bounds.height)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard let layout = rootView.memoryLightCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        
        let cellWidthIncludingSpacing = rootView.memoryLightCollectionView.bounds.width - 48 + layout.minimumLineSpacing
        var offset = targetContentOffset.pointee
        let currentIndex = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing
        
        let index: CGFloat
        if abs(velocity.x) > 0.3 {
            index = velocity.x > 0 ? ceil(currentIndex) : floor(currentIndex)
        } else {
            index = round(currentIndex)
        }
        
        updateBackgoundView(dateIndex: Int(index))

        offset = CGPoint(x: index * cellWidthIncludingSpacing - scrollView.contentInset.left, y: 0)
        targetContentOffset.pointee = offset
    }
}
