//
//  CharacterListViewModel.swift
//  Offroad-iOS
//
//  Created by 김민성 on 10/24/24.
//

import Foundation

import RxSwift
import RxCocoa

final class CharacterListViewModel {
    
    //MARK: - Properties
    
    var representativeCharacterId: Int?
    var characterListDataSource: [CharacterListInfoData] = []
    
    //MARK: - Rx Properties
    
    var disposeBag = DisposeBag()
    var representativeCharacterIdSubject = PublishSubject<Int>()
    var characterListDataSourceSubject = PublishSubject<[CharacterListInfoData]>()
    var reloadCollectionView = PublishRelay<Void>()
    var networkingFailure = PublishSubject<Void>()
    
    init() {
        Observable.zip(
            representativeCharacterIdSubject,
            characterListDataSourceSubject
        ).subscribe(onNext: { [weak self] _ in
            guard let self else { return }
            self.reloadCollectionView.accept(())
        }).disposed(by: disposeBag)
    }
}

extension CharacterListViewModel {
    
    func getCharacterListInfo() {
        NetworkService.shared.characterService.getCharacterListInfo { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let responseDTO):
                guard let responseDTO else { return }
                let gainedData = responseDTO.data.gainedCharacters.map({ CharacterListInfoData(info: $0, isGained: true) })
                let notGainedData = responseDTO.data.notGainedCharacters.map({ CharacterListInfoData(info: $0, isGained: false) })
                self.representativeCharacterId = responseDTO.data.representativeCharacterId
                self.representativeCharacterIdSubject.onNext(responseDTO.data.representativeCharacterId)
                
                self.characterListDataSource = gainedData + notGainedData
                self.characterListDataSource.forEach { data in
                    MyInfoManager.shared.characterInfo[data.characterId] = data.characterName
                }
                MyInfoManager.shared.representativeCharacterID = responseDTO.data.representativeCharacterId
                self.characterListDataSourceSubject.onNext(self.characterListDataSource)
            case .networkFail:
                networkingFailure.onNext(())
            default:
                break
            }
        }
    }
    
}
