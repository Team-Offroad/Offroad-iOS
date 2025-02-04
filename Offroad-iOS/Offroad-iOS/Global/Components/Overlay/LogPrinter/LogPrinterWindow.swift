//
//  LogPrinterWindow.swift
//  ORB(Dev)
//
//  Created by 김민성 on 1/31/25.
//

import UIKit

class LogPrinterWindow: UIWindow {
    
    //MARK: - Properties
    
    let logPrinterViewController = LogPrinterViewController()
    
    //MARK: - Life Cycle
    
    init() {
        super.init(windowScene: UIWindowScene.current)
        
        rootViewController = logPrinterViewController
        windowLevel = UIWindow.Level.alert + 2
        isHidden = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension LogPrinterWindow {
    
    //MARK: - Func
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if logPrinterViewController.rootView.floatingButton.frame.contains(point) ||
            logPrinterViewController.rootView.floatingView.frame.contains(point) {
            return super.hitTest(point, with: event)
        } else {
            return nil
        }
    }
    
}
