//
//  ConsoleLogWindow.swift
//  ORB(Dev)
//
//  Created by 김민성 on 1/31/25.
//

import UIKit

class ConsoleLogWindow: UIWindow {
    
    let consoleLogViewController = ConsoleLogViewController()
    
    init() {
        super.init(windowScene: UIWindowScene.current)
        
        rootViewController = consoleLogViewController
        windowLevel = UIWindow.Level.alert + 2
        isHidden = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {        
        if consoleLogViewController.rootView.floatingButton.frame.contains(point) ||
            consoleLogViewController.rootView.logTextView.frame.contains(point) {
            return super.hitTest(point, with: event)
        } else {
            return nil
        }
    }
    
}
