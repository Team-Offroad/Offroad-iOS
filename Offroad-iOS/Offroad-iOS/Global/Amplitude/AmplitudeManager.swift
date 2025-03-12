//
//  AmplitudeManager.swift
//  Offroad-iOS
//
//  Created by 김민성 on 3/7/25.
//

import Foundation

import AmplitudeSwift

/// Amplitude 객체를 보관하는 싱글톤 객체.
/// 이벤트를 트래킹하는 간단한 동작들 구현
public class AmplitudeManager {
    
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

public extension AmplitudeManager {
    
    /// 간단한 텍스트만을 이용한 이벤트 추적
    /// - Parameters:
    ///   - eventName: 이벤트 이름.
    func trackEvent(withName eventName: String) {
        amplitude.track(eventType: eventName)
    }
    
}
