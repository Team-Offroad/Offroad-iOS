//
//  MinimumSupportedVersionAPI.swift
//  Offroad-iOS
//
//  Created by 김민성 on 5/9/25.
//

import Foundation

import Moya


enum MinimumSupportedVersionAPI {
    case getMinimumSupportedVersion
}

extension MinimumSupportedVersionAPI: BaseTargetType {
    var headerType: HeaderType { .noneHeader }
    var path: String { "/app/min-supported-version" }
    var method: Moya.Method { .get }
    var task: Moya.Task { .requestPlain }
}
