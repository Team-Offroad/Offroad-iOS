//
//  DeleteAccountResponseDTO.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 9/5/24.
//

import Foundation

struct DeleteAccountResponseDTO: Codable {
    let message: String
    var data: Data? = nil
}
