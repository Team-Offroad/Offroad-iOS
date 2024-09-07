//
//  NicknameService.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 7/15/24.
//

import Foundation

import Moya

protocol NicknameServiceProtocol {
    func checkNicknameDuplicate(inputNickname: String, completion: @escaping (NetworkResult<NicknameCheckResponseDTO>) -> ())
}

final class NicknameService: BaseService, NicknameServiceProtocol {
    
    let provider = MoyaProvider<NicknameAPI>.init(session: Session(interceptor: TokenInterceptor.shared), plugins: [MoyaPlugin()])
    
    func checkNicknameDuplicate(inputNickname: String, completion: @escaping (NetworkResult<NicknameCheckResponseDTO>) -> ()) {
        
        provider.request(.checkNicknameDuplicate(inputNickname: inputNickname)) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<NicknameCheckResponseDTO> = self.fetchNetworkResult(
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

