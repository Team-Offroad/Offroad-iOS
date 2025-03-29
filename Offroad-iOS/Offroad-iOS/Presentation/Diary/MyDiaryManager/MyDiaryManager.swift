//
//  MyDiaryManager.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 3/11/25.
//

import UIKit

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
    let didSuccessUpdateTutorialCheckStatus = PublishRelay<Void>()
    let didUpdateLatestDiaryInfo = PublishRelay<Void>()
    let didCompleteCreateDiary = PublishRelay<Void>()
    
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
    
    func showCompleteCreateDiaryAlert(viewController: UIViewController) {
        let alertController = ORBAlertController(title: DiaryMessage.completeCreateDiaryTitle, message: DiaryMessage.completeCreateDiaryMessage, type: .normal)
        alertController.configureMessageLabel{ label in
            label.setLineHeight(percentage: 150)
        }
        alertController.xButton.isHidden = true
        let cancelAction = ORBAlertAction(title: "나중에", style: .cancel) { _ in return }
        let okAction = ORBAlertAction(title: "확인", style: .default) { _ in
            let diaryViewController = DiaryViewController(shouldShowLatestDiary: true)
            diaryViewController.setupCustomBackButton(buttonTitle: "")
            viewController.navigationController?.pushViewController(diaryViewController, animated: true)
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        
        viewController.present(alertController, animated: true)
    }
}
