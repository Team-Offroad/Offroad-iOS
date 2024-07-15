//
//  ChoosingCharacterViewController.swift
//  Offroad-iOS
//
//  Created by  정지원 on 7/10/24.
//

import UIKit
import SnapKit
import Then

final class ChoosingCharacterViewController: UIViewController {
    
    //MARK: - Properties
    
    private let choosingCharacterView = ChoosingCharacterView()
    
    //MARK: - Life Cycle
    
    override func loadView() {
        view = choosingCharacterView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.sub(.sub)
        
        setupCollectionView()
        
        let style = NSMutableParagraphStyle()
        
        if #available(iOS 14.0, *) {
            style.lineBreakStrategy = .hangulWordPriority
        }
        
        DispatchQueue.main.async {
            self.choosingCharacterView.collectionView.scrollToItem(at: IndexPath(item: 1, section: 0), at: .centeredHorizontally, animated: false)
        }
    }
    
    //MARK: - Private Method
    
    private func setupCollectionView() {
        choosingCharacterView.collectionView.delegate = self
        choosingCharacterView.collectionView.dataSource = self
        choosingCharacterView.collectionView.register(ChoosingCharacterCell.self, forCellWithReuseIdentifier: ChoosingCharacterCell.identifier)
        
        choosingCharacterView.leftButton.addTarget(self, action: #selector(leftArrowTapped), for: .touchUpInside)
        choosingCharacterView.rightButton.addTarget(self, action: #selector(rightArrowTapped), for: .touchUpInside)
    }
    
    @objc private func leftArrowTapped() {
           let currentIndexPath = choosingCharacterView.collectionView.indexPathsForVisibleItems.first
           guard let indexPath = currentIndexPath else { return }
           
           let previousIndex = indexPath.item - 1
           if previousIndex == 0 {
               choosingCharacterView.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredHorizontally, animated: true)
           } else {
               choosingCharacterView.collectionView.scrollToItem(at: IndexPath(item: previousIndex, section: 0), at: .centeredHorizontally, animated: true)
           }
       }
       
       @objc private func rightArrowTapped() {
           let currentIndexPath = choosingCharacterView.collectionView.indexPathsForVisibleItems.first
           guard let indexPath = currentIndexPath else { return }
           
           let nextIndex = indexPath.item + 1
           //마지막 항목일 때
           if nextIndex == choosingCharacterView.extendedImages.count - 1 {
               choosingCharacterView.collectionView.scrollToItem(at: IndexPath(item: choosingCharacterView.extendedImages.count - 1, section: 0), at: .centeredHorizontally, animated: true)
           } else {
               choosingCharacterView.collectionView.scrollToItem(at: IndexPath(item: nextIndex, section: 0), at: .centeredHorizontally, animated: true)
           }
       }
   }

extension ChoosingCharacterViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return choosingCharacterView.extendedImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChoosingCharacterCell.identifier, for: indexPath) as! ChoosingCharacterCell
        cell.configure(imageName: choosingCharacterView.extendedImages[indexPath.item])
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = Int(scrollView.contentOffset.x / view.frame.width)
        choosingCharacterView.pageControl.currentPage = (pageIndex - 1 + choosingCharacterView.images.count) % choosingCharacterView.images.count
        choosingCharacterView.nameLabel.text = choosingCharacterView.names[choosingCharacterView.pageControl.currentPage]
        choosingCharacterView.discriptionLabel.text = choosingCharacterView.discriptions[choosingCharacterView.pageControl.currentPage]
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.width
        let currentPage = Int(scrollView.contentOffset.x / pageWidth)
        
        if scrollView == choosingCharacterView.collectionView {
            if currentPage == 0 {
                self.choosingCharacterView.collectionView.scrollToItem(at: IndexPath(item: 3, section: 0), at: .centeredHorizontally, animated: false)
            } else if currentPage == choosingCharacterView.extendedImages.count - 1 {
                choosingCharacterView.collectionView.scrollToItem(at: IndexPath(item: 1, section: 0), at: .centeredHorizontally, animated: false)
            }
        }
    }
}
