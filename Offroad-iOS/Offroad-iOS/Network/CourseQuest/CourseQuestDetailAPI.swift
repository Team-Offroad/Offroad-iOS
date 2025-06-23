//
//  CourseQuestDetailAPI.swift
//  Offroad-iOS
//
//  Created by  정지원 on 6/24/25.
//

import Foundation

import Moya

enum CourseQuestDetailAPI {
    case getCourseQuestDetail(questId: Int)
}

extension CourseQuestDetailAPI: BaseTargetType {

    var headerType: HeaderType {
        return .accessTokenHeaderForGet
    }

    var path: String {
        switch self {
        case .getCourseQuestDetail(let questId):
            return "/quests/course/\(questId)"
        }
    }

    var method: Moya.Method {
        return .get
    }

    var task: Moya.Task {
        return .requestPlain
    }
}
