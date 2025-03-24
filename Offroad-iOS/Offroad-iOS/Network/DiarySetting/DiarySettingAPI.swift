//
//  DiarySettingAPI.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 3/21/25.
//

import Foundation

import Moya

enum DiarySettingAPI {
    case postDiarySettingDataRecord
    case getDiaryTutorialChecked
    case patchDiaryTutorialCheckStatus
    case patchDiaryCreateTime(hour: Int)
    case getDiaryCreateTimeAlertChecked
    case patchDiaryCreateTimeAlertCheckStatus
}

extension DiarySettingAPI: BaseTargetType {

    var headerType: HeaderType {
        switch self {
        case .getDiaryTutorialChecked, .getDiaryCreateTimeAlertChecked:
            return .accessTokenHeaderForGet
        default:
            return .accessTokenHeaderForGeneral
        }
    }
    
    var parameter: [String : Any]? {
        switch self {
        case .patchDiaryCreateTime(let hour):
            return ["hour": hour]
        default:
            return .none
        }
    }
    
    var path: String {
        switch self {
        case .postDiarySettingDataRecord:
            return "/diary/setting"
        case .getDiaryTutorialChecked, .patchDiaryTutorialCheckStatus:
            return "/diary/setting/tutorial-checked"
        case .patchDiaryCreateTime:
            return "/diary/setting/create-time"
        case .getDiaryCreateTimeAlertChecked, .patchDiaryCreateTimeAlertCheckStatus:
            return "/diary/setting/create-time-checked"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .postDiarySettingDataRecord:
            return .post
        case .getDiaryTutorialChecked, .getDiaryCreateTimeAlertChecked:
            return .get
        default:
            return .patch
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .patchDiaryCreateTime:
            return .requestParameters(parameters: parameter ?? [:], encoding: URLEncoding.queryString)
        default:
            return .requestPlain
        }
    }
}
