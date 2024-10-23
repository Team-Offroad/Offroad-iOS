//
//  ORBAlertAction.swift
//  Offroad-iOS
//
//  Created by 김민성 on 9/21/24.
//

import Foundation

class ORBAlertAction {
    
    init(title: String?, style: ORBAlertAction.Style, handler: @escaping ((ORBAlertAction) -> Void)) {
        self.title = title
        self.style = style
        self.handler = handler
    }
    
    var title: String?
    var style: ORBAlertAction.Style
    var handler: ((ORBAlertAction) -> Void)
    var isEnabled: Bool = true
}

extension ORBAlertAction {
    
    enum Style {
        case `default`
        case cancel
        case destructive
    }
    
}
