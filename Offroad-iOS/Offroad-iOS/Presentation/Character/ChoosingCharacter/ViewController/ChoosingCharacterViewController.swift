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
    
    private var characterInfoModelList: [CharacterList]? {
        didSet {
            choosingCharacterView.setPageControlPageNumbers(pageNumber: characterInfoModelList?.count ?? 0)
        }
    }
    
    private var extendedCharacterImageList = [String]() {
        didSet {
            choosingCharacterView.collectionView.reloadData()
            if extendedCharacterImageList.count > 2 {
                choosingCharacterView.collectionView.scrollToItem(at: IndexPath(item: 1, section: 0), at: .centeredHorizontally, animated: false)
            }
        }
    }
    
    private var characterNames = [String]()
    private var characterDiscriptions = [String]()
    private var selectedIndex = Int()
    
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
        
        getCharacterInfo()
    }
    
    //MARK: - Private Method
    
    private func setupCollectionView() {
        choosingCharacterView.collectionView.delegate = self
        choosingCharacterView.collectionView.dataSource = self
        choosingCharacterView.collectionView.register(ChoosingCharacterCell.self, forCellWithReuseIdentifier: ChoosingCharacterCell.identifier)
        
        choosingCharacterView.leftButton.addTarget(self, action: #selector(leftArrowTapped), for: .touchUpInside)
        choosingCharacterView.rightButton.addTarget(self, action: #selector(rightArrowTapped), for: .touchUpInside)
    }
    
    private func getCharacterInfo() {
        NetworkService.shared.characterService.getCharacterInfo { response in
            switch response {
            case .success(let data):
                let count = data?.data.characters.count ?? 0
                
                self.characterInfoModelList = data?.data.characters
                
                self.extendedCharacterImageList.insert(data?.data.characters[count - 1].characterBaseImageUrl ?? "", at: 0)
                for character in data?.data.characters ?? [CharacterList]() {
                    self.extendedCharacterImageList.append(character.characterBaseImageUrl)
                    self.characterNames.append(character.name)
                    self.characterDiscriptions.append(character.description)
                }
                self.extendedCharacterImageList.append(data?.data.characters[0].characterBaseImageUrl ?? "")
                
                print(self.extendedCharacterImageList)
            default:
                break
            }
        }
    }
    
    //MARK: - @objc Method
    
    @objc private func leftArrowTapped() {
        choosingCharacterView.leftButton.isUserInteractionEnabled = false
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
        choosingCharacterView.rightButton.isUserInteractionEnabled = false
        let currentIndexPath = choosingCharacterView.collectionView.indexPathsForVisibleItems.first
        guard let indexPath = currentIndexPath else { return }
        
        let nextIndex = indexPath.item + 1
        //마지막 항목일 때
        if nextIndex == extendedCharacterImageList.count - 1 {
            choosingCharacterView.collectionView.scrollToItem(at: IndexPath(item: extendedCharacterImageList.count - 1, section: 0), at: .centeredHorizontally, animated: true)
        } else {
            choosingCharacterView.collectionView.scrollToItem(at: IndexPath(item: nextIndex, section: 0), at: .centeredHorizontally, animated: true)
        }
    }
}

extension ChoosingCharacterViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    //MARK: - Infinite carousel Method
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return extendedCharacterImageList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChoosingCharacterCell.identifier, for: indexPath) as! ChoosingCharacterCell
        cell.configureCell(imageURL: extendedCharacterImageList[indexPath.item])
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = Int(scrollView.contentOffset.x / view.frame.width)
        
        if let characterInfoModelList {
            choosingCharacterView.pageControl.currentPage = (pageIndex - 1 + characterInfoModelList.count) % characterInfoModelList.count
        }
        selectedIndex = choosingCharacterView.pageControl.currentPage
        choosingCharacterView.nameLabel.text = characterNames[choosingCharacterView.pageControl.currentPage]
        choosingCharacterView.discriptionLabel.text = characterDiscriptions[choosingCharacterView.pageControl.currentPage]
        choosingCharacterView.discriptionLabel.setLineSpacing(spacing: 4.0)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        choosingCharacterView.leftButton.isUserInteractionEnabled = true
        choosingCharacterView.rightButton.isUserInteractionEnabled = true
        let pageWidth = scrollView.frame.width
        let currentPage = Int(scrollView.contentOffset.x / pageWidth)
        
        if scrollView == choosingCharacterView.collectionView {
            if currentPage == 0 {
                self.choosingCharacterView.collectionView.scrollToItem(at: IndexPath(item: 3, section: 0), at: .centeredHorizontally, animated: false)
            } else if currentPage == extendedCharacterImageList.count - 1 {
                choosingCharacterView.collectionView.scrollToItem(at: IndexPath(item: 1, section: 0), at: .centeredHorizontally, animated: false)
            }
        }
    }
    
}
