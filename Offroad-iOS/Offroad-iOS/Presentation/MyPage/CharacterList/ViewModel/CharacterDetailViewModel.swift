//
//  CharacterDetailViewModel.swift
//  Offroad-iOS
//
//  Created by 김민성 on 10/24/24.
//

import Foundation

import RxSwift
import RxCocoa

final class CharacterDetailViewModel {
    
    //MARK: - Properties
    
    private(set) var characterId: Int
    private(set) var representativeCharacterId: Int
    var isCurrentCharacterRepresentative: Bool {
        characterId == representativeCharacterId
    }
    
    private(set) var characterDetailInfo: CharacterDetailInfo?
    var characterMainColorCode: String? { characterDetailInfo?.characterMainColorCode }
    var characterSubColorCode: String? { characterDetailInfo?.characterSubColorCode }
    
    var characterMotionListDataSource: [CharacterMotionInfoData] = []
    
    //MARK: - Rx Properties
    
    var representativeCharacterChanged = PublishSubject<Void>()
    var characterDetailInfoSubject = PublishSubject<CharacterDetailInfo>()
    var characterMotionListDataSourceSubject = PublishSubject<[CharacterMotionInfoData]>()
    
    init(characterId: Int, representativeCharacterId: Int) {
        self.characterId = characterId
        self.representativeCharacterId = representativeCharacterId
        
    }
}

extension CharacterDetailViewModel {
    
    func postCharacterID() {
        NetworkService.shared.characterService.postChoosingCharacter(parameter: characterId) { [weak self] response in
            guard let self else { return }
            switch response {
            case .success:
                representativeCharacterId = characterId
                representativeCharacterChanged.onNext(())
            default:
                break
            }
        }
    }
    
    func getCharacterDetailInfo() {
        NetworkService.shared.characterDetailService.getAcquiredCharacterInfo(characterId: characterId) { [weak self] response in
            guard let self else { return }
            switch response {
            case .success(let characterDetailResponse):
                guard let characterDetailInfo = characterDetailResponse?.data else { return }
                self.characterDetailInfo = characterDetailInfo
                self.characterDetailInfoSubject.onNext(characterDetailInfo)
            default:
                break
            }
        }
    }
    
    func characterMotionInfo() {
        NetworkService.shared.characterMotionService.getCharacterMotionList(characterId: characterId) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let responseDTO):
                guard let responseDTO else { return }
                
                let gainedData = responseDTO.data.gainedCharacterMotions.map { CharacterMotionInfoData(motion: $0, isGained: true) }
                let notGainedData = responseDTO.data.notGainedCharacterMotions.map {
                    CharacterMotionInfoData(motion: $0, isGained: false)
                }
                characterMotionListDataSource = gainedData + notGainedData
                characterMotionListDataSourceSubject.onNext(characterMotionListDataSource)
            default:
                break
            }
        }
    }
    
}
