//
//  DiaryViewController.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 3/4/25.
//

import UIKit

import FSCalendar
import RxSwift

final class DiaryViewController: UIViewController {
    
    // MARK: - Properties
    
    private let rootView = DiaryView()
    private let viewModel = DiaryViewModel()
    
    var disposeBag = DisposeBag()
    
    private let shouldShowLatestDiary: Bool

    // MARK: - Life Cycle
    
    init(shouldShowLatestDiary: Bool) {
        self.shouldShowLatestDiary = shouldShowLatestDiary
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.startLoading(withoutShading: true)
        setupDelegate()
        setupTarget()
        bindData()
        viewModel.getInitialDiaryDate()
        if shouldShowLatestDiary {
            viewModel.getLatestAndBeforeDiaries()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let offroadTabBarController = self.tabBarController as? OffroadTabBarController else { return }
        offroadTabBarController.hideTabBarAnimation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        viewModel.getDiaryTutorialChecked()
        viewModel.getLatestAndBeforeDiaries()
        viewModel.getDiaryMonthlyHexCodes()
    }
}

extension DiaryViewController {
    
    // MARK: - Func
    
    func setupCustomBackButton(buttonTitle: String) {
        rootView.customBackButton.configureButtonTitle(titleString: buttonTitle)
    }
}

private extension DiaryViewController {
    
    // MARK: - Private Method
    
    func setupDelegate() {
        rootView.diaryCalender.delegate = self
        rootView.diaryCalender.dataSource = self
    }
    
