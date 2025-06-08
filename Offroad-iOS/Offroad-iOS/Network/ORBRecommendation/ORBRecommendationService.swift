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
                        
                        let places = try decodedDTO.data.recommendataion.map { try ORBRecommendationPlaceModel($0) }
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
