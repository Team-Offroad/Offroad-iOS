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
    let adventureService = AdventureService()
    let questService: QuestServiceProtocol = QuestService()
    let questListService = QuestListService()
    let courseQuestDetailService = CourseQuestDetailService()
    let emblemService: EmblemServiceProtocol = EmblemService()
    let characterService: CharacterServiceProtocol = CharacterService()
    let nicknameService: NicknameServiceProtocol = NicknameService()
    let profileService: ProfileServiceProtocol = ProfileService()
    let noticeService: NoticeServiceProtocol = NoticeService()
    let couponService: CouponServiceProtocol = CouponService()
    let placeService: RegisteredPlaceService = RegisteredPlaceService()
    let pushNotificationService: PushNotificationServiceProtocol = PushNotificationService()
    let characterChatService: CharacterChatService = CharacterChatService()
    let minimumSupportedVersionService = MinimumSupportedVersionService()
    let diarySettingService: DiarySettingServiceProtocol = DiarySettingService()
    let diaryService: DiaryServiceProtocol = DiaryService()
    let orbRecommendationService = ORBRecommendationService()
}
