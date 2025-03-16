//
//  DiaryViewModel.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 3/11/25.
//

import Foundation

enum Month {
    case previous
    case next
}

final class DiaryViewModel {
    
    // MARK: - Properties
    
    private let calendar = Calendar(identifier: .gregorian)
    private let dummyDatesAndColor = ["2024-12-11": ["70DAFFB2", "FFDC14B2"], "2024-12-22": ["FF69E1B2", "FFB73BB2"], "2024-12-29": ["FF69E1B2", "5580FFB2"], "2025-03-07": ["70DAFFB2", "FFDC14B2"], "2025-03-08": ["FF69E1B2", "FFB73BB2"], "2025-03-10": ["FF69E1B2", "5580FFB2"]]
}

extension DiaryViewModel {
    
    //MARK: - Func
    
    func fetchDummyDates() -> [String] {
        return Array(dummyDatesAndColor.keys)
    }
    
    func fetchDummyColorsForDate(_ date: Date) -> [String]? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let key = formatter.string(from: date)
        
        return dummyDatesAndColor[key]
    }
    
    func fetchMinimumDate() {
        //임시(서버에서 불러와서 설정할 예정)
        var dateComponents = DateComponents()
        dateComponents.year = 2022
        dateComponents.month = 2
        
        MyDiaryManager.shared.minimumDate = calendar.date(from: dateComponents) ?? Date()
    }
    
    func canMoveMonth(_ target: Month) -> Bool {
        let (currentPageYear, currentPageMonth) = MyDiaryManager.shared.fetchYearMonthValue(dateType: .currentPage)
        let (minYear, minMonth) = MyDiaryManager.shared.fetchYearMonthValue(dateType: .minimum)
        let (maxYear, maxMonth) = MyDiaryManager.shared.fetchYearMonthValue(dateType: .maximum)
        
        switch target {
        case .previous:
            return (currentPageYear > minYear) || (currentPageYear == minYear && currentPageMonth > minMonth)
        case .next:
            return (currentPageYear < maxYear) || (currentPageYear == maxYear && currentPageMonth < maxMonth)
        }
    }
}
