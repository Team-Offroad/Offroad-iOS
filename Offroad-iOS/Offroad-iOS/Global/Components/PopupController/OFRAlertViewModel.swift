//
//  OFRAlertViewModel.swift
//  Offroad-iOS
//
//  Created by 김민성 on 9/17/24.
//

import UIKit

import RxSwift
import RxCocoa

class OFRAlertViewModel {
    
    private var disposeBag = DisposeBag()
    
    var titleRelay = PublishRelay<String?>()
    var messageRelay = PublishRelay<String?>()
    private var alertTypeRelay = PublishSubject<OFRAlertViewType>()
    var type: OFRAlertViewType = .normal
    
    var animationStartedSubject = BehaviorSubject(value: false)
    
    var backgroundTapGesture = UITapGestureRecognizer()
    
    var textFieldToBeFirstResponderSubject: BehaviorSubject<UITextField?> = BehaviorSubject(value: nil)
    var textFieldToBeFirstResponder: UITextField? = nil
    
    var keyboardFrameRelay = PublishRelay<CGRect>()
    
    var textInput = PublishRelay<String>()
    
    var isInputEmptyObservable: Observable<Bool>
    
    init() {
        self.isInputEmptyObservable = textInput.map( { $0 == "" })
        
        alertTypeRelay.subscribe { [weak self] type in
            self?.type = type
        }.disposed(by: disposeBag)
        
        
        textFieldToBeFirstResponderSubject
            .subscribe(onNext: { [weak self] textField in
                self?.textFieldToBeFirstResponder = textField
            })
            .disposed(by: disposeBag)
    }
    
}
