//
//  PrintLogInDevApp.swift
//  Offroad-iOS
//
//  Created by 김민성 on 2/1/25.
//

/*
 개발용 앱에 한하여 원하는 문구를 앱 내에 띄워줄 수 있습니다.
 */
func printLog(_ log: String) {
    #if DevTarget
    LogPrinterManager.shared.printLog(log)
    #else
    return
    #endif
}
