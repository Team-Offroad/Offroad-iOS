//
//  CouponService.swift
//  Offroad-iOS
//
//  Created by 김민성 on 9/23/24.
//

import Foundation

import Moya

protocol CouponServiceProtocol {
    
    func getAcquiredCouponList(isUsed: Bool, size: Int, cursor: Int, completion: @escaping (NetworkResult<CouponListResponseDTO>) -> Void)
    func postCouponRedemption(body: CouponRedemptionRequestDTO, completion: @escaping (NetworkResult<CouponRedemptionResponseDTO>) -> Void)
    
}

final class CouponService: BaseService, CouponServiceProtocol {
    let provider = MoyaProvider<CouponAPI>.init(session: Session(interceptor: TokenInterceptor.shared), plugins: [MoyaPlugin()])
    
    func getAcquiredCouponList(isUsed: Bool, size: Int, cursor: Int, completion: @escaping (NetworkResult<CouponListResponseDTO>) -> Void) {
        provider.request(.getCoupons(isUsed: isUsed, size: size, cursor: cursor), completion: { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<CouponListResponseDTO> = self.fetchNetworkResult(
                    statusCode: response.statusCode,
                    data: response.data
                )
                completion(networkResult)
            case .failure(let error):
                print(error.localizedDescription)
                let networkResult: NetworkResult<CouponListResponseDTO> = self.fetchNetworkResult(
                    statusCode: error.response?.statusCode ?? 0,
                    data: error.response?.data ?? Data()
                )
                completion(networkResult)
            }
        })
    }
    
    func postCouponRedemption(
        body: CouponRedemptionRequestDTO,
        completion: @escaping (
            NetworkResult<CouponRedemptionResponseDTO>
        ) -> Void
    ) {
        provider.request(.redeemCoupon(body), completion: { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<CouponRedemptionResponseDTO> = self.fetchNetworkResult(
                    statusCode: response.statusCode,
                    data: response.data
                )
                completion(networkResult)
            case .failure(let error):
                print(error.localizedDescription)
                let networkResult: NetworkResult<CouponRedemptionResponseDTO> = .networkFail()
                completion(networkResult)
            }
        })
    }
    
}
