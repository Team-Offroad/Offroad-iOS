////
////  AcquiredCharacterService.swift
////  Offroad-iOS
////
////  Created by  정지원 on 9/8/24.
////
//
//import Foundation
//
//import Moya
//
//protocol CharacterListServiceProtocol {
//    func getCharacterListInfo(completion: @escaping (NetworkResult<CharacterListResponseDTO>) -> ())
//}
//
//final class CharacterListService: BaseService, CharacterListServiceProtocol {
//    let provider = MoyaProvider<CharacterListAPI>.init(session: Session(interceptor: TokenInterceptor.shared), plugins: [MoyaPlugin()])
//
//    func getCharacterListInfo(completion: @escaping (NetworkResult<CharacterListResponseDTO>) -> ()) {
//        provider.request(.getCharacterListInfo) { result in
//            switch result {
//            case .success(let response):
//                let networkResult: NetworkResult<CharacterListResponseDTO> = self.fetchNetworkResult(
//                    statusCode: response.statusCode,
//                    data: response.data
//                )
//                completion(networkResult)
//            case .failure(let err):
//                print(err)
//            }
//        }
//    }
//}
//
//
