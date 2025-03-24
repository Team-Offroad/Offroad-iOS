//
//  DiaryTimeViewController.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 2/17/25.
//

import UIKit

final class DiaryTimeViewController: UIViewController {
    
    // MARK: - Properties
    
    private let rootView = DiaryTimeView()
    
    private let times = Array(1...12)
    private let timePeriods = TimePeriod.allCases
    
    // MARK: - Life Cycle
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDelegate()
        setupTarget()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let offroadTabBarController = self.tabBarController as? OffroadTabBarController else { return }
        offroadTabBarController.hideTabBarAnimation()
    }
    
    override func viewWillLayoutSubviews() {
        rootView.timePickerView.subviews[1].isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
}

private extension DiaryTimeViewController {
    
    // MARK: - Private Method
    
    func setupDelegate() {
        rootView.timePickerView.delegate = self
        rootView.timePickerView.dataSource = self
        
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    func setupTarget() {
        rootView.customBackButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        rootView.completeButton.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
    }
    
    func showExitAlertView() {
        let alertController = ORBAlertController(message: AlertMessage.diaryTimeUnsavedExitMessage, type: .messageOnly)
        alertController.configureMessageLabel{ label in
            label.setLineHeight(percentage: 150)
        }
        alertController.xButton.isHidden = true
        let cancelAction = ORBAlertAction(title: "아니요", style: .cancel) { _ in return }
        let okAction = ORBAlertAction(title: "네", style: .default) { _ in
            self.navigationController?.popViewController(animated: true)
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        
        present(alertController, animated: true)
    }
    
    func patchDiaryCreateTime(hour: Int) {
        NetworkService.shared.diarySettingService.patchDiaryCreateTime(parameter: hour) { response in
            switch response {
            case .success:
                print("일기 생성 시간 업데이트 완료")
            default:
                break
            }
            
        }
    }
}

extension DiaryTimeViewController {
    
    // MARK: - Func
    
    func setupCustomBackButton(buttonTitle: String) {
        rootView.customBackButton.configureButtonTitle(titleString: buttonTitle)
    }
}
    
@objc private extension DiaryTimeViewController {

    // MARK: - @objc Method
    
    func backButtonTapped() {
        showExitAlertView()
    }
    
    func completeButtonTapped() {
        let selectedTime = times[rootView.timePickerView.selectedRow(inComponent: 0)]
        let selectedTimePeriod = timePeriods[rootView.timePickerView.selectedRow(inComponent: 1)]
        let convertedTime = selectedTime == 12 ? 0 : selectedTime
        let selectedTimeResult = selectedTimePeriod.rawValue == "AM" ? convertedTime : convertedTime + 12

        let alertController = ORBAlertController(title: AlertMessage.diaryTimeSettinTitle(selectedTimePeriod: selectedTimePeriod, selectedTime: selectedTime), message: AlertMessage.diaryTimeSettingMessage, type: .normal)
        alertController.configureMessageLabel{ label in
            label.setLineHeight(percentage: 150)
        }
        alertController.xButton.isHidden = true
        let cancelAction = ORBAlertAction(title: "아니요", style: .cancel) { _ in return }
        let okAction = ORBAlertAction(title: "네", style: .default) { _ in
            self.patchDiaryCreateTime(hour: selectedTimeResult)
            self.navigationController?.popViewController(animated: true)
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
}

//MARK: - UIGestureRecognizerDelegate

extension DiaryTimeViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        showExitAlertView()
        return false
    }
}

//MARK: - UIPickerViewDataSource

extension DiaryTimeViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return times.count
        } else {
            return timePeriods.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 34
    }
}

//MARK: - UIPickerViewDelegate

extension DiaryTimeViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let label = UILabel()
        label.textAlignment = .right
        
        let selectedRow = pickerView.selectedRow(inComponent: component)
                
        if row == selectedRow {
            label.font = .offroad(style: .iosTextTitle)
            label.textColor = .main(.main2)
        } else {
            label.font = UIFont.pretendardFont(ofSize: 22, weight: .regular)
            label.textColor = .grayscale(.gray300)
        }
        
        if component == 0  {
            label.text = "\(times[row])        00"
        } else {
            label.text = timePeriods[row].rawValue
        }
        
        return label
    }

    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        if component == 0 {
            return 100
        } else {
            return 60
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerView.reloadComponent(component)
    }
}
