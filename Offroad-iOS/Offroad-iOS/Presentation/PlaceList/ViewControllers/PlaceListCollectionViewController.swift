//
//  PlaceListCollectionViewController.swift
//  Offroad-iOS
//
//  Created by 김민성 on 9/29/24.
//

import CoreLocation
import UIKit

import RxSwift
import RxCocoa

///  장소 목록 뷰의 PageViewController에 보여질 view controller
class PlaceListCollectionViewController: UICollectionViewController {
    
    //MARK: - Properties
    
    /// 마지막 cell이 화면에 보여질 때 이벤트를 방출하는 `Observable` 스트림.
    var lastCellWillBeDisplayed: Observable<Void> { return lastCellWillShowRelay.asObservable() }
    var placeListCollectionView: PlaceListCollectionView { collectionView as! PlaceListCollectionView }
    
    //MARK: - Private Properties
    
    private let lastCellWillShowRelay: PublishRelay<Void> = .init()
    private let cellSelectionOperationQueue = OperationQueue()
    
    private var source: [RegisteredPlaceInfo] = []
    private var referenceCoordinate: CLLocationCoordinate2D
    private var showsVisitCount: Bool
    
    //MARK: - Life Cycle
    
    init(place: CLLocationCoordinate2D, showVisitCount: Bool) {
        self.referenceCoordinate = place
        self.showsVisitCount = showVisitCount
        super.init(nibName: nil, bundle: nil)
        
        collectionView = PlaceListCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension PlaceListCollectionViewController {
    
    /// collection view의 목록 마지막에 새 아이템들을 추가.
    /// - Parameter newPlaces: 추가될 장소 목록
    ///
    /// 주의!) 반드시 메인쓰레드에서만 호출할 것
    func appendNewItems(newPlaces: [RegisteredPlaceInfo]) {
        guard !newPlaces.isEmpty else { return }
        
        let newIndexPaths: [IndexPath] = (0..<newPlaces.count).map { [weak self] in
            guard let self else { return [] }
            return IndexPath(item: self.source.count + $0, section: 0)
        }
        source.append(contentsOf: newPlaces)
        /*
         iOS 17 버전의 시뮬레이터에서 collectionView에 insertItems를 사용하니 Invalid Batch Updates 에러가 발생하여,
         iOS 17까지의 버전에서는 혹시 모를 에러를 막기 위해 reloadData() 사용.
         */
        if #available(iOS 18, *) {
            collectionView.insertItems(at: newIndexPaths)
        } else {
            collectionView.reloadData()
        }
    }
    
}

//MARK: - UICollectionViewDataSource

extension PlaceListCollectionViewController {
    
    public override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return source.count
    }
    
    public override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PlaceCollectionViewCell.className,
            for: indexPath
        ) as? PlaceCollectionViewCell else { fatalError("cannot dequeue cell") }
        cell.configureCell(with: source[indexPath.item], showingVisitingCount: showsVisitCount)
        return cell
    }
    
}

extension PlaceListCollectionViewController {
    
    public override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let animator = UIViewPropertyAnimator(duration: 0.3, dampingRatio: 1)
        animator.addAnimations {
            if collectionView.indexPathsForSelectedItems?.contains(indexPath) ?? false {
                collectionView.deselectItem(at: indexPath, animated: false)
            } else {
                collectionView.selectItem(at: indexPath, animated: false, scrollPosition: UICollectionView.ScrollPosition())
            }
            collectionView.performBatchUpdates(nil)
        }
        
        let animationOperation = BlockOperation {
            DispatchQueue.main.async { animator.startAnimation() }
        }
        
        cellSelectionOperationQueue.addOperation(animationOperation)
        return false
    }
    
    public override func collectionView(
        _ collectionView: UICollectionView,
        willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        let isLastCell: Bool = (indexPath.section == 0) && (indexPath.item == source.count - 1)
        if isLastCell { lastCellWillShowRelay.accept(()) }
    }
    
}
