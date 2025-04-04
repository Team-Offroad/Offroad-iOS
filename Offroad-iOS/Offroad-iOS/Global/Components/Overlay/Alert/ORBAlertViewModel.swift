//
//  ORBAlertViewModel.swift
//  Offroad-iOS
//
//  Created by 김민성 on 9/17/24.
//

import UIKit

import RxSwift
import RxCocoa

class ORBAlertViewModel {
    
    private var disposeBag = DisposeBag()
    
    var titleRelay = PublishRelay<String?>()
    var messageRelay = PublishRelay<String?>()
    var alertTypeSubject = PublishSubject<ORBAlertType>()
    var textFieldToBeFirstResponderSubject: BehaviorSubject<UITextField?> = BehaviorSubject(value: nil)
    
    var type: ORBAlertType = .normal
    
    var backgroundTapGesture = UITapGestureRecognizer()
    
    
    var textFieldToBeFirstResponder: UITextField? = nil
    
    var keyboardFrameRelay = PublishRelay<CGRect>()
    
    var defaultTextInputRelay = PublishRelay<String>()
    
    var isInputEmptyObservable: Observable<Bool>
    
    init() {
        self.isInputEmptyObservable = defaultTextInputRelay.map( { $0 == "" })
        
        alertTypeSubject
            .subscribe { [weak self] type in
                guard let self else { return }
                self.type = type
            }.disposed(by: disposeBag)
        
        textFieldToBeFirstResponderSubject
            .subscribe(onNext: { [weak self] textField in
                self?.textFieldToBeFirstResponder = textField
            })
            .disposed(by: disposeBag)
    }
    
}
