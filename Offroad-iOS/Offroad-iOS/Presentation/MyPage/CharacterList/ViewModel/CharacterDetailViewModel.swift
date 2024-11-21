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
    
    var disposeBag = DisposeBag()
    
    var representativeCharacterChanged = PublishSubject<Void>()
    var characterDetailInfoSubject = PublishSubject<CharacterDetailInfo?>()
    var characterMotionListDataSourceSubject = PublishSubject<[CharacterMotionInfoData]?>()
    
    var networkingSuccess = PublishSubject<Void>()
    var networkingFailure = PublishSubject<Void>()
    
    var selectButtonTapped = PublishRelay<Void>()
    var representativeCharacterSelected = PublishRelay<CharacterDetailInfo>()
    
    init(characterId: Int, representativeCharacterId: Int) {
        self.characterId = characterId
        self.representativeCharacterId = representativeCharacterId
        
        Observable.combineLatest(
            self.characterDetailInfoSubject,
            self.characterMotionListDataSourceSubject
        ).do(onNext: { [weak self] in
            guard let self else { return }
            /// 네트워크 종류를 구분하지 않아서, 로컬 네트워크(loopback 등)일 경우 문제 생길 수 있음.
            /// 일반적인 상황에서는 큰 문제 없을 것으로 예상
            let isNetworkConnected = NetworkMonitoringManager.shared.networkMonitor.currentPath.status == .satisfied
            if !isNetworkConnected && ((($0 == nil) || ($1 == nil))) {
                self.networkingFailure.onNext(())
            }
        }).filter({ $0 != nil && $1 != nil })
        .subscribe(onNext: { [weak self] _ in
            guard let self else { return }
            self.networkingSuccess.onNext(())
        }).disposed(by: disposeBag)
        
        selectButtonTapped
            .subscribe(onNext: { [weak self] in
                guard let self else { return }
                self.postCharacterID()
            })
            .disposed(by: disposeBag)
        
        Observable.combineLatest(
            characterDetailInfoSubject,
            representativeCharacterChanged
        )
        .filter({ $0.0 != nil })
        .map({ ($0.0!, $0.1) })
        .subscribe(onNext: { [weak self] in
            guard let self else { return }
            self.representativeCharacterSelected.accept($0.0)
        }).disposed(by: disposeBag)
    }
}

extension CharacterDetailViewModel {
    
    private func postCharacterID() {
        NetworkService.shared.characterService.postChoosingCharacter(parameter: characterId) { [weak self] response in
            guard let self else { return }
            switch response {
            case .success:
                representativeCharacterId = characterId
                MyInfoManager.shared.representativeCharacterID = characterId
                representativeCharacterChanged.onNext(())
            case .networkFail:
                self.networkingFailure.onNext(())
            default:
                break
            }
        }
    }
    
    func getCharacterDetailInfo() {
        NetworkService.shared.characterService.getCharacterDetail(characterId: characterId) { [weak self] response in
            guard let self else { return }
            switch response {
            case .success(let characterDetailResponse):
                guard let characterDetailInfo = characterDetailResponse?.data else { return }
                self.characterDetailInfo = characterDetailInfo
                self.characterDetailInfoSubject.onNext(characterDetailInfo)
            case .networkFail:
                self.characterDetailInfoSubject.onNext(nil)
            default:
                break
            }
        }
    }
    
    func characterMotionInfo() {
        NetworkService.shared.characterService.getCharacterMotionList(characterId: characterId) { [weak self] result in
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
            case .networkFail:
                characterMotionListDataSourceSubject.onNext(nil)
            default:
                break
            }
        }
    }
    
}
