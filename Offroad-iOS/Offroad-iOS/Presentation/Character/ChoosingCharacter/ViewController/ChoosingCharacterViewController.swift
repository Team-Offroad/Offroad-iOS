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
    private var nickname: String = ""
    private var birthYear: Int?
    private var birthMonth: Int?
    private var birthDay: Int?
    private var gender: String?
    
    private var characterInfoModelList: [StartingCharacter]? {
        didSet {
            choosingCharacterView.setPageControlPageNumbers(pageNumber: characterInfoModelList?.count ?? 0)
        }
    }
    
    private var characterImageList: [Int:UIImage] = [:] {
        didSet {
            let imageCount = characterImageList.count
            
            if imageCount == characterInfoModelList?.count {
                DispatchQueue.main.async {
                    self.extendedCharacterImageList.append(self.characterImageList[imageCount] ?? UIImage())
                    for i in 1...imageCount {
                        self.extendedCharacterImageList.append(self.characterImageList[i] ?? UIImage())
                    }
                    self.extendedCharacterImageList.append(self.characterImageList[1] ?? UIImage())
                }
            }
        }
    }
    
    private var extendedCharacterImageList = [UIImage]() {
        didSet {
            if extendedCharacterImageList.count > 2 {
                choosingCharacterView.collectionView.reloadData()
                choosingCharacterView.collectionView.scrollToItem(at: IndexPath(item: 1, section: 0), at: .centeredHorizontally, animated: false)
            }
        }
    }
    
    private var characterNames = [String]()
    private var characterDiscriptions = [String]()
    private var selectedCharacterName = String()
    private var selectedCharacterID = Int()
    
    //MARK: - Life Cycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init(nickname: String, birthYear: Int?, birthMonth: Int?, birthDay: Int?, gender: String?) {
        self.init(nibName: nil, bundle: nil)
        
        self.nickname = nickname
        self.birthYear = birthYear
        self.birthMonth = birthMonth
        self.birthDay = birthDay
        self.gender = gender
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = choosingCharacterView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTarget()
        setupNavigationBar()
        setupCollectionView()
        
        let style = NSMutableParagraphStyle()
        
        if #available(iOS 14.0, *) {
            style.lineBreakStrategy = .hangulWordPriority
        }
        
        getStartingCharacterList()
    }
    
    //MARK: - Private Method
    
    private func setupNavigationBar() {
        let backButton = UIButton().then {
            $0.setImage(.backBarButton, for: .normal)
            $0.addTarget(self, action: #selector(executePop), for: .touchUpInside)
            $0.imageView?.contentMode = .scaleAspectFill
            $0.snp.makeConstraints { make in
                make.width.equalTo(30)
                make.height.equalTo(44)
            }
        }
        let customBackBarButton = UIBarButtonItem(customView: backButton)
        customBackBarButton.tintColor = .black
        navigationItem.leftBarButtonItem = customBackBarButton
    }
    
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
    
    private func convertSvgURLToUIImage(svgUrlString: String) -> UIImage {
        guard let svgURL = URL(string: svgUrlString) else { return UIImage() }
        
        guard let svgImage = SVGKImage(contentsOf: svgURL) else { return UIImage() }
        
        return svgImage.renderedUIImage ?? UIImage()
    }
    
    private func patchProfileData(characterID: Int) {
        ProfileService().patchUpdateProfile(body: ProfileUpdateRequestDTO(nickname: nickname, year: birthYear, month: birthMonth, day: birthDay, gender: gender, characterId: characterID)) { response in
            switch response {
            case .success(let data):
                print("프로필 업데이트 성공~~~~~~~~~")
                
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
    
    @objc private func executePop() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func leftArrowTapped() {
        choosingCharacterView.leftButton.isUserInteractionEnabled = false
        choosingCharacterView.rightButton.isUserInteractionEnabled = false
        let currentIndexPath = choosingCharacterView.collectionView.indexPathsForVisibleItems.first
        guard let indexPath = currentIndexPath else { return }
        
        let previousIndex = indexPath.item - 1
        choosingCharacterView.collectionView.scrollToItem(at: IndexPath(item: previousIndex, section: 0), at: .centeredHorizontally, animated: true)
    }
    
    @objc private func rightArrowTapped() {
        choosingCharacterView.leftButton.isUserInteractionEnabled = false
        choosingCharacterView.rightButton.isUserInteractionEnabled = false
        let currentIndexPath = choosingCharacterView.collectionView.indexPathsForVisibleItems.first
        guard let indexPath = currentIndexPath else { return }
        
        let nextIndex = indexPath.item + 1
        choosingCharacterView.collectionView.scrollToItem(at: IndexPath(item: nextIndex, section: 0), at: .centeredHorizontally, animated: true)
    }
    
    @objc private func selectButtonTapped() {
        let alertController = ORBAlertController(title: "\(selectedCharacterName)와 함께하시겠어요?", message: "지금 캐릭터를 선택하시면\n\(selectedCharacterName)와 모험을 시작하게 돼요.", type: .normal)
        alertController.configureMessageLabel{ label in
            label.setLineHeight(percentage: 150)
            label.highlightText(targetText: selectedCharacterName, font: .offroad(style: .iosTextBold))
        }
        alertController.xButton.isHidden = true
        let cancelAction = ORBAlertAction(title: "아니요", style: .cancel) { _ in return }
        let okAction = ORBAlertAction(title: "네,좋아요!", style: .default) { _ in
            self.patchProfileData(characterID: self.selectedCharacterID)
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
}

extension ChoosingCharacterViewController: SVGFetchable {
    private func getStartingCharacterList() {
        NetworkService.shared.characterService.getStartingCharacterList { response in
            switch response {
            case .success(let data):
                self.characterInfoModelList = data?.data.characters
                
                for character in data?.data.characters ?? [StartingCharacter]() {
                    self.characterNames.append(character.name)
                    self.characterDiscriptions.append(character.description)
                    
                    self.fetchSVG(svgURLString: character.characterBaseImageUrl) { image in
                        self.characterImageList[character.id] = image ?? UIImage()
                    }
                }
            default:
                break
            }
        }
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
