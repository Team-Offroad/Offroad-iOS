//
//  NetworkMonitoring.swift
//  Offroad-iOS
//
//  Created by 김민성 on 10/23/24.
//

import UIKit

import RxSwift

protocol NetworkMonitoring: UIViewController {
    
    var disposeBagForNetworkConnection: DisposeBag { get set }
    var networkConnectionSubject: PublishSubject<Bool> { get }
    
    func subscribeNetworkChange()
    
}

extension NetworkMonitoring where Self: UIViewController {
    
    func subscribeNetworkChange() {
        NetworkMonitoringManager.shared.isNetworkConnectionChanged
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] isConnected in
                guard let self else { return }
                
                networkConnectionSubject.onNext(isConnected)
            })
            .disposed(by: disposeBagForNetworkConnection)
    }
    
}
