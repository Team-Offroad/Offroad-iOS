//
//  NetworkService.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 7/15/24.
//

import Foundation

final class NetworkService {
    
    static let shared = NetworkService()

    private init() {}
    
    let authService: AuthServiceProtocol = AuthService()
    let adventureService: AdventureServiceProtocol = AdventureService()
    let questService: QuestServiceProtocol = QuestService()
    let emblemService: EmblemServiceProtocol = EmblemService()
    let nicknameService: NicknameServiceProtocol = NicknameService()
    let profileService: ProfileServiceProtocol = ProfileService()
}
