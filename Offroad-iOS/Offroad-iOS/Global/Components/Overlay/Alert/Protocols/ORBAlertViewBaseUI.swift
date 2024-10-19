//
//  ORBAlertViewBaseUI.swift
//  Offroad-iOS
//
//  Created by 김민성 on 10/19/24.
//

import UIKit

protocol ORBAlertViewBaseUI: ORBAlertViewType {
    
//    var buttons: [OFRAlertButton] { get }
//    
//    var closeButton: UIButton { get }
//    var contentView: UIView { get set }
//    
//    var titleLabel: UILabel { get }
//    var messageLabel: UILabel { get }
//    var defaultTextField: UITextField { get }
//    var buttonStackView: UIStackView { get }
    
    var topInset: CGFloat { get }
    var leftInset: CGFloat { get }
    var rightInset: CGFloat { get }
    var bottomInset: CGFloat { get }
    
}

extension ORBAlertViewBaseUI {
    
    var topInset: CGFloat {
        switch type {
        case .normal, .textField, .textFieldWithSubMessage, .custom:
            28
        case .scrollableContent, .explorationResult, .acquiredEmblem:
            38
        }
    }
    
    var leftInset: CGFloat {
        switch type {
        case .normal, .textField, .textFieldWithSubMessage, .scrollableContent, .explorationResult, .custom:
            46
        case .acquiredEmblem:
            24
        }
    }
    
    var rightInset: CGFloat {
        switch type {
        case .normal, .textField, .textFieldWithSubMessage, .scrollableContent, .explorationResult, .custom:
            46
        case .acquiredEmblem:
            24
        }
    }
    
    var bottomInset: CGFloat {
        switch type {
        case .normal, .textField, .textFieldWithSubMessage, .custom:
            28
        case .scrollableContent, .explorationResult:
            38
        case .acquiredEmblem:
            20
        }
    }
    
}
