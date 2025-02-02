//
//  File.swift
//  LogManager
//
//  Created by 김민성 on 2/2/25.
//

import Foundation

internal class LogPrinterManager {
    
    //MARK: Type Properties
    
    static let shared = LogPrinterManager()
    
    //MARK: - Properties
    
    let logPrinterWindow = LogPrinterWindow()
    
    //MARK: - Life Cycle
    
    private init() { }
    
}

internal extension LogPrinterManager {
    
    //MARK: - Func
    
    func printLog(_ log: String) {
        DispatchQueue.main.async { [weak self] in
            guard let logPrinterViewController = self?.logPrinterWindow.rootViewController as? LogPrinterViewController else { return }
            logPrinterViewController.printLog(log)
        }
    }
    
}
