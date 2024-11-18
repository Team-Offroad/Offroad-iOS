//
//  MyInfoManager.swift
//  Offroad-iOS
//
//  Created by 김민성 on 11/19/24.
//

import Foundation

final class MyInfoManager {
    
    var representativeCharacterName: String? = nil
    var representativeCharacterID: Int? = nil
    var completerQuestCount: Int? = nil
    var visitedPlacesCount: Int? = nil
    
    static let shared = MyInfoManager()
    
    private init() { }
    
    
    
}
