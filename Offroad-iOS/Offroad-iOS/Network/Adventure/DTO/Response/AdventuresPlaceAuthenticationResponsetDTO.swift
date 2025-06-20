//
//  AdventuresPlaceAuthenticationResponseDTO.swift
//  Offroad-iOS
//
//  Created by 김민성 on 2024/07/18.
//

import UIKit

struct AdventuresPlaceAuthenticationResponseDTO: Codable {
    let message: String
    let data: AdventuresPlaceAuthenticationResultData
}

struct AdventuresPlaceAuthenticationResultData: Codable {
    let isValidPosition: Bool
    let successCharacterImageUrl: String
    let completeQuestList: [CompleteQuest]?
    let isFirstVisitToday: Bool
}

struct CompleteQuest: Codable {
    let name: String
}

extension AdventuresPlaceAuthenticationResultData: SVGFetchable {
    
    /// `AdventuresPlaceAuthenticationResultData` 타입을 `AdventureModel` 타입으로 변환
    /// - Parameter place: 탐험을 시도한 장소
    /// - Returns: 변환된 `AdventureModel` 인스턴스
    func asAdventureResult(at place: some PlaceDescribable) async throws -> AdventureResult {
        let resultImage = try await fetchSVG(svgURLString: self.successCharacterImageUrl)
        let adventureResult: AdventureResult = .init(
            place: place,
            isValidPosition: self.isValidPosition,
            isFirstVisitToday: self.isFirstVisitToday,
            completedQuests: completeQuestList,
            resultImage: resultImage
        )
        return adventureResult
    }
    
}
