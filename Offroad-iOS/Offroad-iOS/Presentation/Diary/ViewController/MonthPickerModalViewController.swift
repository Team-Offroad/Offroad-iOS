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
    
    private let (minYear, minMonth) = MyDiaryManager.shared.fetchYearMonthValue(dateType: .minimum)
    private let (maxYear, maxMonth) = MyDiaryManager.shared.fetchYearMonthValue(dateType: .maximum)
    private let (currentPageYear, currentPageMonth) = MyDiaryManager.shared.fetchYearMonthValue(dateType: .currentPage)
    
    private lazy var selectedYear = currentPageYear
    private lazy var selectedMonth = currentPageMonth

    private lazy var years = Array(minYear...maxYear)
    private lazy var months: [Int] = {
        if currentPageYear == maxYear {
            return Array(1...maxMonth)
        } else if currentPageYear == minYear {
            return Array(minMonth...12)
        } else {
            return Array(1...12)
        }
    }()
    
    // MARK: - Life Cycle
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDelegate()
        setupTarget()
        setupPickerView()
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
    
    func setupPickerView() {
        let selectedYearRow = years.firstIndex(of: currentPageYear)!
        let selectedMonthRow = months.firstIndex(of: currentPageMonth)!
        
        selectedYear = years[selectedYearRow]
        selectedMonth = months[selectedMonthRow]
        
        DispatchQueue.main.async {
            self.rootView.monthPickerView.selectRow(selectedYearRow, inComponent: 0, animated: false)
            self.rootView.monthPickerView.selectRow(selectedMonthRow, inComponent: 1, animated: false)
        }
    }
}
    
@objc private extension MonthPickerModalViewController {

    // MARK: - @objc Method
    
    func completeTapped() {
        var dateComponents = DateComponents()
        dateComponents.year = selectedYear
        dateComponents.month = selectedMonth
        
        if let selectedDate = Calendar(identifier: .gregorian).date(from: dateComponents) {
            MyDiaryManager.shared.updateCalenderCurrentPage.accept(selectedDate)
        }
        
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
        
        if component == 0  {
            label.text = "\(years[row])년"
            if years[row] == selectedYear {
                label.font = .offroad(style: .iosTextTitle)
                label.textColor = .main(.main2)
            } else {
                label.font = UIFont.pretendardFont(ofSize: 22, weight: .regular)
                label.textColor = .grayscale(.gray300)
            }
        } else {
            label.text = "\(months[row])월"
            if months[row] == selectedMonth {
                label.font = .offroad(style: .iosTextTitle)
                label.textColor = .main(.main2)
            } else {
                label.font = UIFont.pretendardFont(ofSize: 22, weight: .regular)
                label.textColor = .grayscale(.gray300)
            }
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

        if component == 0 {
            selectedYear = years[row]

            if years[row] == maxYear {
                months = Array(1...maxMonth)
                pickerView.reloadComponent(1)
                pickerView.selectRow(months.firstIndex(of: selectedMonth) ?? maxMonth - 1, inComponent: 1, animated: false)
            } else if years[row] == minYear {
                months = Array(minMonth...12)
                pickerView.reloadComponent(1)
                pickerView.selectRow(months.firstIndex(of: selectedMonth) ?? 0, inComponent: 1, animated: false)
            } else {
                months = Array(1...12)
                pickerView.reloadComponent(1)
                pickerView.selectRow(months.firstIndex(of: selectedMonth) ?? 0, inComponent: 1, animated: false)
            }
            selectedMonth = months[pickerView.selectedRow(inComponent: 1)]
            pickerView.reloadAllComponents()
        } else {
            selectedMonth = months[row]
            pickerView.reloadComponent(component)
        }
    }
}
