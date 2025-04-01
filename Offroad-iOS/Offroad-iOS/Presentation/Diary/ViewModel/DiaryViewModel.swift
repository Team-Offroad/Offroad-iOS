//
//  DiaryViewModel.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 3/11/25.
//

import Foundation

import RxSwift
import RxRelay

enum Month {
    case previous
    case next
}

final class DiaryViewModel {
    
    // MARK: - Properties
    
    var disposeBag = DisposeBag()
    
    private let calendar = Calendar(identifier: .gregorian)
    var hexCodesOfCurrentPageData: DiaryColorsData?
    var memoryLightsData = [Diary]()
    var memoryLightDisplayedDate: Date? = nil
    var diaryEmptyImageUrl = ""
    
    let isCheckedTutorial = PublishRelay<Bool>()
    let didUpdateHexCodesData = PublishRelay<Void>()
    let memoryLightDataRelay = PublishRelay<[Diary]>()
}

extension DiaryViewModel {
    
    //MARK: - Func
    
    func fetchDates() -> [String] {
        return Array(hexCodesOfCurrentPageData?.dailyHexCodes.keys ?? [:].keys)
    }
    
    func fetchColorsForDate(_ day: String) -> [ColorHex]? {
        return hexCodesOfCurrentPageData?.dailyHexCodes[day]
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
    
    //캘린더가 표현할 최소 날짜(달)이 최대 날짜(달)과 같은지 확인하는 함수
    func isCurrentMonthFirstDiaryMonth() -> Bool {
        return MyDiaryManager.shared.fetchYearMonthValue(dateType: .maximum) == MyDiaryManager.shared.fetchYearMonthValue(dateType: .minimum)
    }
    
    //MARK: - API Func
    
    func patchDiaryCreateTimeAlertCheckStatus() {
        NetworkService.shared.diarySettingService.patchDiaryCreateTimeAlertCheckStatus { response in
            switch response {
            case .success:
                print("일기 생성 시간 팝업 확인 여부 업데이트 완료")
            default:
                break
            }
        }
    }
    
    func getDiaryTutorialChecked() {
        NetworkService.shared.diarySettingService.getDiaryTutorialChecked { [weak self] response in
            guard let self else { return }
            switch response {
            case .success(let data):
                let value = data?.data.value ?? Bool()
                isCheckedTutorial.accept(value)
            default:
                break
            }
        }
    }
    
    func getDiaryCreateTimeAlertChecked() -> Observable<Bool> {
        return Observable.create { observer in
            NetworkService.shared.diarySettingService.getDiaryCreateTimeAlertChecked { response in
                switch response {
                case .success(let data):
                    let value = data?.data.value ?? false
                    observer.onNext(value)
                    observer.onCompleted()
                default:
                    return
                }
            }
            return Disposables.create()
        }
    }
    
    func getInitialDiaryDate() {
        var dateComponents = DateComponents()

        NetworkService.shared.diaryService.getInitialDiaryDate { response in
            switch response {
            case .success(let data):
                dateComponents.year = data?.data.year
                dateComponents.month = data?.data.month
                dateComponents.day = data?.data.day
                MyDiaryManager.shared.minimumDate = self.calendar.date(from: dateComponents) ?? Date()
            default:
                break
            }
        }
    }
    
    func getDiaryMonthlyHexCodes() {
        let (year, month) = MyDiaryManager.shared.fetchYearMonthValue(dateType: .currentPage)
        
        NetworkService.shared.diaryService.getDiaryMonthlyHexCodes(year: year, month: month) { response in
            switch response {
            case .success(let dto):
                guard let dto else { return }
                self.hexCodesOfCurrentPageData = dto.data
                self.didUpdateHexCodesData.accept(())
            default:
                break
            }
        }
    }
    
    func getLatestAndBeforeDiaries() {
        memoryLightDisplayedDate = nil
        
        //previousCount == nil이면 서버 내부에서 1로 자동 처리됨
        NetworkService.shared.diaryService.getLatestAndBeforeDiaries(previousCount: nil) { response in
            switch response {
            case .success(let dto):
                guard let dto else { return }
                self.diaryEmptyImageUrl = dto.data.emptyImageUrl ?? ""
                self.memoryLightsData = []
                self.memoryLightsData = dto.data.previousDiaries
                if let latestDiary = dto.data.latestDiary {
                    self.memoryLightsData.append(latestDiary)
                }
                self.memoryLightDataRelay.accept(self.memoryLightsData)
            default:
                break
            }
        }
    }
    
    //previousCount, nextCount == nil이면 서버 내부에서 1로 자동 처리됨
    func getDiariesByDate(date: String) {
        NetworkService.shared.diaryService.getDiariesByDate(date: date, previousCount: nil, nextCount: nil) { response in
            switch response {
            case .success(let dto):
                guard let dto else { return }
                self.memoryLightsData = []
                self.memoryLightsData = dto.data.previousDiaries.reversed()
                self.memoryLightsData.append(dto.data.targetDiary)
                self.memoryLightsData.append(contentsOf: dto.data.nextDiaries)
                self.memoryLightDataRelay.accept(self.memoryLightsData)
            default:
                break
            }
        }
    }
}
