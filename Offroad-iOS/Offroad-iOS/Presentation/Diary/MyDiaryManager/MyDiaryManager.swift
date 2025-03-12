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
    case custom
}

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

extension MyDiaryManager {
    
    //MARK: - Func
    
    func fetchYearMonthValue(dateType: DateType, targetDate: Date? = nil) -> (year: Int, month: Int) {
        let calendar = Calendar.current

        switch dateType {
        case .minimum:
            return (calendar.component(.year, from: minimumDate), calendar.component(.month, from: minimumDate))
        case .maximum:
            return (calendar.component(.year, from: maximumDate), calendar.component(.month, from: maximumDate))
        case .custom:
            if let targetDate {
                return (calendar.component(.year, from: targetDate), calendar.component(.month, from: targetDate))
            } else {
                return (Int(), Int())
            }
        }
    }
}
