//
//  AmplitudeManager.swift
//  Offroad-iOS
//
//  Created by 김민성 on 3/7/25.
//

import Foundation

import AmplitudeSwift

class AmplitudeManager {
    
    static var shared = AmplitudeManager()
    
    private(set) var amplitude: Amplitude
    
    private init() {
        let amplitudeAPIKey = Bundle.main.infoDictionary?["AMPLITUDE_API_KEY"] as? String
        self.amplitude = Amplitude(configuration: .init(apiKey: amplitudeAPIKey ?? ""))
    }
}
