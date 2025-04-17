//
//  CharacterChatLogViewModel.swift
//  Offroad-iOS
//
//  Created by 김민성 on 11/16/24.
//

import UIKit

final class CharacterChatLogViewModel {
    
    func groupChatsByDate(items: [CharacterChatItem]) -> [[CharacterChatItem]] {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        var groupedChats: [String: [CharacterChatItem]] = [:]
        for item in items {
            switch item {
            case .message(let chatMessageModel):
                switch chatMessageModel {
                case .user(let content, let createdDate, let id):
                    let dateKey = formatter.string(from: createdDate) // 날짜만 추출
                    if groupedChats[dateKey] == nil {
                        groupedChats[dateKey] = []
                    }
                    groupedChats[dateKey]?.append(
                        .message(.user(content: content, createdDate: createdDate, id: id))
                    )
                case .orbCharacter(let content, let createdDate, let id):
                    let dateKey = formatter.string(from: createdDate)
                    if groupedChats[dateKey] == nil {
                        groupedChats[dateKey] = []
                    }
                    groupedChats[dateKey]?.append(
                        .message(.user(content: content, createdDate: createdDate, id: id))
                    )
                }
            case .loading(let createdDate):
                let dateKey = formatter.string(from: createdDate)
                if groupedChats[dateKey] == nil {
                    groupedChats[dateKey] = []
                }
                groupedChats[dateKey]?.append(
                    .loading(createdDate: createdDate)
                )
            }
        }
        let sortedKeys = groupedChats.keys.sorted(by: >)// { $0 > $1 }
        return sortedKeys.compactMap { groupedChats[$0] }
    }
    
    func groupChatsByDateForDiffableDataSource(items: [CharacterChatItem]) -> [String: [CharacterChatItem]] {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        var groupedChats: [String: [CharacterChatItem]] = [:]
        for item in items {
            switch item {
            case .message(let chatMessageModel):
                switch chatMessageModel {
                case .user(let content, let createdDate, let id):
                    let dateKey = formatter.string(from: createdDate) // 날짜만 추출
                    if groupedChats[dateKey] == nil {
                        groupedChats[dateKey] = []
                    }
                    groupedChats[dateKey]?.append(
                        .message(.user(content: content, createdDate: createdDate, id: id))
                    )
                case .orbCharacter(let content, let createdDate, let id):
                    let dateKey = formatter.string(from: createdDate) // 날짜만 추출
                    if groupedChats[dateKey] == nil {
                        groupedChats[dateKey] = []
                    }
                    groupedChats[dateKey]?.append(
                        .message(.orbCharacter(content: content, createdDate: createdDate, id: id))
                    )
                }
            case .loading(let createdDate):
                let dateKey = formatter.string(from: createdDate) // 날짜만 추출
                if groupedChats[dateKey] == nil {
                    groupedChats[dateKey] = []
                }
                groupedChats[dateKey]?.append(.loading(createdDate: createdDate))
            }
        }
        
        return groupedChats
    }
    
    // UILabel 안에 특정 텍스트가 들어갔을 때, label의 사이즈를 미리 계산하여 반환하는 함수.
    // (셀을 직접 그리기 전에 셀의 높이를 동적으로 계산하여 flowLayout에서 이를 바탕으로 layout계산해야 하기 때문.)
    // 채팅 내용에 따라 텍스트의 높이가 달라지기 때문에 특정 텍스트일 때 채팅 버블의 높이를 미리 계산하기 위함.
    func calculateLabelSize(text: String, font: UIFont, maxSize: CGSize) -> CGSize {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = font
        label.text = text == "" ? " " : text
        
        // 너비를 제한한 크기 계산
        let fittingSize = label.sizeThatFits(CGSize(width: maxSize.width, height: maxSize.height))

        // 결과 출력
        return fittingSize
    }
    
    func areDatesSameDay(_ date1: Date, _ date2: Date) -> Bool {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "Asia/Seoul")!
        return calendar.isDate(date1, inSameDayAs: date2)
    }
    
    
}
