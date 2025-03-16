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
    case currentPage
}

final class MyDiaryManager {
    
    //MARK: - Properties
    
    static let shared = MyDiaryManager()
    
    var disposeBag = DisposeBag()
    var minimumDate = Date()
    private(set) var maximumDate = Date()
    var currentPageDate = Date()

    let updateCalenderCurrentPage = PublishRelay<Date>()
    
    //MARK: - Life Cycle
    
    private init() { }
}

extension MyDiaryManager {
    
    //MARK: - Func
    
    func fetchYearMonthValue(dateType: DateType) -> (year: Int, month: Int) {
        let calendar = Calendar(identifier: .gregorian)

        switch dateType {
        case .minimum:
            return (calendar.component(.year, from: minimumDate), calendar.component(.month, from: minimumDate))
        case .maximum:
            return (calendar.component(.year, from: maximumDate), calendar.component(.month, from: maximumDate))
        case .currentPage:
            return (calendar.component(.year, from: currentPageDate), calendar.component(.month, from: currentPageDate))
        }
    }
}
