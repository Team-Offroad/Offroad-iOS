//
//  ErrorResponseDTO.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 7/15/24.
//

import Foundation

struct ErrorResponseDTO: Codable {
    let message: String?
    let customErrorCode: String?
}
