//
//  OFRAlertViewModel.swift
//  Offroad-iOS
//
//  Created by 김민성 on 9/17/24.
//

import Foundation

class OFRAlertViewModel {
    
    var onKeyboardWillShow: (() -> Void)? = nil
    
    var keyboardFrameObservable: CGRect? = nil {
        didSet {
            onKeyboardWillShow?()
        }
    }
    
    
    
    
    
    
}
