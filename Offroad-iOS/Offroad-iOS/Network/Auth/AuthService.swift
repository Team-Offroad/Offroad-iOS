//
//  AuthService.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 7/15/24.
//

import Foundation

import Moya

protocol AuthAPIServiceProtocol {
    func patchSocialLogin(body: SocialLoginRequestDTO,
                          completion: @escaping (NetworkResult<SocialLoginResponseDTO>) -> ())
    func postReissueToken(completion: @escaping (NetworkResult<RefreshTokenResponseDTO>) -> ())
}