    func setupTarget() {
        rootView.customBackButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        rootView.guideButton.addTarget(self, action: #selector(guideButtonTapped), for: .touchUpInside)
        rootView.monthButton.addTarget(self, action: #selector(monthButtonTapped), for: .touchUpInside)
        rootView.leftArrowButton.addTarget(self, action: #selector(moveMonthButtonTapped(_:)), for: .touchUpInside)
        rootView.rightArrowButton.addTarget(self, action: #selector(moveMonthButtonTapped(_:)), for: .touchUpInside)
        rootView.goToChatButton.addTarget(self, action: #selector(goToChatButtonTapped), for: .touchUpInside)
    }
    
    func bindData() {
        viewModel.isCheckedTutorial
            .bind { isChecked in
                if !isChecked {
                    let diaryGuideViewController = DiaryGuideViewController()
                    diaryGuideViewController.modalPresentationStyle = .fullScreen
                    self.present(diaryGuideViewController, animated: false)
                }
            }
            .disposed(by: disposeBag)
        
        viewModel.didUpdateHexCodesData
            .bind { _ in
                if let hexCodes = self.viewModel.hexCodesOfCurrentPageData?.dailyHexCodes {
                    if !hexCodes.isEmpty {
                        self.rootView.diaryCalender.reloadData()
                    }
                }
            }
            .disposed(by: disposeBag)

        MyDiaryManager.shared.updateCalenderCurrentPage
            .bind { date in
                self.rootView.diaryCalender.setCurrentPage(date, animated: false)
            }
            .disposed(by: disposeBag)
        
        MyDiaryManager.shared.didSuccessUpdateTutorialCheckStatus
            .flatMap { _ in
                return self.viewModel.getDiaryCreateTimeAlertChecked()
            }
            .subscribe(onNext: { value in
                if !value {
                    self.showSettingDiaryTimeAlert()
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.memoryLightDataRelay
            .bind { memoryLights in
                self.rootView.leftArrowButton.alpha = self.viewModel.canMoveMonth(.previous) ? 1 : 0
                self.rootView.monthButton.isEnabled = !self.viewModel.isCurrentMonthFirstDiaryMonth()
                
                if memoryLights.isEmpty {
                    self.rootView.isDiaryEmpty(true, emptyImageUrl: self.viewModel.diaryEmptyImageUrl)
                }
                
                self.view.stopLoading()
                
                if self.shouldShowLatestDiary {
                    let memoryLightViewController = MemoryLightViewController(firstDisplayedDate: self.viewModel.memoryLightDisplayedDate, memoryLightsData: memoryLights)
                    memoryLightViewController.modalPresentationStyle = .fullScreen
                    self.present(memoryLightViewController, animated: false)
                }
            }
            .disposed(by: disposeBag)
    }
    
    func showSettingDiaryTimeAlert() {
        let alertController = ORBAlertController(title: AlertMessage.diaryTimeGuideTitle, message: AlertMessage.diaryTimeGuideMessage, type: .normal)
        alertController.configureMessageLabel{ label in
            label.setLineHeight(percentage: 150)
            label.highlightText(targetText: "설정", font: .offroad(style: .iosQuestComplete), color: .grayscale(.gray400))
            label.highlightText(targetText: "에서 일기 받을 시간을 바꿀 수 있어요.", font: .offroad(style: .iosBoxMedi), color: .grayscale(.gray400))
        }
        alertController.xButton.isHidden = true
        let cancelAction = ORBAlertAction(title: "설정", style: .cancel) { _ in
            self.viewModel.patchDiaryCreateTimeAlertCheckStatus()
            
            let diaryTimeViewController = DiaryTimeViewController()
            diaryTimeViewController.setupCustomBackButton(buttonTitle: "일기")
            self.navigationController?.pushViewController(diaryTimeViewController, animated: true)
        }
        let okAction = ORBAlertAction(title: "확인", style: .default) { _ in
            self.viewModel.patchDiaryCreateTimeAlertCheckStatus()
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
}
    
@objc private extension DiaryViewController {

    // MARK: - @objc Method
    
    func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func guideButtonTapped() {
        let diaryGuideViewController = DiaryGuideViewController()
        diaryGuideViewController.modalPresentationStyle = .fullScreen
        present(diaryGuideViewController, animated: false)
    }
    
    func monthButtonTapped() {
        let monthPickerModalViewController = MonthPickerModalViewController()
        if let sheet = monthPickerModalViewController.sheetPresentationController {
            if #available(iOS 16.0, *) {
                sheet.detents = [
                    .custom { _ in
                        return 284
                    }
                ]
            } else {
                sheet.detents = [.medium()]
            }
            sheet.prefersGrabberVisible = false
        }
        present(monthPickerModalViewController, animated: true)
    }
    
    func moveMonthButtonTapped(_ sender: UIButton) {
        var dateComponents = DateComponents()
        dateComponents.month = sender == rootView.rightArrowButton ? 1 : -1
        
        MyDiaryManager.shared.currentPageDate = Calendar(identifier: .gregorian).date(byAdding: dateComponents, to: MyDiaryManager.shared.currentPageDate)!
        rootView.diaryCalender.setCurrentPage(MyDiaryManager.shared.currentPageDate, animated: true)
    }
    
    func goToChatButtonTapped() {
        guard let orbNavigationController = navigationController as? ORBNavigationController else { return }
        orbNavigationController.pushChatLogViewController(characterId: MyInfoManager.shared.representativeCharacterID)
    }
}

//MARK: - FSCalendarDelegateAppearance

extension DiaryViewController: FSCalendarDelegateAppearance {
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        return .clear
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        let dayString = String(Calendar(identifier: .gregorian).component(.day, from: date))
        
        if viewModel.fetchDates().contains(dayString) {
            return .primary(.white)
        } else {
            return .primary(.stroke)
        }
    }

    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleSelectionColorFor date: Date) -> UIColor? {
        let dayString = String(Calendar(identifier: .gregorian).component(.day, from: date))
        
        if viewModel.fetchDates().contains(dayString) {
            return .primary(.white)
        } else {
            return .primary(.stroke)
        }
    }

    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        let currentPageDate = calendar.currentPage
        MyDiaryManager.shared.currentPageDate = currentPageDate
        let (currentPageYear, currentPageMonth) = MyDiaryManager.shared.fetchYearMonthValue(dateType: .currentPage)
        viewModel.getDiaryMonthlyHexCodes()

        rootView.monthButton.setTitle("\(currentPageYear)년 \(currentPageMonth)월", for: .normal)
        rootView.leftArrowButton.alpha = viewModel.canMoveMonth(.previous) ? 1 : 0
        rootView.rightArrowButton.alpha = viewModel.canMoveMonth(.next) ? 1 : 0
    }
}

//MARK: - FSCalendarDataSource

extension DiaryViewController: FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        guard let cell = calendar.dequeueReusableCell(withIdentifier: CustomDiaryCalendarCell.className, for: date, at: position) as? CustomDiaryCalendarCell else { return FSCalendarCell() }
        
        let dayString = String(Calendar(identifier: .gregorian).component(.day, from: date))
        
        if let colors = viewModel.fetchColorsForDate(dayString) {
            DispatchQueue.main.async {
                cell.configureMemoryLightCell(pointColorCode: colors[0].small, baseColorCode: colors[0].large)
            }
        }
        
        return cell
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let dayString = String(Calendar(identifier: .gregorian).component(.day, from: date))
        
        if viewModel.fetchDates().contains(dayString) {
            viewModel.memoryLightDisplayedDate = date
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            viewModel.getDiariesByDate(date: dateFormatter.string(from: date))
        }
    }
    
    func minimumDate(for calender: FSCalendar) -> Date {
        return MyDiaryManager.shared.minimumDate
    }
    
    func maximumDate(for calendar: FSCalendar) -> Date {
        return MyDiaryManager.shared.maximumDate
    }
}
