//
//  CharacterDetailViewController.swift
//  Offroad-iOS
//
//  Created by  정지원 on 8/13/24.
//

import UIKit

class CharacterDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    private var imageName: String
    
    private let characterDetailView = CharacterDetailView()
    
    // MARK: - Life Cycle
    
    init(imageName: String) {
        self.imageName = imageName
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = characterDetailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegate()
        setupUIBasedOnImageName()
    }
    
    // MARK: - Private Func
    
    private func setupDelegate() {
        characterDetailView.collectionView.delegate = self
        characterDetailView.collectionView.dataSource = self
    }
    
    private func setupUIBasedOnImageName() {
        switch imageName {
        case "character_1":
            view.backgroundColor = UIColor.primary(.characterSelectBg3)
            characterDetailView.characterLogoImage.image = UIImage(resource: .character1Logo)
            characterDetailView.characterImage.image = UIImage(named: imageName)
            characterDetailView.nameLabel.text = "아루"
            characterDetailView.detailLabel.text = """
            재밌는 걸 보면 두 눈이 반짝!
            호기심이 많은 탐험가 아루예요.
            파우치에는 최소한의 탐험 키트가 들어있답니다.
            """
            characterDetailView.detailLabel.setLineSpacing(spacing: 5)
            
        case "character_2":
            view.backgroundColor = UIColor.primary(.characterSelectBg2)
            characterDetailView.characterLogoImage.image = UIImage(resource: .character2Logo)
            characterDetailView.characterImage.image = UIImage(named: imageName)
            characterDetailView.nameLabel.text = "오푸"
            characterDetailView.detailLabel.text = """
            세상을 모험하는 건 정말 즐거운 일이야!
            넘치는 열정을 가진 탐험가 오푸예요.
            안경을 쓰면 또 다른 세상이 펼쳐져요!
            """
            characterDetailView.detailLabel.setLineSpacing(spacing: 5)
            
        case "character_3":
            view.backgroundColor = UIColor.primary(.characterSelectBg1)
            characterDetailView.characterLogoImage.image = UIImage(resource: .character3Logo)
            characterDetailView.characterImage.image = UIImage(named: imageName)
            characterDetailView.nameLabel.text = "루미"
            characterDetailView.detailLabel.text = """
            재밌는 걸 보면 두 눈이 반짝!
            호기심이 많은 탐험가 루미예요.
            파우치에는 최소한의 탐험 키트가 들어있답니다.
            """
            characterDetailView.detailLabel.setLineSpacing(spacing: 5)
            
        default:
            view.backgroundColor = UIColor.gray
        }
    }
}

extension CharacterDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: - CollectionView Func
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CharacterDetailCell", for: indexPath) as! CharacterDetailCell
        let isNew = indexPath.item == 0
        cell.configure(imageName: imageName, isNew: isNew)
        
        // 높이 업데이트를 호출
        DispatchQueue.main.async {
            self.characterDetailView.updateCollectionViewHeight()
        }
        
        return cell
    }
}
