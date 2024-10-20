//
//  ChoosingCharacterViewController.swift
//  Offroad-iOS
//
//  Created by  정지원 on 7/10/24.
//

import UIKit

import SnapKit
import SVGKit
import Then

final class ChoosingCharacterViewController: UIViewController {
    
    //MARK: - Properties
    
    private let choosingCharacterView = ChoosingCharacterView()
    
    private var characterInfoModelList: [ORBCharacter]? {
        didSet {
            choosingCharacterView.setPageControlPageNumbers(pageNumber: characterInfoModelList?.count ?? 0)
        }
    }
    
    private var extendedCharacterImageList = [UIImage]() {
        didSet {
            choosingCharacterView.collectionView.reloadData()
            if extendedCharacterImageList.count > 2 {
                choosingCharacterView.collectionView.scrollToItem(at: IndexPath(item: 1, section: 0), at: .centeredHorizontally, animated: false)
            }
        }
    }
    
    private var characterNames = [String]()
    private var characterDiscriptions = [String]()
    private var selectedCharacterName = String()
    private var selectedCharacterID = Int()
    
    //MARK: - Life Cycle
    
    override func loadView() {
        view = choosingCharacterView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTarget()
        setupCollectionView()
        
        let style = NSMutableParagraphStyle()
        
        if #available(iOS 14.0, *) {
            style.lineBreakStrategy = .hangulWordPriority
        }
        
        getCharacterInfo()
    }
    
    //MARK: - Private Method
    
    private func setupTarget() {
        choosingCharacterView.selectButton.addTarget(self, action: #selector(selectButtonTapped), for: .touchUpInside)
    }
    
    private func setupCollectionView() {
        choosingCharacterView.collectionView.delegate = self
        choosingCharacterView.collectionView.dataSource = self
        choosingCharacterView.collectionView.register(ChoosingCharacterCell.self, forCellWithReuseIdentifier: ChoosingCharacterCell.className)
        
        choosingCharacterView.leftButton.addTarget(self, action: #selector(leftArrowTapped), for: .touchUpInside)
        choosingCharacterView.rightButton.addTarget(self, action: #selector(rightArrowTapped), for: .touchUpInside)
    }
    
    private func getCharacterInfo() {
        NetworkService.shared.characterService.getCharacterInfo { response in
            switch response {
            case .success(let data):
                let count = data?.data.characters.count ?? 0
                let firstCharacterImageURL = data?.data.characters[0].characterBaseImageUrl ?? ""
                let lastCharacterImageURL = data?.data.characters[count - 1].characterBaseImageUrl ?? ""
                
                self.characterInfoModelList = data?.data.characters
                
                self.extendedCharacterImageList.insert(self.convertSvgURLToUIImage(svgUrlString: lastCharacterImageURL), at: 0)
                for character in data?.data.characters ?? [ORBCharacter]() {
                    let characterImageURL = character.characterBaseImageUrl
                    
                    self.extendedCharacterImageList.append(self.convertSvgURLToUIImage(svgUrlString: characterImageURL))
                    self.characterNames.append(character.name)
                    self.characterDiscriptions.append(character.description)
                }
                self.extendedCharacterImageList.append(self.convertSvgURLToUIImage(svgUrlString: firstCharacterImageURL))
                
            default:
                break
            }
        }
    }
    
    private func convertSvgURLToUIImage(svgUrlString: String) -> UIImage {
        guard let svgURL = URL(string: svgUrlString) else { return UIImage() }
        
        guard let svgImage = SVGKImage(contentsOf: svgURL) else { return UIImage() }
        
        return svgImage.renderedUIImage ?? UIImage()
    }
    
    private func postCharacterID(characterID: Int) {
        NetworkService.shared.characterService.postChoosingCharacter(parameter: characterID) { response in
            switch response {
            case .success(let data):
                
                let myCharacterImage = data?.data.characterImageUrl ?? ""
                
                let completeChoosingCharacterViewController = CompleteChoosingCharacterViewController(characterImage: myCharacterImage)
                completeChoosingCharacterViewController.modalTransitionStyle = .crossDissolve
                completeChoosingCharacterViewController.modalPresentationStyle = .fullScreen
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4){
                    self.present(completeChoosingCharacterViewController, animated: true)
                }
                
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
        choosingCharacterView.collectionView.scrollToItem(at: IndexPath(item: previousIndex, section: 0), at: .centeredHorizontally, animated: true)
    }
    
    @objc private func rightArrowTapped() {
        choosingCharacterView.rightButton.isUserInteractionEnabled = false
        let currentIndexPath = choosingCharacterView.collectionView.indexPathsForVisibleItems.first
        guard let indexPath = currentIndexPath else { return }
        
        let nextIndex = indexPath.item + 1
        choosingCharacterView.collectionView.scrollToItem(at: IndexPath(item: nextIndex, section: 0), at: .centeredHorizontally, animated: true)
    }
    
    @objc private func selectButtonTapped() {
//        let choosingCharacterPopupViewController = ChoosingCharacterPopupViewController(characterName: selectedCharacterName, characterID: selectedCharacterID)
//        choosingCharacterPopupViewController.modalPresentationStyle = .overCurrentContext
//        
//        present(choosingCharacterPopupViewController, animated: false)
        
        let alertController = OFRAlertController(title: "\(selectedCharacterName)와 함께하시겠어요?", message: "지금 캐릭터를 선택하시면 \(selectedCharacterName)과 모험을 시작하게 돼요.", type: .normal)
        let cancelAction = OFRAlertAction(title: "아니요", style: .cancel) { _ in return }
        let okAction = OFRAlertAction(title: "네,좋아요!", style: .default) { _ in
            self.postCharacterID(characterID: self.selectedCharacterID)
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
}

extension ChoosingCharacterViewController: UICollectionViewDataSource {
    
    //MARK: - Infinite carousel Method
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return extendedCharacterImageList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChoosingCharacterCell.className, for: indexPath) as! ChoosingCharacterCell
        cell.configureCell(imageData: extendedCharacterImageList[indexPath.item])
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = Int(scrollView.contentOffset.x / view.frame.width)
        
        if let characterInfoModelList {
            choosingCharacterView.pageControl.currentPage = (pageIndex - 1 + characterInfoModelList.count) % characterInfoModelList.count
        }
        selectedCharacterID = choosingCharacterView.pageControl.currentPage + 1
        choosingCharacterView.setBackgroundColorForID(id: selectedCharacterID)
        choosingCharacterView.nameLabel.text = characterNames[choosingCharacterView.pageControl.currentPage]
        selectedCharacterName = characterNames[choosingCharacterView.pageControl.currentPage]
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
                self.choosingCharacterView.collectionView.scrollToItem(at: IndexPath(item: extendedCharacterImageList.count - 2, section: 0), at: .centeredHorizontally, animated: false)
            } else if currentPage == extendedCharacterImageList.count - 1 {
                choosingCharacterView.collectionView.scrollToItem(at: IndexPath(item: 1, section: 0), at: .centeredHorizontally, animated: false)
            }
        }
    }
}

extension ChoosingCharacterViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: choosingCharacterView.collectionView.bounds.width, height: choosingCharacterView.collectionView.bounds.height)
    }
}
