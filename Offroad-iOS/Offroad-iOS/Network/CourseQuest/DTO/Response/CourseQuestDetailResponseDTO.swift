//
//  CourseQuestDetailResponseDTO.swift
//  Offroad-iOS
//
//  Created by  정지원 on 6/24/25.
//
import Foundation

struct CourseQuestDetailResponseDTO: Codable {
    let message: String
    let data: CourseQuestDetailDataDTO
}

struct CourseQuestDetailDataDTO: Codable {
    let places: [CourseQuestDetailPlaceDTO]
}

struct CourseQuestDetailPlaceDTO: Codable {
    let category: String
    let name: String
    let address: String
    let latitude: Double
    let longitude: Double
    let isVisited: Bool?
    let categoryImage: String
    let description: String
}
