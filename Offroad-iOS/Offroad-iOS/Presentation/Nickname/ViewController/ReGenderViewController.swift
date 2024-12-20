//
//  GenderViewController 2.swift
//  Offroad-iOS
//
//  Created by  정지원 on 12/20/24.
//
import UIKit
import SnapKit

import Then
import RxSwift
import RxCocoa

final class ReGenderViewController: UIViewController {
    
    // MARK: - Properties
    
    private let genderView = GenderView()
    private var nickname: String = ""
    private var birthYear: Int?
    private var birthMonth: Int?
    private var birthDay: Int?
    
    private let disposeBag = DisposeBag()
    
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
    }
    
    private func presentToNextVC() {
        let choosingCharacterViewController = ChoosingCharacterViewController()
        present(UINavigationController(rootViewController: choosingCharacterViewController), animated: true)
    }
    
    // MARK: - Private Methods
    
    private func setupBindings() {
        ///3개의 버튼을 클릭했을 때 동작하는 방식이 같으므로 Observable.merge로 처리
        //        Observable.merge(
        //            genderView.maleButton.rx.tap.map { Gender.male },
        //            genderView.femaleButton.rx.tap.map { Gender.female },
        //            genderView.etcButton.rx.tap.map { Gender.other }
        //        )
        //        .subscribe(onNext: { [weak self] selectedGender in
        //            self?.handleGenderSelection(selectedGender)
        //        })
        //        .disposed(by: disposeBag)
        
        //        genderView.skipButton.rx.tap
        //            .subscribe(onNext: { [weak self] in
        //                self?.navigateToChoosingCharacter(gender: nil)
        //                self?.resetGenderSelection()
        //            })
        //            .disposed(by: disposeBag)
        
        //        genderView.nextButton.rx.tap
        //            .subscribe(onNext: { [weak self] in
        //                self?.navigateToChoosingCharacter(gender: self?.selectedGender())
        //            })
        //            .disposed(by: disposeBag)
        
        /// 성별 버튼의 선택 상태를 combineLatest에서 통합적으로 처리 후 nextButton 활성화 상태를 업데이트
        ///하나라도 선택되면 true 반환
        //        Observable.combineLatest(
        //            genderView.maleButton.rx.isSelected.asObservable(),
        //            genderView.femaleButton.rx.isSelected.asObservable(),
        //            genderView.etcButton.rx.isSelected.asObservable()
        //        ) { $0 || $1 || $2 }
        //        .bind(to: genderView.nextButton.rx.isEnabled)
        //        .disposed(by: disposeBag)
        //    }
        
        // 선택된 성별 버튼의 상태를 업데이트하는 메서드
        //     func handleGenderSelection(_ selectedGender: Gender) {
        //        [genderView.maleButton, genderView.femaleButton, genderView.etcButton].forEach { button in
        //            button.isSelected = (button == selectedGender.button) // 선택된 버튼만 활성화
        //            button.layer.borderColor = button.isSelected ? UIColor.sub(.sub).cgColor : UIColor.grayscale(.gray100).cgColor // 선택 여부에 따라 테두리 색상 변경
        //        }
        //    }
        //
        //     func resetGenderSelection() {
        //        [genderView.maleButton, genderView.femaleButton, genderView.etcButton].forEach { button in
        //            button.isSelected = false // 선택 상태 초기화
        //            button.layer.borderColor = UIColor.grayscale(.gray100).cgColor
        //        }
        //        genderView.nextButton.isEnabled = false
        //    }
        
        //    private func navigateToChoosingCharacter(gender: String?) {
        //        let nextVC = ChoosingCharacterViewController(
        //            nickname: nickname,
        //            birthYear: birthYear,
        //            birthMonth: birthMonth,
        //            birthDay: birthDay,
        //            gender: gender
        //        )
        
        // 커스텀 백 버튼 설정
        //        let backButton = UIButton().then { button in
        //            button.setImage(.backBarButton, for: .normal)
        //            button.addTarget(self, action: #selector(executePop), for: .touchUpInside)
        //            button.imageView?.contentMode = .scaleAspectFill
        //            button.snp.makeConstraints { make in
        //                make.width.equalTo(30)
        //                make.height.equalTo(44)
        //            }
        //        }
        //
        //        let customBackBarButton = UIBarButtonItem(customView: backButton)
        //        nextVC.navigationItem.leftBarButtonItem = customBackBarButton
        //
        //        self.navigationController?.pushViewController(nextVC, animated: true)
        //    }
        
        //    private func selectedGender() -> String? {
        //        if genderView.maleButton.isSelected {
        //            return "MALE"
        //        } else if genderView.femaleButton.isSelected {
        //            return "FEMALE"
        //        } else if genderView.etcButton.isSelected {
        //            return "OTHER"
        //        }
        //        return nil
        //    }
        //
        
        //    @objc private func executePop() {
        //        navigationController?.popViewController(animated: true)
        //    }
        
        
        //private enum Gender {
        //    case male, female, other
        //
        //    var button: UIButton {
        //        switch self {
        //        case .male: return GenderView().maleButton
        //        case .female: return GenderView().femaleButton
        //        case .other: return GenderView().etcButton
        //        }
        //    }
        //}
    }
}
