//
//  LogWindow.swift
//  ORB(Dev)
//
//  Created by 김민성 on 1/31/25.
//

import UIKit

internal class LogPrinterWindow: UIWindow {
    
    //MARK: - Properties
    
    let logPrinterViewController = LogPrinterViewController()
    
    static var currentWindowScene: UIWindowScene {
        for scene in UIApplication.shared.connectedScenes {
            guard let windowScene = scene as? UIWindowScene else { continue }
            return windowScene
        }
        fatalError("connected scene not found")
    }
    
    /// 현재 window를 반환하는 타입 변수
    static var currentWindow: UIWindow {
        for scene in UIApplication.shared.connectedScenes {
            guard let windowScene = scene as? UIWindowScene else { fatalError() }
            for window in windowScene.windows {
                if window.isKeyWindow { return window }
            }
        }
        fatalError()
    }
    
    //MARK: - Life Cycle
    
    init() {
        super.init(windowScene: LogPrinterWindow.currentWindowScene)
        
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
