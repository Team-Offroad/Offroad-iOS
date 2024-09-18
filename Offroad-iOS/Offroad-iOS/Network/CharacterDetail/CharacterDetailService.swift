//
//  CharacterDetailService.swift
//  Offroad-iOS
//
//  Created by  정지원 on 9/9/24.
//

import Foundation
import Moya

protocol CharacterDetailServiceProtocol {
    func getAcquiredCharacterInfo(characterId: Int, completion: @escaping (NetworkResult<CharacterDetailResponseDTO>) -> ())
}

final class CharacterDetailService: BaseService, CharacterDetailServiceProtocol {
    let provider = MoyaProvider<CharacterDetailAPI>.init(session: Session(interceptor: TokenInterceptor.shared), plugins: [MoyaPlugin()])

    func getAcquiredCharacterInfo(characterId: Int, completion: @escaping (NetworkResult<CharacterDetailResponseDTO>) -> ()) {
        provider.request(.getCharacterDetailList(characterId: characterId)) { result in
            switch result {
            case .success(let response):
                print("===[\(response.statusCode)] \(response.data)===")
                let networkResult: NetworkResult<CharacterDetailResponseDTO> = self.fetchNetworkResult(
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
