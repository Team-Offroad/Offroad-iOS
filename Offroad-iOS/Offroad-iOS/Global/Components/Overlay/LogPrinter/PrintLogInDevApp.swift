//
//  PrintLogInDevApp.swift
//  Offroad-iOS
//
//  Created by 김민성 on 2/1/25.
//

/// 원하는 문구를 개발용 앱 내의 로그 콘솔에 띄우는 동작.
/// - Parameter log: 개발용 앱의 콘솔에 표시할 로그 문구
///
/// Xcode의 콘솔에 print하는 동작도 포함합니다. (Xcode 콘솔에 띄우기 위해 추가로 print 호출할 필요 없음.)
/// 배포용 앱에서는 print 문과 완전히 같은 동작입니다.
func printLog(_ log: String) {
    print(log)
    #if DevTarget
    LogPrinterManager.shared.printLog(log)
    #else
    return
    #endif
}
