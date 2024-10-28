//
//  NoticeService.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 9/23/24.
//

import Foundation

import Moya

protocol NoticeServiceProtocol {
    func getNoticeList(completion: @escaping (NetworkResult<NoticeResponseDTO>) -> ())
}

final class NoticeService: BaseService, NoticeServiceProtocol {
    let provider = MoyaProvider<NoticeAPI>.init(session: Session(interceptor: TokenInterceptor.shared), plugins: [MoyaPlugin()])
    
    func getNoticeList(completion: @escaping (NetworkResult<NoticeResponseDTO>) -> ()) {
        provider.request(.getNoticeList) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<NoticeResponseDTO> = self.fetchNetworkResult(
                    statusCode: response.statusCode,
                    data: response.data
                )
                completion(networkResult)
            case .failure(let error):
                print(error.localizedDescription)
                switch error {
                case .underlying(let error, let response):
                    print(error.localizedDescription)
                    if response == nil {
                        completion(.networkFail)
                    }
                default:
                    print(error.localizedDescription)
                }
            }
        }
    }
}
