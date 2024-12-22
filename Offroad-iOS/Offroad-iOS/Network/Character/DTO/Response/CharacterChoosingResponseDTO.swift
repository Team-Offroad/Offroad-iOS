//
//  CharacterChoosingResponseDTO.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 7/17/24.
//

import Foundation

struct CharacterChoosingResponseDTO: Codable {
    let message: String
    let data: CharacterImage
}

struct CharacterImage: Codable {
    let characterImageUrl: String?
}
