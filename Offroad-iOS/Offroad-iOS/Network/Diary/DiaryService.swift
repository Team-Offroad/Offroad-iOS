//
//  DiaryService.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 3/24/25.
//

import Foundation

import Moya

protocol DiaryServiceProtocol {
    func patchDiaryCheck(date: String, completion: @escaping (NetworkResult<Any>) -> ())
    func getDiaryMonthlyHexCodes(year: Int, month: Int, completion: @escaping (NetworkResult<DiaryColorsResponseDTO>) -> ())
    func getLatestAndBeforeDiaries(previousCount: Int?, completion: @escaping (NetworkResult<DiaryLatestResponseDTO>) -> ())
    func getInitialDiaryDate(completion: @escaping (NetworkResult<DiaryInitialDateResponseDTO>) -> ())
    func getLatestDiaryChecked(completion: @escaping (NetworkResult<DiaryCheckStatusResponseDTO>) -> ())
    func getDiariesByDate(date: String, previousCount: Int?, nextCount: Int?, completion: @escaping (NetworkResult<DiaryByDateResponseDTO>) -> ())
}

final class DiaryService: BaseService, DiaryServiceProtocol {
    let provider = MoyaProvider<DiaryAPI>.init(session: Session(interceptor: TokenInterceptor.shared), plugins: [MoyaPlugin()])
    
    func patchDiaryCheck(date: String, completion: @escaping (NetworkResult<Any>) -> ()) {
        request(.patchDiaryCheck(date: date), completion: completion)
    }
    
    func getDiaryMonthlyHexCodes(year: Int, month: Int, completion: @escaping (NetworkResult<DiaryColorsResponseDTO>) -> ()) {
        request(.getDiaryMonthlyHexCodes(year: year, month: month), completion: completion)
    }
    
    func getLatestAndBeforeDiaries(previousCount: Int?, completion: @escaping (NetworkResult<DiaryLatestResponseDTO>) -> ()) {
        request(.getLatestAndBeforeDiaries(previousCount: previousCount), completion: completion)
    }
    
    func getInitialDiaryDate(completion: @escaping (NetworkResult<DiaryInitialDateResponseDTO>) -> ()) {
        request(.getInitialDiaryDate, completion: completion)
    }
    
    func getLatestDiaryChecked(completion: @escaping (NetworkResult<DiaryCheckStatusResponseDTO>) -> ()) {
        request(.getLatestDiaryChecked, completion: completion)
    }
    
    func getDiariesByDate(date: String, previousCount: Int?, nextCount: Int?, completion: @escaping (NetworkResult<DiaryByDateResponseDTO>) -> ()) {
        request(.getDiariesByDate(date: date, previousCount: previousCount, nextCount: nextCount), completion: completion)
    }
}

private extension DiaryService {
    
    //MARK: - API Request Func
    
    //디코딩할 데이터가 없는 경우
    func request(_ target: DiaryAPI, completion: @escaping (NetworkResult<Any>) -> ()) {
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
    private func request<T: Decodable>(_ target: DiaryAPI, completion: @escaping (NetworkResult<T>) -> ()) {
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
