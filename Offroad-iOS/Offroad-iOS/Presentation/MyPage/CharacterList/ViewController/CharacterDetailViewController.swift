//
//  CharacterDetailViewController.swift
//  Offroad-iOS
//
//  Created by  정지원 on 8/13/24.
//

import UIKit

final class CharacterDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    private let characterId: Int
    
    private let characterDetailView = CharacterDetailView()
    
    private var characterMainColorCode: String?
    private var characterSubColorCode: String?
    
    private var combinedCharacterMotionList: [(isGained: Bool, character: Any)] = [] {
        didSet {
            DispatchQueue.main.async {
                self.characterDetailView.collectionView.reloadData()
            }
        }
    }
    private var gainedCharacterMotionList: [CharacterMotionList]?
    private var notGainedCharacterMotionList: [CharacterMotionList]?
    
    // MARK: - Life Cycle
    
    init(characterId: Int) {
        self.characterId = characterId
        
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
        
        setupTarget()
        setupDelegate()
        characterMotionInfo()
        getCharacterDetailInfo()
    }
    
    // MARK: - Private Func
    
    private func setupTarget() {
        characterDetailView.customBackButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    private func setupDelegate() {
        characterDetailView.collectionView.delegate = self
        characterDetailView.collectionView.dataSource = self
    }
    
    func getCharacterDetailInfo() {
        NetworkService.shared.characterDetailService.getAcquiredCharacterInfo(characterId: characterId) { response in
            switch response {
            case .success(let characterDetailResponse):
                guard let characterData = characterDetailResponse?.data else { return }
                
                self.characterMainColorCode = characterData.characterMainColorCode
                self.characterSubColorCode = characterData.characterSubColorCode
                self.view.backgroundColor = UIColor(hex: characterData.characterSubColorCode)
                self.characterDetailView.characterImage.fetchSvgURLToImageView(svgUrlString: characterData.characterBaseImageUrl)
                self.characterDetailView.characterLogoImage.fetchSvgURLToImageView(svgUrlString: characterData.characterIconImageUrl)
                self.characterDetailView.nameLabel.text = characterData.characterName
                self.characterDetailView.titleLabel.text = characterData.characterSummaryDescription
                self.characterDetailView.detailLabel.text = characterData.characterDescription
                self.characterDetailView.detailLabel.setLineSpacing(spacing: 5)
                
                DispatchQueue.main.async {
                    self.characterDetailView.collectionView.reloadData()
                }
            default:
                break
            }
        }
    }
    
    func characterMotionInfo() {
        NetworkService.shared.characterMotionService.getCharacterMotionList(characterId: characterId) { response in
            switch response {
            case .success(let data):
                guard let motionData = data?.data else { return }
                print("Character Motion: \(motionData)")
                self.gainedCharacterMotionList = data?.data.gainedCharacterMotions
                self.notGainedCharacterMotionList = data?.data.notGainedCharacterMotions
                
                self.combinedCharacterMotionList = []
                self.gainedCharacterMotionList?.forEach { gainedCharacterMotion in
                    self.combinedCharacterMotionList.append((isGained: true, character: gainedCharacterMotion))
                }
                self.notGainedCharacterMotionList?.forEach { notGainedCharacterMotion in
                    self.combinedCharacterMotionList.append((isGained: false, character: notGainedCharacterMotion))
                }
                
                DispatchQueue.main.async {
                    self.characterDetailView.collectionView.reloadData()
                }
            default:
                break
            }
        }
    }
    
    // MARK: - @Objc Func
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

extension CharacterDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: - CollectionView Func
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return combinedCharacterMotionList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterDetailCell.className, for: indexPath) as? CharacterDetailCell else {
            fatalError("Could not dequeue CharacterDetailCell")
        }
        
        let characterMotionData = combinedCharacterMotionList[indexPath.item]
        
        if characterMotionData.isGained, let gainedCharacterMotion = characterMotionData.character as? CharacterMotionList {
            cell.configureMotionCell(data: gainedCharacterMotion, isGained: true)
        } else if let notGainedCharacterMotion = characterMotionData.character as? CharacterMotionList {
            cell.configureMotionCell(data: notGainedCharacterMotion, isGained: false)
        }
        
        if let mainColor = self.characterMainColorCode, let subColor = self.characterSubColorCode {
            cell.configureCellColor(mainColor: mainColor, subColor: subColor)
        }
        
        DispatchQueue.main.async {
            self.characterDetailView.updateCollectionViewHeight()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Cell \(indexPath.item) selected")
    }
}
