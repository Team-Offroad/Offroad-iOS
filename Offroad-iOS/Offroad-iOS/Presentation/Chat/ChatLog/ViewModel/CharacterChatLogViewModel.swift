//
//  CharacterChatLogViewModel.swift
//  Offroad-iOS
//
//  Created by 김민성 on 11/16/24.
//

import UIKit

final class CharacterChatLogViewModel {
    
    func groupChatsByDateForDiffableDataSource(items: [CharacterChatItem]) -> [String: [CharacterChatItem]] {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return Dictionary(grouping: items, by: { formatter.string(from: $0.createdDate) })
    }
    
    func areDatesSameDay(_ date1: Date, _ date2: Date) -> Bool {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "Asia/Seoul")!
        return calendar.isDate(date1, inSameDayAs: date2)
    }
    
}
