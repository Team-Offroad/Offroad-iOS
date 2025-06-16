//
//  AdventureResult.swift
//  Offroad-iOS
//
//  Created by 김민성 on 6/10/25.
//

import UIKit

/// 위치 기반 탐험 요청의 결과와 팝업에 띄울 이미지를 저장하는 타입.
/// 완료된 퀘스트가 있을 경우 완료된 퀘스트 정보를 포함.
struct AdventureResult {
    let place: PlaceModel
    let isValidPosition: Bool
    let isFirstVisitToday: Bool
    let completedQuests: [CompleteQuest]?
    let resultImage: UIImage
    
    var isAdventureSuccess: Bool { isValidPosition && isFirstVisitToday }
}
