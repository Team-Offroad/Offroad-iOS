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
        
        DispatchQueue.main.async {
            self.choosingCharacterView.collectionView.scrollToItem(at: IndexPath(item: 1, section: 0), at: .centeredHorizontally, animated: false)
        }
    }
    
    //MARK: - Private Method
    
    private func setupCollectionView() {
        choosingCharacterView.collectionView.delegate = self
        choosingCharacterView.collectionView.dataSource = self
        choosingCharacterView.collectionView.register(ChoosingCharacterCell.self, forCellWithReuseIdentifier: ChoosingCharacterCell.identifier)
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
        choosingCharacterView.captionLabel.text = choosingCharacterView.captions[choosingCharacterView.pageControl.currentPage]
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.width
        let currentPage = Int(scrollView.contentOffset.x / pageWidth)
        
        if currentPage == 0 {
            choosingCharacterView.collectionView.scrollToItem(at: IndexPath(item: choosingCharacterView.images.count, section: 0), at: .centeredHorizontally, animated: false)
        } else if currentPage == choosingCharacterView.extendedImages.count - 1 {
            choosingCharacterView.collectionView.scrollToItem(at: IndexPath(item: 1, section: 0), at: .centeredHorizontally, animated: false)
        }
    }
}



