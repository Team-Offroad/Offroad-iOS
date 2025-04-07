//
//  DiaryAPI.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 3/24/25.
//

import Foundation

import Moya

enum DiaryAPI {
    case patchDiaryCheck(date: String)
    case getDiaryMonthlyHexCodes(year: Int, month: Int)
    case getLatestAndBeforeDiaries(previousCount: Int?)
    case getInitialDiaryDate
    case getLatestDiaryChecked
    case getDiariesByDate(date: String, previousCount: Int?, nextCount: Int?)
}

extension DiaryAPI: BaseTargetType {

    var headerType: HeaderType {
        switch self {
        case.patchDiaryCheck:
            return .accessTokenHeaderForGeneral
        default:
            return .accessTokenHeaderForGet
        }
    }
    
    var parameter: [String : Any]? {
        switch self {
        case .patchDiaryCheck(let date):
            return ["date": date]
        case .getDiaryMonthlyHexCodes(let year, let month):
            return ["year": year, "month": month]
        case .getLatestAndBeforeDiaries(let previousCount):
            if let previousCount {
                return ["previousCount": previousCount]
            } else {
                return .none
            }
        case .getDiariesByDate(let date, let previousCount, let nextCount):
            var paramters = ["date": date]
            if let previousCount {
                paramters["previousCount"] = String(previousCount)
            }
            if let nextCount {
                paramters["nextCount"] = String(nextCount)
            }
            return paramters
        default:
            return .none
        }
    }
    
    var path: String {
        switch self {
        case .patchDiaryCheck:
            return "/diary/check"
        case .getDiaryMonthlyHexCodes:
            return "/diary/monthly-hex"
        case .getLatestAndBeforeDiaries:
            return "/diary/latest"
        case .getInitialDiaryDate:
            return "/diary/first-date"
        case .getLatestDiaryChecked:
            return "/diary/check-latest"
        case .getDiariesByDate:
            return "/diary/by-date"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case.patchDiaryCheck:
            return .patch
        default:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getLatestDiaryChecked:
            return .requestPlain
        default:
            return .requestParameters(parameters: parameter ?? [:], encoding: URLEncoding.queryString)
        }
    }
}
