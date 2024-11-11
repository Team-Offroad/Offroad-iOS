//
//  NoticeResponseDTO.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 9/23/24.
//

import Foundation

struct NoticeResponseDTO: Codable {
    let message: String
    let data: Notices
}

struct Notices: Codable {
    let announcements: [NoticeInfo]
}

struct NoticeInfo: Codable {
    let title: String
    let content: String
    let isImportant: Bool
    let updateAt: String
    let hasExternalLinks: Bool
    let externalLinks: [String]
    let externalLinksTitles: [String]
}
