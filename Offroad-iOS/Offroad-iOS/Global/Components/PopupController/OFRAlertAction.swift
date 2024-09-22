//
//  OFRAlertAction.swift
//  Offroad-iOS
//
//  Created by 김민성 on 9/21/24.
//

import Foundation

class OFRAlertAction {
    
    init(title: String?, style: OFRAlertAction.Style, handler: @escaping ((OFRAlertAction) -> Void)) {
        self.title = title
        self.style = style
        self.handler = handler
    }
    
    var title: String?
    var style: OFRAlertAction.Style
    var handler: ((OFRAlertAction) -> Void)
    var isEnabled: Bool = true
}

extension OFRAlertAction {
    
    enum Style {
        case `default`
        case cancel
        case destructive
    }
    
}
