//
//  NetworkMonitor.swift
//  Offroad-iOS
//
//  Created by 김민성 on 10/23/24.
//

import Foundation

import Network
import RxSwift

final class NetworkMonitoringManager {
    
    //MARK: static Properties
    
    static let shared = NetworkMonitoringManager()
    
    //MARK: - Properties
    
    var disposeBag = DisposeBag()
    
    let networkMonitor = NWPathMonitor()
    var pathInterfaceChanged = PublishSubject<Bool>()
    var networkConnectionChanged = PublishSubject<Bool>()
    
    //MARK: - Life Cycle
    
    private init() {
        networkMonitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                if path.usesInterfaceType(.wifi) || path.usesInterfaceType(.cellular) || path.usesInterfaceType(.wiredEthernet) {
                    self.pathInterfaceChanged.onNext(true)
                } else {
                    self.pathInterfaceChanged.onNext(false)
                }
            } else {
                self.pathInterfaceChanged.onNext(false)
            }
        }
        
        pathInterfaceChanged.distinctUntilChanged()
            .subscribe(onNext: { [weak self] isConnected in
                guard let self else { return }
                self.networkConnectionChanged.onNext(isConnected)
            }).disposed(by: disposeBag)
        
        networkMonitor.start(queue: DispatchQueue.global())
        
    }
    
}
