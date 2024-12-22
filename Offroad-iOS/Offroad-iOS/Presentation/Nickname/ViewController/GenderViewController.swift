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
        setupNavigationBar()
    }
    
    // MARK: - Private Methods
    
    private func setupNavigationBar() {
        let backButton = UIButton().then {
            $0.setImage(.backBarButton, for: .normal)
            $0.addTarget(self, action: #selector(executePop), for: .touchUpInside)
            $0.imageView?.contentMode = .scaleAspectFill
            $0.snp.makeConstraints { make in
                make.width.equalTo(30)
                make.height.equalTo(44)
            }
        }
        let customBackBarButton = UIBarButtonItem(customView: backButton)
        customBackBarButton.tintColor = .black
        navigationItem.leftBarButtonItem = customBackBarButton
    }
    
    private func setupBindings() {
        genderView.maleButton.rx.tap
                    .subscribe(onNext: { [weak self] in
                        guard let self = self else { return }
                        self.toggleGenderSelection(for: .male)
                    })
                    .disposed(by: disposeBag)
                
                genderView.femaleButton.rx.tap
                    .subscribe(onNext: { [weak self] in
                        guard let self = self else { return }
                        self.toggleGenderSelection(for: .female)
                    })
                    .disposed(by: disposeBag)
                
                genderView.etcButton.rx.tap
                    .subscribe(onNext: { [weak self] in
                        guard let self = self else { return }
                        self.toggleGenderSelection(for: .other)
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
            self.genderView.nextButton.changeState(forState: state)
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
    private func toggleGenderSelection(for gender: Gender) {
            switch gender {
            case .male:
                isMaleSelected.accept(!isMaleSelected.value)
                isFemaleSelected.accept(false)
                isOtherSelected.accept(false)
            case .female:
                isMaleSelected.accept(false)
                isFemaleSelected.accept(!isFemaleSelected.value)
                isOtherSelected.accept(false)
            case .other:
                isMaleSelected.accept(false)
                isFemaleSelected.accept(false)
                isOtherSelected.accept(!isOtherSelected.value)
            }
            updateGenderButtonStates()
        }
    
    private func updateGenderButtonStates() {
            // 각 버튼의 isSelected 상태와 borderColor를 BehaviorRelay 값에 따라 업데이트
            genderView.maleButton.isSelected = isMaleSelected.value
            genderView.maleButton.layer.borderColor = isMaleSelected.value ? UIColor.sub(.sub).cgColor : UIColor.grayscale(.gray100).cgColor
            
            genderView.femaleButton.isSelected = isFemaleSelected.value
            genderView.femaleButton.layer.borderColor = isFemaleSelected.value ? UIColor.sub(.sub).cgColor : UIColor.grayscale(.gray100).cgColor
            
            genderView.etcButton.isSelected = isOtherSelected.value
            genderView.etcButton.layer.borderColor = isOtherSelected.value ? UIColor.sub(.sub).cgColor : UIColor.grayscale(.gray100).cgColor
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
