//
//  ProfileUpdateResponseDTO.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 7/15/24.
//

import Foundation

struct ProfileUpdateResponseDTO: Codable {
    let message: String
    var data: Data? = nil
}
