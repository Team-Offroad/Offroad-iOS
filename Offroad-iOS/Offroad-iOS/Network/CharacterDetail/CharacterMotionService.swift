//
//  File.swift
//  Offroad-iOS
//
//  Created by  정지원 on 9/9/24.
//

import Foundation
import Moya

protocol CharacterMotionServiceProtocol {
    func getCharacterMotionList(characterId: Int, completion: @escaping (NetworkResult<CharacterMotionResponseDTO>) -> ())
}

final class CharacterMotionService: BaseService, CharacterMotionServiceProtocol {
    
    let provider = MoyaProvider<CharacterMotionAPI>.init(session: Session(interceptor: TokenInterceptor.shared), plugins: [MoyaPlugin()])

    func getCharacterMotionList(characterId: Int, completion: @escaping (NetworkResult<CharacterMotionResponseDTO>) -> ()) {
        provider.request(.getCharacterMotionList(characterId: characterId)) { result in
            switch result {
            case .success(let response):
                print("===[\(response.statusCode)] \(response.data)===")
                let networkResult: NetworkResult<CharacterMotionResponseDTO> = self.fetchNetworkResult(
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

