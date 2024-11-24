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
    
    var representativeCharacterID: Int? = nil
    var completerQuestCount: Int? = nil
    var visitedPlacesCount: Int? = nil
    
    var characterInfo: [Int: String] = [:]
    
    var representativeCharacterName: String? {
        guard let representativeCharacterID else { return nil }
        return characterInfo[representativeCharacterID]
    }
    
    //MARK: - Rx Properties
    
    let didSuccessAdventure = PublishRelay<Void>()
    let didChangeRepresentativeCharacter = PublishRelay<Void>()
    let didChangeEmblem = PublishRelay<Void>()
    
    static let shared = MyInfoManager()
    
    //MARK: - Life Cycle
    
    private init() { }
    
}
