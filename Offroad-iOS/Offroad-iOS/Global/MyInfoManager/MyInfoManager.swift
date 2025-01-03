//
//  MyInfoManager.swift
//  Offroad-iOS
//
//  Created by 김민성 on 11/19/24.
//

import Foundation

import RxSwift
import RxRelay

final class MyInfoManager {
    
    //MARK: - Properties
    
    var disposeBag = DisposeBag()
    
    var representativeCharacterID: Int? = nil
    var completerQuestCount: Int? = nil
    var visitedPlacesCount: Int? = nil
    
    var characterInfo: [Int: String] = [:]
    
    var representativeCharacterName: String? {
        guard let representativeCharacterID else { return nil }
        guard let returnValue = characterInfo[representativeCharacterID] else { return nil }
        return returnValue
    }
    
    //MARK: - Rx Properties
    
    let didSuccessAdventure = PublishRelay<Void>()
    let didChangeRepresentativeCharacter = PublishRelay<Void>()
    let didChangeEmblem = PublishRelay<Void>()
    let shouldUpdateCharacterAnimation = PublishRelay<String>()
    let shouldUpdateUserInfoData = PublishRelay<Void>()
    
    static let shared = MyInfoManager()
    
    //MARK: - Life Cycle
    
    private init() { }
    
}

extension MyInfoManager {
    
    //MARK: - Func
    
    func updateCharacterListInfo() {
        NetworkService.shared.characterService.getCharacterListInfo { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let responseDTO):
                guard let responseDTO else { return }
                let gainedData = responseDTO.data.gainedCharacters.map({ CharacterListInfoData(info: $0, isGained: true) })
                let notGainedData = responseDTO.data.notGainedCharacters.map({ CharacterListInfoData(info: $0, isGained: false) })
                
                var characterListDataSource: [CharacterListInfoData] = []
                characterListDataSource = gainedData + notGainedData
                characterListDataSource.forEach { data in
                    self.characterInfo[data.characterId] = data.characterName
                }
                self.representativeCharacterID = responseDTO.data.representativeCharacterId
            case .networkFail:
                ORBToastManager.shared.showToast(message: ErrorMessages.getCharacterListFailure, inset: 66)
            default:
                break
            }
        }
    }
    
}
