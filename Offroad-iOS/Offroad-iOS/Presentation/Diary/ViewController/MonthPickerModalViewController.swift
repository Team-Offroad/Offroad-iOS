//
//  MonthPickerModelViewController.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 3/11/25.
//

import UIKit

import RxSwift

final class MonthPickerModalViewController: UIViewController {
    
    // MARK: - Properties
    
    private let rootView = MonthPickerModalView()
    
    private let currentYear = 2025
    private let currentMonth = 3
    
    private let minimumYear = 2024
    private let minimumMonth = 11
    
    private lazy var years = Array(minimumYear...currentYear)
    private let months = Array(1...12)
    
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
        rootView.monthPickerView.subviews[1].isHidden = true
    }
}

private extension MonthPickerModalViewController {
    
    // MARK: - Private Method
    
    func setupDelegate() {
        rootView.monthPickerView.delegate = self
        rootView.monthPickerView.dataSource = self
    }
    
    func setupTarget() {
        rootView.completeButton.addTarget(self, action: #selector(completeTapped), for: .touchUpInside)
    }
}

extension MonthPickerModalViewController {
    
    // MARK: - Func
    
    func setupCustomBackButton(buttonTitle: String) {
    }
}
    
@objc private extension MonthPickerModalViewController {

    // MARK: - @objc Method
    
    func completeTapped() {
        var dateComponents = DateComponents()
        dateComponents.year = years[rootView.monthPickerView.selectedRow(inComponent: 0)]
        dateComponents.month = months[rootView.monthPickerView.selectedRow(inComponent: 1)]
        
        let selectedDate = Calendar.current.date(from: dateComponents)!
        MyDiaryManager.shared.updateCalenderCurrentPage.accept(selectedDate)
        
        dismiss(animated: true)
    }
}

extension MonthPickerModalViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return years.count
        } else {
            return months.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 34
    }
}
 
extension MonthPickerModalViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let label = UILabel()
        label.textAlignment = .left

        let selectedRow = pickerView.selectedRow(inComponent: component)
                
        if row == selectedRow {
            label.font = .offroad(style: .iosTextTitle)
            label.textColor = .main(.main2)
        } else {
            label.font = UIFont.pretendardFont(ofSize: 22, weight: .regular)
            label.textColor = .grayscale(.gray300)
        }
        
        if component == 0  {
            label.text = "\(years[row])년"
        } else {
            label.text = "\(months[row])월"
        }
        
        return label
    }

    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        if component == 0 {
            return 90
        } else {
            return 50
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerView.reloadComponent(component)
    }
}
