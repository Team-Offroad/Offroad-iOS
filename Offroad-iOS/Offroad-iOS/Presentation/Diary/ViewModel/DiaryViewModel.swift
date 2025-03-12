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
    
    private let calendar = Calendar.current
    private let dummyDatesAndColor = ["2024-12-11": ["70DAFFB2", "FFDC14B2"], "2024-12-22": ["FF69E1B2", "FFB73BB2"], "2024-12-29": ["FF69E1B2", "5580FFB2"], "2025-03-07": ["70DAFFB2", "FFDC14B2"], "2025-03-08": ["FF69E1B2", "FFB73BB2"], "2025-03-10": ["FF69E1B2", "5580FFB2"]]
    
    var currentPage = Date()
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
        dateComponents.year = 2024
        dateComponents.month = 11
        
        MyDiaryManager.shared.minimumDate = calendar.date(from: dateComponents) ?? Date()
    }
    
    func canMoveMonth(_ target: Month) -> Bool {
        let currentComponents = calendar.dateComponents([.year, .month], from: currentPage)
        let minimumComponents = calendar.dateComponents([.year, .month], from: MyDiaryManager.shared.minimumDate)
        let maximumComponents = calendar.dateComponents([.year, .month], from: MyDiaryManager.shared.maximumDate)
        
        if let currentYear = currentComponents.year,
           let currentMonth = currentComponents.month,
           let minYear = minimumComponents.year,
           let minMonth = minimumComponents.month,
           let maxYear = maximumComponents.year,
           let maxMonth = maximumComponents.month {
            
            switch target {
            case .previous:
                return (currentYear > minYear) || (currentYear == minYear && currentMonth > minMonth)
            case .next:
                return (currentYear < maxYear) || (currentYear == maxYear && currentMonth < maxMonth)
            }
        } else {
            return false
        }
    }
}
