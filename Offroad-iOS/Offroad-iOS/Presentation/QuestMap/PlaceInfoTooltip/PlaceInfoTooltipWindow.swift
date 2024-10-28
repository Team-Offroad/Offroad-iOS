//
//  PlaceInfoTooltipWindow.swift
//  Offroad-iOS
//
//  Created by 김민성 on 10/27/24.
//

import UIKit

class PlaceInfoTooltipWindow: UIWindow {
    
    let placeInfoViewController: PlaceInfoViewController
    let contentFrame: CGRect
    
    init(contentFrame: CGRect) {
        self.placeInfoViewController = PlaceInfoViewController(contentFrame: contentFrame)
        self.contentFrame = contentFrame
        super.init(windowScene: UIWindowScene.current)
        
        rootViewController = placeInfoViewController
//        placeInfoViewController.view.frame = contentFrame
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if contentFrame.contains(point) {
            if placeInfoViewController.rootView.tooltip.frame.contains(placeInfoViewController.rootView.contentView.convert(point, to: nil)) {
                return super.hitTest(point, with: event)
            }
            return nil
        } else {
            return super.hitTest(point, with: event)
        }
    }
    
}

extension PlaceInfoTooltipWindow {
    
    
    
}
