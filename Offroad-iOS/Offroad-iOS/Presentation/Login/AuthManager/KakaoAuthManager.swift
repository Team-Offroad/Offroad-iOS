//
//  KakaoAuthManager.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 10/8/24.
//

import LocalAuthentication
import KakaoSDKUser

final class KakaoAuthManager {
    
    static let shared = KakaoAuthManager()
    
    private init() {}
    
    var loginSuccess: ((String?) -> Void)?
    var loginFailure: ((Error) -> Void)?
    
    func kakaoLogin() {
        if UserApi.isKakaoTalkLoginAvailable() {
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                    self.loginFailure?(error)
                }
                else {
                    print("토큰 발급 성공!")

                    let userKakaoAccessTokenString = oauthToken?.accessToken
                    self.loginSuccess?(userKakaoAccessTokenString)
                }
            }
        }
        else {
            print("카카오톡 미설치")
        }
    }
}
