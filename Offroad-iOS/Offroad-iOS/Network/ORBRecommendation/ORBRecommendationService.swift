//
//  ORBRecommendationService.swift
//  ORB_Dev
//
//  Created by 김민성 on 6/7/25.
//

import Foundation

import Moya

struct ORBRecommendationService {
    private let provider = MoyaProvider<ORBRecommendationAPI>.init(
        session: Session(interceptor: TokenInterceptor.shared),
        plugins: [MoyaPlugin()]
    )
    
    /// 오브의 추천 장소 목록을 비동기적으로 받아오는 함수.
    /// - Returns: 오브의 추천 장소 목록. `[ORBRecommendationPlaceModel]` 타입.
    func getRecommendedPlaces() async throws -> [ORBRecommendationPlaceModel] {
        let api = ORBRecommendationAPI.getRecommendedPlaces
        
        return try await withCheckedThrowingContinuation { continuation in
            provider.request(api) { result in
                switch result {
                case .success(let response):
                    do {
                        let decodedDTO = try NetworkResultHandler().handleSuccessCase(
                            response: response,
                            decodingType: ORBRecommendationResponseDTO.self
                        )
                        
                        let places = try decodedDTO.data.recommendations.map { try ORBRecommendationPlaceModel($0) }
                        continuation.resume(returning: places)
                    } catch {
                        continuation.resume(throwing: error)
                    }
                case .failure(let moyaError):
                    let errorToThrow = NetworkResultHandler().handleFailureCase(moyaError: moyaError)
                    continuation.resume(throwing: errorToThrow)
                }
            }
        }
    }
    
    /// 오브의 추천소에서 채팅을 보내는 함수.
    /// - Parameter content: 채팅을 보낼 메시지.
    /// - Returns: 장소 추천이 성공했는지 여부와, 오브의 답장 텍스트.
    ///
    /// 오브의 추천소에서 채팅을 통해 주문서를 작성할 때, 채팅을 보내는 동작에 해당.
    func sendRecommendationChat(content: String) async throws -> (Bool, String) {
        let api = ORBRecommendationAPI.postRecommendationChat(content: content)
        
        return try await withCheckedThrowingContinuation { continuation in
            provider.request(api) { result in
                switch result {
                case .success(let resposne):
                    do {
                        let decodedDTO = try NetworkResultHandler().handleSuccessCase(
                            response: resposne,
                            decodingType: ORBRecommendationChatResponseDTO.self
                        )
                        continuation.resume(returning: (decodedDTO.data.success, decodedDTO.data.content))
                    } catch {
                        continuation.resume(throwing: error)
                    }
                case .failure(let moyaError):
                    let errorToThrow = NetworkResultHandler().handleFailureCase(moyaError: moyaError)
                    continuation.resume(throwing: errorToThrow)
                }
            }
        }
    }
}
