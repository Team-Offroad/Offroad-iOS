//
//  MemoryLightViewModel.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 3/20/25.
//

import Foundation

final class MemoryLightViewModel {
    
    //MARK: - Properties
    
    var displayedDate: Date? = nil
    var memoryLightsData: [Diary] = []
}

extension MemoryLightViewModel {
    
    //MARK: - MARK
    
    func diaryForDate(date: Date) -> Diary {
        let calendar = Calendar(identifier: .gregorian)
        let targetYear = calendar.component(.year, from: date)
        let targetMonth = calendar.component(.month, from: date)
        let targetDay = calendar.component(.day, from: date)
        
        return memoryLightsData.filter { $0.year == targetYear && $0.month == targetMonth && $0.day == targetDay }.first ?? memoryLightsData[0]
    }
    
    func indexforDiary(diary: Diary) -> Int {
        return memoryLightsData.firstIndex { $0.id == diary.id } ?? 0
    }
    
    //MARK: - API Func
    
    func patchDiaryCheck(date: String) {
        NetworkService.shared.diaryService.patchDiaryCheck(date: date) { response in
            switch response {
            case .success:
                print("일기 확인 여부 업데이트 완료")
                MyDiaryManager.shared.didUpdateLatestDiaryInfo.accept(())
            default:
                break
            }
        }
    }
}
