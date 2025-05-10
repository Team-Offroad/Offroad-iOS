//
//  MinimumSupportedVersionResponseDTO.swift
//  Offroad-iOS
//
//  Created by 김민성 on 5/9/25.
//

import Foundation

struct MinimumSupportedVersionResponseDTO: Decodable {
    let ios: String
    let android: String
}
