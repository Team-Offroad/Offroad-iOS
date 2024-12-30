//
//  PlaceInfoTooltipWindow.swift
//  Offroad-iOS
//
//  Created by 김민성 on 10/27/24.
//

import UIKit

class PlaceInfoTooltipWindow: UIWindow {
    
    //MARK: - Properties
    
    let placeInfoViewController: PlaceInfoViewController
    let contentFrame: CGRect
    
    //MARK: - Life Cycle
    
    init(contentFrame: CGRect) {
        self.placeInfoViewController = PlaceInfoViewController(contentFrame: contentFrame)
        self.contentFrame = contentFrame
        super.init(windowScene: UIWindowScene.current)
        
        rootViewController = placeInfoViewController
        windowLevel = .statusBar + 1
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard placeInfoViewController.isTooltipShown else { return nil }
        if contentFrame.contains(point) {
            if placeInfoViewController.rootView.tooltip.frame.contains(self.convert(point, to: placeInfoViewController.rootView.contentView)) {
                return super.hitTest(point, with: event)
            } else {
                return nil
            }
        } else {
            return super.hitTest(point, with: event)
        }
    }

}
