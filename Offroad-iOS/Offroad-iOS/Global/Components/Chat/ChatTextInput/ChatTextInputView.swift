//
//  ChatTextInputView.swift
//  Offroad-iOS
//
//  Created by 김민성 on 2/8/25.
//

import UIKit

import RxSwift
import RxCocoa

public class ChatTextInputView: UIView {
    
    //MARK: - Properties
    
    var disposeBag = DisposeBag()
    
    //MARK: - UI Properties
    
    private let userChatInputView = UITextView()
    private let sendButton = ShrinkableButton(shrinkScale: 0.9)
    
    public init() {
        super.init(frame: .zero)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

extension ChatTextInputView {
    
    
    
}
