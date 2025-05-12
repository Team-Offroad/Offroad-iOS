//
//  MinimumSupportedVersionResponseDTO.swift
//  Offroad-iOS
//
//  Created by 김민성 on 5/9/25.
//

import Foundation

struct MinimumSupportedVersionResponseDTO: Decodable {
    let ios: String
    // JSON에는 포함되나, android 최소 지원 버전 값은 사용하지 않음.
    let android: String
}
