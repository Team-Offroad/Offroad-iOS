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
    private let representativeCharacterId: Int
    private let rootView = CharacterDetailView()
    
    private var characterMainColorCode: String?
    private var characterSubColorCode: String?
    
    private var combinedCharacterMotionList: [(isGained: Bool, character: Any)] = []
    
    weak var delegate: SelectMainCharacterDelegate?
    
    // MARK: - Life Cycle
    
    init(characterId: Int, representativeCharacterId: Int) {
        self.characterId = characterId
        self.representativeCharacterId = representativeCharacterId
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if characterId == representativeCharacterId {
            rootView.selectButton.isEnabled = false
            rootView.crownBadgeImageView.isHidden = false
//            rootView.selectButton.setTitle("이미 선택된 캐릭터예요", for: .normal)
//            rootView.selectButton.backgroundColor = UIColor.blackOpacity(.black25)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTarget()
        setupDelegate()
        characterMotionInfo()
        getCharacterDetailInfo()
    }
    
}

extension CharacterDetailViewController {
    
    // MARK: - Private Func
    
    private func setupTarget() {
        rootView.customBackButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        rootView.selectButton.addTarget(self, action: #selector(selectButtonTapped), for: .touchUpInside)
    }
    
    private func setupDelegate() {
        rootView.collectionView.delegate = self
        rootView.collectionView.dataSource = self
    }
    
    private func getCharacterDetailInfo() {
        NetworkService.shared.characterDetailService.getAcquiredCharacterInfo(characterId: characterId) { response in
            switch response {
            case .success(let characterDetailResponse):
                guard let characterDetailInfo = characterDetailResponse?.data else { return }
                
                self.characterMainColorCode = characterDetailInfo.characterMainColorCode
                self.characterSubColorCode = characterDetailInfo.characterSubColorCode
                self.view.backgroundColor = UIColor(hex: characterDetailInfo.characterSubColorCode)
                self.rootView.characterImage.fetchSvgURLToImageView(svgUrlString: characterDetailInfo.characterBaseImageUrl)
                self.rootView.characterLogoImage.fetchSvgURLToImageView(svgUrlString: characterDetailInfo.characterIconImageUrl)
                self.rootView.nameLabel.text = characterDetailInfo.characterName
                self.rootView.titleLabel.text = characterDetailInfo.characterSummaryDescription
                self.rootView.detailLabel.text = characterDetailInfo.characterDescription
                self.rootView.detailLabel.setLineSpacing(spacing: 5)
                self.rootView.mainCharacterToastMessageView.setMessage(characterName: characterDetailInfo.characterName)
                
            default:
                break
            }
        }
    }
    
    private func characterMotionInfo() {
        NetworkService.shared.characterMotionService.getCharacterMotionList(characterId: characterId) { [weak self] response in
            guard let self else { return }
            switch response {
            case .success(let result):
                guard let result else { return }
                self.combinedCharacterMotionList.append(
                    contentsOf: result.data.gainedCharacterMotions.map { (isGained: true, character: $0) }
                )
                self.combinedCharacterMotionList.append(
                    contentsOf: result.data.notGainedCharacterMotions.map { (isGained: false, character: $0) }
                )
                self.rootView.collectionView.reloadData()
                
            default:
                break
            }
        }
    }
    
    private func postCharacterID() {
        NetworkService.shared.characterService.postChoosingCharacter(parameter: characterId) { [weak self] response in
            guard let self else { return }
            switch response {
            case .success(let response):
                print("=======대표 캐릭터 설정: " + "\(response?.data.characterImageUrl)========")
                self.rootView.crownBadgeImageView.isHidden = false
                self.rootView.selectButton.isEnabled = false
                self.rootView.showToastMessage()
                self.delegate?.didSelectMainCharacter(characterId: self.characterId)
            default:
                break
            }
        }
    }
    
    // MARK: - @objc Func
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func selectButtonTapped() {
        // 토스트 메세지가 떠 있는 동안엔 버튼 비활성화
//        rootView.selectButton.isEnabled = false
//        rootView.showToastMessage { [weak self] in
//            self?.rootView.selectButton.setTitle("이미 선택된 캐릭터예요", for: .normal)
//            self?.rootView.selectButton.backgroundColor = UIColor.blackOpacity(.black25)
//            self?.rootView.crownBadgeImageView.isHidden = false
//        }
        postCharacterID()
        //CharacterListViewController에 대표 캐릭터 Id 전달
//        delegate?.didSelectMainCharacter(characterId: characterId)
    }
}

//MARK: - UICollectionViewDataSource

extension CharacterDetailViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return combinedCharacterMotionList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterDetailCell.className, for: indexPath) as? CharacterDetailCell else {
            fatalError("Could not dequeue CharacterDetailCell")
        }
        
        let characterMotionData = combinedCharacterMotionList[indexPath.item]
        
        if characterMotionData.isGained, let gainedCharacterMotion = characterMotionData.character as? ORBCharacterMotion {
            cell.configureMotionCell(data: gainedCharacterMotion, isGained: true)
        } else if let notGainedCharacterMotion = characterMotionData.character as? ORBCharacterMotion {
            cell.configureMotionCell(data: notGainedCharacterMotion, isGained: false)
        }
        
        if let mainColor = self.characterMainColorCode, let subColor = self.characterSubColorCode {
            cell.configureCellColor(mainColor: mainColor, subColor: subColor)
        }
        
        DispatchQueue.main.async {
            self.rootView.updateCollectionViewHeight()
        }
        
        return cell
    }
    
}

//MARK: - UICollectionViewDelegate

extension CharacterDetailViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Cell \(indexPath.item) selected")
    }
    
}
