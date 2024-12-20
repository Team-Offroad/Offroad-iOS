//
//  BirthViewController 2.swift
//  Offroad-iOS
//
//  Created by  정지원 on 12/20/24.
//


import UIKit

import SnapKit
import Then
import RxSwift
import RxCocoa

final class ReBirthViewController: UIViewController {

    // MARK: - Properties

    private let birthView = BirthView()
    private let disposeBag = DisposeBag()
    private var nickname: String = ""

    // MARK: - Life Cycle

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }

    convenience init(nickname: String) {
        self.init(nibName: nil, bundle: nil)
        self.nickname = nickname
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = birthView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
    }

    // MARK: - Private Methods

    private func setupBindings() {
        // 연도, 월, 일 각각의 입력값 검증
        let yearValidation = birthView.yearTextField.rx.text.orEmpty
            .map { self.validateYear($0) }
            .share(replay: 1) // 결과를 다른 곳에서도 재사용 가능하도록 설정

        let monthValidation = birthView.monthTextField.rx.text.orEmpty
            .map { self.validateMonth($0) }
            .share(replay: 1)

        let dayValidation = birthView.dayTextField.rx.text.orEmpty
            .map { self.validateDay($0) }
            .share(replay: 1)

        // 모든 검증 결과를 통합하여 버튼 활성화 설정
        Observable.combineLatest(yearValidation, monthValidation, dayValidation) { $0 && $1 && $2 }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] isValid in
                self?.birthView.nextButton.isEnabled = isValid
                self?.updateTextFieldBorders(isValid: isValid)
            })
            .disposed(by: disposeBag)

        birthView.nextButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.navigateToGenderVC()
            })
            .disposed(by: disposeBag)

        birthView.skipButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.skipButtonTapped()
            })
            .disposed(by: disposeBag)

        // 터치 이벤트로 키보드 숨기기
        let tapGesture = UITapGestureRecognizer()
        view.addGestureRecognizer(tapGesture)
        tapGesture.rx.event
            .subscribe(onNext: { [weak self] _ in
                self?.view.endEditing(true)
            })
            .disposed(by: disposeBag)
    }

    private func validateYear(_ yearText: String) -> Bool {
        guard let year = Int(yearText) else { return false }
        let currentYear = Calendar.current.component(.year, from: Date())
        return year >= 1900 && year <= currentYear
    }

    private func validateMonth(_ monthText: String) -> Bool {
        guard let month = Int(monthText) else { return false }
        return month >= 1 && month <= 12
    }

    private func validateDay(_ dayText: String) -> Bool {
        guard let day = Int(dayText) else { return false }
        return day >= 1 && day <= 31
    }

    private func navigateToGenderVC() {
//        let nextVC = GenderViewController(
//            nickname: nickname,
//            birthYear: Int(birthView.yearTextField.text ?? 0),
//            birthMonth: Int(birthView.monthTextField.text ?? 0),
//            birthDay: Int(birthView.dayTextField.text ?? 0)
//        )
//        navigationController?.pushViewController(nextVC, animated: true)
    }


     func validateYear() -> Bool {
        guard let yearText = birthView.yearTextField.text, let year = Int(yearText) else {
            return false
        }
        
        let currentYear = Calendar.current.component(.year, from: Date())
        
        if year < 1900 || year > currentYear {
            return false
        }
        birthView.notionLabel.text = ""
        return true
    }
    
     func validateMonth() -> Bool {
        guard let monthText = birthView.monthTextField.text, let month = Int(monthText), month >= 1 && month <= 12 else {
            return false
        }
        
        let currentYear = Calendar.current.component(.year, from: Date())
        let currentMonth = Calendar.current.component(.month, from: Date())
        
        if let yearText = birthView.yearTextField.text, let year = Int(yearText) {
            if year == currentYear && month > currentMonth {
                return false
            }
        }
        birthView.notionLabel.text = ""
        return true
    }
    
     func validateDay() -> Bool {
        if birthView.yearTextField.text?.isEmpty == true || birthView.monthTextField.text?.isEmpty == true {
            if let dayText = birthView.dayTextField.text, let day = Int(dayText) {
                return day >= 1 && day <= 31
            }
            return false
        }
        
        guard let yearText = birthView.yearTextField.text, let year = Int(yearText),
              let monthText = birthView.monthTextField.text, let month = Int(monthText),
              let dayText = birthView.dayTextField.text, let day = Int(dayText) else {
            return false
        }
        
        if day < 1 || day > 31 {
            return false
        }
        
        switch month {
        case 4, 6, 9, 11:
            if day > 30 {
                return false
            }
        case 2:
            if day > (isLeapYear(year) ? 29 : 28) {
                return false
            }
        default:
            if day > 31 {
                return false
            }
        }
        
        let currentYear = Calendar.current.component(.year, from: Date())
        let currentMonth = Calendar.current.component(.month, from: Date())
        let currentDay = Calendar.current.component(.day, from: Date())
        
        if year == currentYear && month == currentMonth && day > currentDay {
            birthView.notionLabel.text = ErrorMessages.birthDateError
            return false
        }
        
        birthView.notionLabel.text = ""
        return true
    }
    
    private func isLeapYear(_ year: Int) -> Bool {
        return (year % 4 == 0 && year % 100 != 0) || year % 400 == 0
    }

    private func updateTextFieldBorders(isValid: Bool) {
        let color: CGColor = isValid ? UIColor.grayscale(.gray100).cgColor : UIColor.primary(.errorNew).cgColor
        birthView.yearTextField.layer.borderColor = color
        birthView.monthTextField.layer.borderColor = color
        birthView.dayTextField.layer.borderColor = color
    }

    private func skipButtonTapped() {
        let genderVC = GenderViewController(nickname: nickname, birthYear: nil, birthMonth: nil, birthDay: nil)
        navigationController?.pushViewController(genderVC, animated: true)
        resetBirthFields()
    }

    private func resetBirthFields() {
        birthView.yearTextField.text = ""
        birthView.monthTextField.text = ""
        birthView.dayTextField.text = ""
    }
}
