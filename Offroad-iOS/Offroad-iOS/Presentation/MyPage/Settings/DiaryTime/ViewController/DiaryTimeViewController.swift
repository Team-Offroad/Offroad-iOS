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
    
    private let times = (1...12).map { $0 }
    private let timePeriods = ["AM", "PM"]
    
    private var selectedTime = Int()

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
}

private extension DiaryTimeViewController {
    
    // MARK: - Private Method
    
    func setupDelegate() {
        rootView.timePickerView.delegate = self
        rootView.timePickerView.dataSource = self
    }
    
    func setupTarget() {
        rootView.customBackButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        rootView.completeButton.addTarget(self, action: #selector(completeTapped), for: .touchUpInside)
    }
}
    
@objc private extension DiaryTimeViewController {

    // MARK: - @objc Method
    
    func backButtonTapped() {
        let alertController = ORBAlertController(message: "일기 시간 설정을 저장하지 않고\n나가시겠어요?", type: .messageOnly)
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
    
    func completeTapped() {
        let selectedTime = times[rootView.timePickerView.selectedRow(inComponent: 0)]
        let selectedTimePeriod = timePeriods[rootView.timePickerView.selectedRow(inComponent: 1)]
        
//        서버 통신 시에 전송할 값
//        let convertedTime = selectedTime == 12 ? 0 : selectedTime
//        let selectedTimeResult = selectedTimePeriod == "AM" ? convertedTime : convertedTime + 12
//        print(selectedTimeResult)

        let alertController = ORBAlertController(title: "\(selectedTimePeriod == "AM" ? "오전" : "오후") \(selectedTime)시", message: "매일 이 시간에 일기를 받으시겠어요?", type: .normal)
        alertController.configureMessageLabel{ label in
            label.setLineHeight(percentage: 150)
        }
        alertController.xButton.isHidden = true
        let cancelAction = ORBAlertAction(title: "아니요", style: .cancel) { _ in return }
        let okAction = ORBAlertAction(title: "네", style: .default) { _ in return }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
}

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
            label.text = timePeriods[row]
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
