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
    
    //MARK: - Type Properties
    
    static var shared = AmplitudeManager()
    
    //MARK: - Properties
    
    /// background에서 다음 시간 동안 아무런 앰플리튜드 이벤트가 발생하지 않을 경우 세션 종료. millisecond 단위이며, 10분으로 설정
    private let minTimeBetweenSessionsMillis: Int = 1000 * 60 * 10
    private(set) var amplitude: Amplitude
    
    // MARK: - Life Cycle
    
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
    
    /// 간단한 텍스트만을 이용한 이벤트 기록
    /// - Parameters:
    ///   - eventName: 이벤트 이름.
    func trackEvent(withName eventName: String) {
        amplitude.track(eventType: eventName)
    }
    
}
