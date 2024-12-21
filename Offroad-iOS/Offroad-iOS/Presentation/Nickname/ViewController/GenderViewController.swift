//
//  GenderViewController.swift
//  Offroad-iOS
//
//  Created by  정지원 on 7/10/24.
//

import UIKit

import SnapKit
import Then
import RxSwift
import RxCocoa

final class GenderViewController: UIViewController {
    
    // MARK: - Properties
    
    private let genderView = GenderView()
    private var nickname: String = ""
    private var birthYear: Int?
    private var birthMonth: Int?
    private var birthDay: Int?
    
    private let disposeBag = DisposeBag()
    
    // BehaviorRelay로 각 버튼 상태 관리
    private let isMaleSelected = BehaviorRelay<Bool>(value: false)
    private let isFemaleSelected = BehaviorRelay<Bool>(value: false)
    private let isOtherSelected = BehaviorRelay<Bool>(value: false)
    
    // MARK: - Life Cycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init(nickname: String, birthYear: Int?, birthMonth: Int?, birthDay: Int?) {
        self.init(nibName: nil, bundle: nil)
        
        self.nickname = nickname
        self.birthYear = birthYear
        self.birthMonth = birthMonth
        self.birthDay = birthDay
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = genderView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBindings()
        self.modalPresentationStyle = .fullScreen
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: genderView.skipButton)
    }
    
    // MARK: - Private Methods
    
    private func setupBindings() {
        ///3개의 버튼을 클릭했을 때 동작하는 방식이 같으므로 Observable.merge로 처리
        genderView.maleButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.isMaleSelected.accept(!self.isMaleSelected.value)
                self.handleGenderSelection(.male)
                self.updateNextButtonState()
            })
            .disposed(by: disposeBag)
        
        genderView.femaleButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.isFemaleSelected.accept(!self.isFemaleSelected.value)
                self.handleGenderSelection(.female)
                self.updateNextButtonState()
            })
            .disposed(by: disposeBag)
        
        genderView.etcButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.isOtherSelected.accept(!self.isOtherSelected.value)
                self.handleGenderSelection(.other)
                self.updateNextButtonState()
            })
            .disposed(by: disposeBag)
        
        /// 성별 버튼의 선택 상태를 combineLatest에서 통합적으로 처리 후 nextButton 활성화 상태를 업데이트
        /// 하나라도 선택되면 true 반환
        Observable.combineLatest(
            isMaleSelected.asObservable(),
            isFemaleSelected.asObservable(),
            isOtherSelected.asObservable()
        )
        .map { $0 || $1 || $2 } // 하나라도 true면 활성화
        .subscribe(onNext: { [weak self] isEnabled in
            guard let self = self else { return }
            let state: buttonState = isEnabled ? .isEnabled : .isDisabled
            self.genderView.nextButton.changeState(forState: state) // 상태 업데이트
        })
        .disposed(by: disposeBag)
        
        genderView.skipButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.navigateToChoosingCharacter(gender: nil)
                self?.resetGenderSelection()
            })
            .disposed(by: disposeBag)
        
        genderView.nextButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.navigateToChoosingCharacter(gender: self?.selectedGender())
            })
            .disposed(by: disposeBag)
    }
    
    //선택된 성별 버튼의 상태를 업데이트하는 메서드
    func handleGenderSelection(_ selectedGender: Gender) {
        [genderView.maleButton, genderView.femaleButton, genderView.etcButton].forEach { button in
            let isSelected = (button == selectedGender.button(in: genderView))
            button.isSelected = isSelected
            button.layer.borderColor = isSelected ? UIColor.sub(.sub).cgColor : UIColor.grayscale(.gray100).cgColor
        }
    }
    
    func updateNextButtonState() {
        let isGenderSelected = genderView.maleButton.isSelected || genderView.femaleButton.isSelected || genderView.etcButton.isSelected
        genderView.nextButton.changeState(forState: isGenderSelected ? .isEnabled : .isDisabled)
    }
    
    func resetGenderSelection() {
        [genderView.maleButton, genderView.femaleButton, genderView.etcButton].forEach { button in
            button.isSelected = false
            button.layer.borderColor = UIColor.grayscale(.gray100).cgColor
        }
        isMaleSelected.accept(false)
        isFemaleSelected.accept(false)
        isOtherSelected.accept(false)
        genderView.nextButton.changeState(forState: .isDisabled)
    }
    
    private func navigateToChoosingCharacter(gender: String?) {
        let nextVC = ChoosingCharacterViewController(
            nickname: nickname,
            birthYear: birthYear,
            birthMonth: birthMonth,
            birthDay: birthDay,
            gender: gender
        )
        
        let backButton = UIButton().then { button in
            button.setImage(.backBarButton, for: .normal)
            button.addTarget(self, action: #selector(executePop), for: .touchUpInside)
            button.imageView?.contentMode = .scaleAspectFill
            button.snp.makeConstraints { make in
                make.width.equalTo(30)
                make.height.equalTo(44)
            }
        }
        
        let customBackBarButton = UIBarButtonItem(customView: backButton)
        nextVC.navigationItem.leftBarButtonItem = customBackBarButton
        
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    private func selectedGender() -> String? {
        if isMaleSelected.value {
            return "MALE"
        } else if isFemaleSelected.value {
            return "FEMALE"
        } else if isOtherSelected.value {
            return "OTHER"
        }
        return nil
    }
    
    
    @objc private func executePop() {
        navigationController?.popViewController(animated: true)
    }
}

enum Gender {
    case male, female, other
    
    func button(in view: GenderView) -> UIButton {
        switch self {
        case .male: return view.maleButton
        case .female: return view.femaleButton
        case .other: return view.etcButton
        }
    }
}
