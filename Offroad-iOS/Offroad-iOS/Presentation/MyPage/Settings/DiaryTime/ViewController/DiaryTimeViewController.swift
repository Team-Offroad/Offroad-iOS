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
    
    private let timeStrings = (1...12).map { "\($0)" }
    private let timePeriods = ["AM", "PM"]

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

extension DiaryTimeViewController {
    
    // MARK: - Private Method
    
    private func setupDelegate() {
        rootView.timePickerView.delegate = self
        rootView.timePickerView.dataSource = self
    }
    
    private func setupTarget() {
        rootView.customBackButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - @objc Method
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

extension DiaryTimeViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return timeStrings.count
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
            label.text = "\(timeStrings[row])        00"
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
