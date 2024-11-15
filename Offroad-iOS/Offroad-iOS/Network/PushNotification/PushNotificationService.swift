//
//  PushNotificationService.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 11/14/24.
//

import Foundation

import Moya

protocol PushNotificationServiceProtocol {
    func postSocialLogin(body: FcmTokenRequestDTO,
                          completion: @escaping (NetworkResult<Any>) -> ())
}

final class PushNotificationService: BaseService, PushNotificationServiceProtocol {
    let provider = MoyaProvider<PushNotificationAPI>.init(session: Session(interceptor: TokenInterceptor.shared), plugins: [MoyaPlugin()])

    func postSocialLogin(body: FcmTokenRequestDTO, completion: @escaping (NetworkResult<Any>) -> ()) {
        provider.request(.postFcmToken(body: body)) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<Any> = self.fetchNetworkResult(
                    statusCode: response.statusCode,
                    data: response.data
                )
                completion(networkResult)
            case .failure(let err):
                print(err)
            }
        }
    }
}
