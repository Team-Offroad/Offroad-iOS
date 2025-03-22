//
//  DiarySettingService.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 3/21/25.
//

import Foundation

import Moya

protocol DiarySettingServiceProtocol {
    func postDiarySettingDataRecord(completion: @escaping (NetworkResult<Any>) -> ())
    func getDiaryTutorialChecked(completion: @escaping (NetworkResult<DiarySettingCheckedResponseDTO>) -> ())
    func patchDiaryTutorialCheckStatus(completion: @escaping (NetworkResult<Any>) -> ())
    func patchDiaryCreateTime(parameter: Int, completion: @escaping (NetworkResult<Any>) -> ())
    func getDiaryCreateTimeAlertChecked(completion: @escaping (NetworkResult<DiarySettingCheckedResponseDTO>) -> ())
    func patchDiaryCreateTimeAlertCheckStatus(completion: @escaping (NetworkResult<Any>) -> ())
}

final class DiarySettingService: BaseService, DiarySettingServiceProtocol {
    let provider = MoyaProvider<DiarySettingAPI>.init(session: Session(interceptor: TokenInterceptor.shared), plugins: [MoyaPlugin()])
    
    func postDiarySettingDataRecord(completion: @escaping (NetworkResult<Any>) -> ()) {
        request(.postDiarySettingDataRecord, completion: completion)
    }
    
    func getDiaryTutorialChecked(completion: @escaping (NetworkResult<DiarySettingCheckedResponseDTO>) -> ()) {
        request(.getDiaryTutorialChecked, completion: completion)
    }
    
    func patchDiaryTutorialCheckStatus(completion: @escaping (NetworkResult<Any>) -> ()) {
        request(.patchDiaryTutorialCheckStatus, completion: completion)
    }
    
    func patchDiaryCreateTime(parameter: Int, completion: @escaping (NetworkResult<Any>) -> ()) {
        request(.patchDiaryCreateTime(hour: parameter), completion: completion)
    }
    
    func getDiaryCreateTimeAlertChecked(completion: @escaping (NetworkResult<DiarySettingCheckedResponseDTO>) -> ()) {
        request(.getDiaryCreateTimeAlertChecked, completion: completion)
    }
    
    func patchDiaryCreateTimeAlertCheckStatus(completion: @escaping (NetworkResult<Any>) -> ()) {
        request(.patchDiaryCreateTimeAlertCheckStatus, completion: completion)
    }
}

private extension DiarySettingService {
    
    //MARK: - API Request Func
    
    //디코딩할 데이터가 없는 경우
    func request(_ target: DiarySettingAPI, completion: @escaping (NetworkResult<Any>) -> ()) {
        provider.request(target) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let respone):
                let networkResult: NetworkResult<Any> = self.fetchNetworkResult(
                    statusCode: respone.statusCode,
                    data: respone.data
                )
                completion(networkResult)
                
            case .failure(let err):
                if err.response == nil {
                    completion(.networkFail())
                }
            }
        }
    }
    
    //디코딩할 데이터가 있는 경우
    private func request<T: Decodable>(_ target: DiarySettingAPI, completion: @escaping (NetworkResult<T>) -> ()) {
        provider.request(target) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<T> = self.fetchNetworkResult(
                    statusCode: response.statusCode,
                    data: response.data
                )
                completion(networkResult)
                
            case .failure(let err):
                if err.response == nil {
                    completion(.networkFail())
                }
            }
        }
    }
}
