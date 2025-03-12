//
//  AmplitudeManager.swift
//  Offroad-iOS
//
//  Created by 김민성 on 3/7/25.
//

import Foundation

import AmplitudeSwift

/// Amplitude 객체를 보관하는 싱글톤 객체.
class AmplitudeManager {
    
    static var shared = AmplitudeManager()
    
    /// 세션이 자동으로 종료되기 위해 기다릴 시간. millisecond 단위이며, 10분으로 설정
    private let minTimeBetweenSessionsMillis: Int = 1000 * 60 * 10
    private(set) var amplitude: Amplitude
    
    private init() {
        let amplitudeAPIKey = Bundle.main.infoDictionary?["AMPLITUDE_API_KEY"] as? String
        self.amplitude = Amplitude(
            configuration: .init(
                apiKey: amplitudeAPIKey ?? "",
                minTimeBetweenSessionsMillis: minTimeBetweenSessionsMillis,
                autocapture: [.sessions]
            )
        )
    }
}
