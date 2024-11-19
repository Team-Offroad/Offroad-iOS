//
//  MyInfoManager.swift
//  Offroad-iOS
//
//  Created by 김민성 on 11/19/24.
//

import Foundation

final class MyInfoManager {
    
    var representativeCharacterID: Int? = nil
    var completerQuestCount: Int? = nil
    var visitedPlacesCount: Int? = nil
    
    var characterInfo: [Int: String] = [:]
    
    var representativeCharacterName: String? {
        guard let representativeCharacterID else { return nil }
        return characterInfo[representativeCharacterID]
    }
    
    
    static let shared = MyInfoManager()
    
    private init() { }
    
}
