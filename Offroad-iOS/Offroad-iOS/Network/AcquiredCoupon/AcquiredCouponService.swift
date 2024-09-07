//
//  AcquiredCouponService.swift
//  Offroad-iOS
//
//  Created by  정지원 on 9/8/24.
//

import Foundation

import Moya

protocol AcquiredCouponServiceProtocol {
    func getCouponList(completion: @escaping (NetworkResult<AcquiredCouponResponseDTO>) -> ())
}

final class AcquiredCouponService: BaseService, AcquiredCouponServiceProtocol {
    let provider = MoyaProvider<AcquiredCouponAPI>.init(session: Session(interceptor: TokenInterceptor.shared), plugins: [MoyaPlugin()])

    func getCouponList(completion: @escaping (NetworkResult<AcquiredCouponResponseDTO>) -> ()) {
        provider.request(.getCouponList) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<AcquiredCouponResponseDTO> = self.fetchNetworkResult(
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

