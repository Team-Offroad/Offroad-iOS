//
//  LogPrinterManager.swift
//  ORB(Dev)
//
//  Created by 김민성 on 1/31/25.
//

import Foundation

class LogPrinterManager {
    
    //MARK: Type Properties
    
    static let shared = LogPrinterManager()
    
    //MARK: - Properties
    
    private let logPrinterWindow = LogPrinterWindow()
    
    //MARK: - Life Cycle
    
    private init() {
        self.setHiddenState(isHidden: !UserDefaults.standard.bool(forKey: "logPrinterActivation"))
    }
    
}

extension LogPrinterManager {
    
    //MARK: - Func
    
    func printLog(_ log: String) {
        DispatchQueue.main.async { [weak self] in
            guard let logPrinterViewController = self?.logPrinterWindow.rootViewController as? LogPrinterViewController else { return }
            logPrinterViewController.printLog(log)
        }
    }
    
    func setHiddenState(isHidden: Bool) {
        logPrinterWindow.isHidden = isHidden
        if isHidden {
            logPrinterWindow.resignKey()
        } else {
            logPrinterWindow.makeKey()
        }
    }
    
}
