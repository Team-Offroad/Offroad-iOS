//
//  CourseQuestDetailService.swift
//  Offroad-iOS
//
//  Created by  정지원 on 6/24/25.
//

import Foundation

import Moya

final class CourseQuestDetailService: BaseService {
    private let provider = MoyaProvider<CourseQuestDetailAPI>(
        session: Session(interceptor: TokenInterceptor.shared),
        plugins: [MoyaPlugin()]
    )

    func getCourseQuestDetail(
        questId: Int,
        completion: @escaping (Result<CourseQuestDetailResponseDTO, NetworkResultError>) -> Void
    ) {
        let api = CourseQuestDetailAPI.getCourseQuestDetail(questId: questId)
        let resultHandler = NetworkResultHandler()
        
        provider.request(api) { result in
            switch result {
            case .success(let response):
                do {
                    let decodedData = try resultHandler.handleSuccessCase(
                        response: response,
                        decodingType: CourseQuestDetailResponseDTO.self
                    )
                    completion(.success(decodedData))
                } catch let error as NetworkResultError {
                    completion(.failure(error))
                } catch {
                    completion(.failure(.unknown(error)))
                }
            case .failure(let error):
                completion(.failure(resultHandler.handleFailureCase(moyaError: error)))
            }
        }
    }

    func getCourseQuestDetail(questId: Int) async throws -> CourseQuestDetailResponseDTO {
        let api = CourseQuestDetailAPI.getCourseQuestDetail(questId: questId)
        let resultHandler = NetworkResultHandler()

        return try await withCheckedThrowingContinuation { continuation in
            provider.request(api) { result in
                switch result {
                case .success(let response):
                    do {
                        let decodedDTO = try resultHandler.handleSuccessCase(
                            response: response,
                            decodingType: CourseQuestDetailResponseDTO.self
                        )
                        continuation.resume(returning: decodedDTO)
                    } catch {
                        continuation.resume(throwing: error)
                    }
                case .failure(let error):
                    continuation.resume(throwing: resultHandler.handleFailureCase(moyaError: error))
                }
            }
        }
    }
}
