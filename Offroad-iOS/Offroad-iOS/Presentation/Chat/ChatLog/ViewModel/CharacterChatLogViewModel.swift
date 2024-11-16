//
//  CharacterChatLogViewModel.swift
//  Offroad-iOS
//
//  Created by 김민성 on 11/16/24.
//

import UIKit

final class CharacterChatLogViewModel {
    
    func groupChatsByDate(chats: [ChatDataModel]) -> [[ChatDataModel]] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        var groupedChats: [String: [ChatDataModel]] = [:]
        for chat in chats {
            guard let createdDate = chat.createdDate else { continue }
            let dateKey = dateFormatter.string(from: createdDate) // 날짜만 추출
            if groupedChats[dateKey] == nil {
                groupedChats[dateKey] = []
            }
            groupedChats[dateKey]?.append(chat)
        }
        let sortedKeys = groupedChats.keys.sorted()
        return sortedKeys.compactMap { groupedChats[$0] }
    }
    
    // UILabel 안에 특정 텍스트가 들어갔을 때, label의 사이즈를 미리 계산하는 식
    // (셀을 직접 그리기 전에 셀의 높이를 동적으로 계산하여 flowLayout에서 이를 바탕으로 layout계산해야 하기 때문.)
    // 채팅 내용에 따라 텍스트의 높이가 달라지기 때문에 특정 텍스트일 때 채팅 버블의 높이를 미리 계산하기 위함.
    func calculateTextSize(text: String, font: UIFont, maxSize: CGSize) -> CGSize {
        // 텍스트 속성 설정
        let attributes: [NSAttributedString.Key: Any] = [.font: font]
        // 제한된 너비를 설정한 CGRect
        let maxSize = maxSize
        // boundingRect 계산
        let boundingBox = text.boundingRect(
            with: maxSize,
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: attributes,
            context: nil
        )
        return CGSize(width: ceil(boundingBox.width), height: ceil(boundingBox.height))
    }
    
}
