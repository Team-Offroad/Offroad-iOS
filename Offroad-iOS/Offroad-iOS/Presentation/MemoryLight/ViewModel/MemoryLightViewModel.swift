//
//  MemoryLightViewModel.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 3/20/25.
//

import Foundation

final class MemoryLightViewModel {
    
    //MARK: - Properties
    
    var MemoryLightData = MemoryLightModel.dummy()
}

extension MemoryLightViewModel {
    
    //MARK: - MARK
    
    func indexforDate(date: Date) -> Int {
        let calendar = Calendar(identifier: .gregorian)
        let targetYear = calendar.component(.year, from: date)
        let targetMonth = calendar.component(.month, from: date)
        let targetDay = calendar.component(.day, from: date)

        return MemoryLightData.firstIndex { $0.year == targetYear && $0.month == targetMonth && $0.day == targetDay } ?? 0
    }
}
