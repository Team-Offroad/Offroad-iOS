//
//  DeveloperModeSettingModel.swift
//  ORB_Dev
//
//  Created by 김민성 on 4/5/25.
//

import Foundation

/// 개발자 모드의 항목 중 switch 를 이용하여 on/off 기능을 나타내는 항목
protocol DeveloperSettingModelToggleable {
    var title: String { get }
    var isEnabled: Bool { get set }
}

/// 개발자 모드의 항목 중 짧은 텍스트를 표현하는 항목 (버전 번호 등)
protocol DeveloperSettingModelNormal {
    var title: String { get }
    var value: String { get }
}

/// 개발자 모드의 항목 중 탐험 시 위치 인증을 무시할 지 여부를 나타내는 모델.
struct LocationBypassing: DeveloperSettingModelToggleable {
    let title = "탐험 시 위치 인증 무시"
    
    var isEnabled: Bool {
        get { UserDefaults.standard.bool(forKey: "bypassLocationAuthentication") }
        set { UserDefaults.standard.set(newValue, forKey: "bypassLocationAuthentication") }
    }
}

/// 개발자 모드의 항목 중 로그 콘솔을 활성화할 지 여부를 나타내는 모델.
struct LogPrinterSettingModel: DeveloperSettingModelToggleable {
    let title = "로그 콘솔 활성화 여부"
    
    var isEnabled: Bool {
        get { UserDefaults.standard.bool(forKey: "logPrinterActivation") }
        set {
            UserDefaults.standard.set(newValue, forKey: "logPrinterActivation")
            LogPrinterManager.shared.setHiddenState(isHidden: !newValue)
        }
    }
}

/// 개발자 모드의 항목 중 현재 버전 번호를 표시하는 항목의 모델.
struct VersionCheckSettingModel: DeveloperSettingModelNormal {
    let title = "버전 번호"
    let value = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
}
