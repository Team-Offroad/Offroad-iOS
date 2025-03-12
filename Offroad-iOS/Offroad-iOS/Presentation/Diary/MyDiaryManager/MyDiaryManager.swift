//
//  MyDiaryManager.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 3/11/25.
//

import Foundation

import RxSwift
import RxRelay

final class MyDiaryManager {
    
    //MARK: - Properties
    
    static let shared = MyDiaryManager()
    
    var disposeBag = DisposeBag()
    var minimumDate = Date()
    var maximumDate = Date()

    let updateCalenderCurrentPage = PublishRelay<Date>()
    
    //MARK: - Life Cycle
    
    private init() { }
}
