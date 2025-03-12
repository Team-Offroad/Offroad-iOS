//
//  MyDiaryManager.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 3/11/25.
//

import Foundation

import RxSwift
import RxRelay

enum DateType {
    case minimum
    case maximum
    case current
}

final class MyDiaryManager {
    
    //MARK: - Properties
    
    static let shared = MyDiaryManager()
    
    var disposeBag = DisposeBag()
    var minimumDate = Date()
    var maximumDate = Date()
    var currentDate = Date()

    let updateCalenderCurrentPage = PublishRelay<Date>()
    
    //MARK: - Life Cycle
    
    private init() { }
}

extension MyDiaryManager {
    
    //MARK: - Func
    
    func fetchYearMonthValue(dateType: DateType) -> (year: Int, month: Int) {
        let calendar = Calendar.current

        switch dateType {
        case .minimum:
            return (calendar.component(.year, from: minimumDate), calendar.component(.month, from: minimumDate))
        case .maximum:
            return (calendar.component(.year, from: maximumDate), calendar.component(.month, from: maximumDate))
        case .current:
            return (calendar.component(.year, from: currentDate), calendar.component(.month, from: currentDate))
        }
    }
}
