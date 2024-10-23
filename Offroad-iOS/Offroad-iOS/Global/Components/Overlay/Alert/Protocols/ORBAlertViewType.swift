//
//  ORBAlertViewType.swift
//  Offroad-iOS
//
//  Created by 김민성 on 10/19/24.
//

import Foundation

protocol ORBAlertViewType {
    
    var type: ORBAlertType { get }
    var title: String? { get set }
    var message: String? {get set }
    
}
