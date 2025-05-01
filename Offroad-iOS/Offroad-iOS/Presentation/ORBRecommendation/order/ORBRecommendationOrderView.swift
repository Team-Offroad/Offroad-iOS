//
//  ORBRecommendationOrderView.swift
//  Offroad-iOS
//
//  Created by 김민성 on 4/26/25.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit
import Then

final class ORBRecommendationOrderView: UIView {
    
    // MARK: - Properties
    
    enum OrderPlaceCategory {
        case restaurant
        case caffe
    }
    
    private let scrollingAnimator = UIViewPropertyAnimator(duration: 0.5, dampingRatio: 1)
    private let selectedPlaceCategory: BehaviorRelay<OrderPlaceCategory?> = .init(value: nil)
    private let placeDescription: BehaviorRelay<String> = .init(value: "")
    private let additionalOrder: BehaviorRelay<String> = .init(value: "")
    
    private var actionBindingDisposeBag = DisposeBag()
    private var dataBindingDisposeBag = DisposeBag()
    private lazy var textViewHeightConstraint = answer3TextView.heightAnchor.constraint(equalToConstant: 224)
    
    // MARK: - UI Properties
    
    private let navigationBar = UIView()
    private(set) var backButton = NavigationPopButton()
    private let titleLabel = UILabel()
    private let divider = UIView()
    private let scrollView = UIScrollView()
    private let question1Label = UILabel()
    private let buttonRestaurant = ShrinkableButton()
    private let buttonCaffe = ShrinkableButton()
    private let buttonStack = UIStackView()
    private let answer1RequiredLabel = UILabel()
    private let question1Stack = UIStackView()
    private let question2Label = UILabel()
    private let answer2TextField = UITextField()
    private let answer2RequiredLabel = UILabel()
    private let question2Stack = UIStackView()
    private let question3Label = UILabel()
    private let answer3TextView = UITextView()
    private let characterCountLabel = UILabel()
    private let question3Stack = UIStackView()
    private let resetOrderButton = ShrinkableButton()
    private let completeButton = ShrinkableButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupStyle()
        setupHierarchy()
        setupLayout()
        bindData()
        bindActions()
        setupDelegate()
        setupNotification()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// Initial Settings
private extension ORBRecommendationOrderView {
    
    func setupStyle() {
        backgroundColor = .main(.main1)
        navigationBar.backgroundColor = .main(.main1)
        
        titleLabel.do { label in
            label.text = ORBRecommendationOrderText.title
            label.font = .offroad(style: .iosTextBold)
            label.textAlignment = .center
            label.textColor = .main(.main2)
        }
        
        divider.backgroundColor = .grayscale(.gray100)
        
        scrollView.delaysContentTouches = false
        
        question1Label.do { label in
            label.text = ORBRecommendationOrderText.question1
            label.font = .offroad(style: .iosTextBold)
            label.textColor = .main(.main2)
        }
        
        buttonRestaurant.setTitle("식당", for: .normal)
        buttonCaffe.setTitle("카페", for: .normal)
        [buttonRestaurant, buttonCaffe].forEach {
            $0.roundCorners(cornerRadius: 22)
            $0.layer.borderColor = UIColor.grayscale(.gray200).cgColor
            $0.configuration = UIButton.Configuration.plain()
            $0.configurationUpdateHandler = { button in
                let isSelected = button.state.contains(.selected)
                button.layer.borderWidth = isSelected ? 0 : 1
                button.backgroundColor = isSelected ? .sub(.sub) : .main(.main3)
                button.configuration?.baseForegroundColor = isSelected ? .main(.main3) : .grayscale(.gray300)
            }
        }
        
        buttonStack.do { stackView in
            stackView.addArrangedSubviews(buttonRestaurant, buttonCaffe)
            stackView.axis = .horizontal
            stackView.spacing = 9
            stackView.alignment = .fill
            stackView.distribution = .fillEqually
        }
        
        answer1RequiredLabel.do { label in
            label.text = ORBRecommendationOrderText.answer1RequiredMessage
            label.font = .offroad(style: .iosHint)
            label.textColor = .primary(.errorNew)
        }
        
        question1Stack.do { stackView in
            stackView.addArrangedSubviews(question1Label, buttonStack, answer1RequiredLabel)
            stackView.axis = .vertical
            stackView.spacing = 14
            stackView.setCustomSpacing(12, after: buttonStack)
            stackView.alignment = .fill
            stackView.distribution = .fill
        }
        
        question2Label.do { label in
            label.text = ORBRecommendationOrderText.question2
            label.font = .offroad(style: .iosTextBold)
            label.textColor = .main(.main2)
        }
        
        answer2TextField.do { textField in
            textField.font = .offroad(style: .iosTextAuto)
            textField.textColor = .main(.main2)
            textField.backgroundColor = .main(.main3)
            textField.layer.borderColor = UIColor.grayscale(.gray100).cgColor
            textField.layer.borderWidth = 1
            textField.leftView = UIView(frame: .init(x: 0, y: 0, width: 12, height: 0))
            textField.rightView = UIView(frame: .init(x: 0, y: 0, width: 12, height: 0))
            textField.leftViewMode = .always
            textField.rightViewMode = .always
            textField.attributedPlaceholder = .init(
                string: ORBRecommendationOrderText.answer2Placeholder,
                attributes: [.foregroundColor: UIColor.grayscale(.gray300)]
            )
            textField.roundCorners(cornerRadius: 5)
        }
        
        answer2RequiredLabel.do { label in
            label.text = ORBRecommendationOrderText.answer2RequiredMessage
            label.font = .offroad(style: .iosHint)
            label.textColor = .primary(.errorNew)
        }
        
        question2Stack.do { stackView in
            stackView.addArrangedSubviews(question2Label, answer2TextField, answer2RequiredLabel)
            stackView.axis = .vertical
            stackView.spacing = 14
            stackView.setCustomSpacing(12, after: answer2TextField)
            stackView.alignment = .fill
            stackView.distribution = .fill
        }
        
        question3Label.do { label in
            label.text = ORBRecommendationOrderText.question3
            label.font = .offroad(style: .iosTextBold)
            label.textColor = .main(.main2)
        }
        
        answer3TextView.do { textView in
            textView.backgroundColor = .main(.main3)
            textView.font = .offroad(style: .iosText)
            textView.textColor = .main(.main2)
            textView.layer.borderColor = UIColor.grayscale(.gray100).cgColor
            textView.layer.borderWidth = 1
            textView.roundCorners(cornerRadius: 5)
        }
        
        characterCountLabel.do { label in
            label.font = .offroad(style: .iosHint)
            label.textAlignment = .right
            label.textColor = .grayscale(.gray400)
            label.highlightText(targetText: "/200", color: .grayscale(.gray300))
        }
        
        question3Stack.do { stackView in
            stackView.addArrangedSubviews(question3Label, answer3TextView)
            stackView.axis = .vertical
            stackView.spacing = 14
            stackView.alignment = .fill
            stackView.distribution = .fill
        }
        
        resetOrderButton.do { button in
            button.roundCorners(cornerRadius: 8)
            button.configuration = UIButton.Configuration.plain()
            button.configuration?.title = "주문서 초기화"
            button.configuration?.baseBackgroundColor = .clear
            button.configuration?.baseForegroundColor = .grayscale(.gray400)
            button.configuration?.image = .icnReloadArrow.imageFlippedForRightToLeftLayoutDirection()
            button.configuration?.imagePlacement = .trailing
            button.configuration?.imagePadding = 8
            button.configurationUpdateHandler = { button in
                let isHighlighted = button.state == .highlighted
                button.backgroundColor = isHighlighted ? .grayscale(.gray100).withAlphaComponent(0.5) : .clear
            }
        }
        
        completeButton.do { button in
            button.setTitle("주문서 작성 완료", for: .normal)
            button.setTitleColor(.main(.main1), for: .normal)
            button.setTitleColor(.main(.main1), for: .highlighted)
            button.setTitleColor(.main(.main1), for: .disabled)
            button.configureBackgroundColorWhen(normal: .main(.main2), disabled: .blackOpacity(.black15))
            button.roundCorners(cornerRadius: 5)
            button.isEnabled = false
        }
    }
    
    func setupHierarchy() {
        addSubviews(navigationBar, scrollView, completeButton)
        navigationBar.addSubviews(divider, titleLabel, backButton)
        scrollView.addSubviews(
            question1Stack,
            question2Stack,
            question3Stack,
            resetOrderButton
        )
        answer3TextView.addSubview(characterCountLabel)
    }
    
    func setupLayout() {
        navigationBar.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(44)
        }
        
        backButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(8)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        divider.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide)
            make.bottom.equalTo(completeButton.snp.top)
        }
        
        buttonStack.snp.makeConstraints { make in
            make.height.equalTo(44)
        }
        
        question1Stack.snp.makeConstraints { make in
            make.top.equalTo(scrollView.contentLayoutGuide).inset(38)
            make.horizontalEdges.equalTo(scrollView.frameLayoutGuide).inset(24)
        }
        
        answer1RequiredLabel.snp.makeConstraints { make in
            make.height.equalTo(0)
        }
        
        answer2TextField.snp.makeConstraints { make in
            make.height.equalTo(48)
        }
        
        question2Stack.snp.makeConstraints { make in
            make.top.equalTo(question1Stack.snp.bottom).offset(36)
            make.horizontalEdges.equalTo(scrollView.frameLayoutGuide).inset(24)
        }
        
        answer2RequiredLabel.snp.makeConstraints { make in
            make.height.equalTo(0)
        }
        
        textViewHeightConstraint.isActive = true
        
        question3Stack.snp.makeConstraints { make in
            make.top.equalTo(question2Stack.snp.bottom).offset(36)
            make.horizontalEdges.equalTo(scrollView.frameLayoutGuide).inset(24)
        }
        
        resetOrderButton.snp.makeConstraints { make in
            make.top.equalTo(question3Stack.snp.bottom).offset(50)
            make.centerX.equalTo(scrollView.frameLayoutGuide)
            make.bottom.equalTo(scrollView.contentLayoutGuide).inset(10)
        }
        
        completeButton.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(24)
            make.bottom.equalToSuperview().inset(44)
            make.height.equalTo(54)
        }
        
    }
    
    func setupDelegate() {
        scrollView.delegate = self
        answer2TextField.delegate = self
        answer3TextView.delegate = self
    }
    
    func setupNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
}

private extension ORBRecommendationOrderView {
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let keyboardHeight = keyboardFrame.height
            
            if answer3TextView.isFirstResponder {
                focusScrollToQuestion3(keyboardHeight: keyboardHeight)
            }
        }
    }
    
    @objc func keyboardWillHide() {
        scrollView.contentInset.bottom = 0
        textViewHeightConstraint.constant = 224
        scrollView.layoutIfNeeded()
    }
    
    func focusScrollToQuestion3(keyboardHeight: CGFloat) {
        adjustTextViewHeightWhenKeyboardShows(keyboardHeight: keyboardHeight)
        let value1 = question3Stack.frame.maxY
        // 질문 2, 3이 차지하는 영역의 높이
        let value2 = (question3Stack.frame.height + 36 + question2Stack.frame.height)
        scrollingAnimator.stopAnimation(true)
        scrollingAnimator.addAnimations {[weak self] in
            guard let self else { return }
            self.scrollView.contentOffset = .init(
                x: 0,
                y: value1 - value2 - 10
            )
            self.scrollView.layoutIfNeeded()
        }
        scrollingAnimator.startAnimation()
    }
    
    func adjustTextViewHeightWhenKeyboardShows(keyboardHeight: CGFloat) {
        // 키보드가 올라올 때 설정될 textView의 높이
        let textViewHeight = (
            // scrollView top부터 아래에서 화면 아래까지 길이
            (scrollView.frame.height + completeButton.frame.height + 44
             - keyboardHeight
             - 10 //top padding
             - question2Stack.frame.height
             - 36 // question2Stack과 question3Stack 사이의 spacing
             - question3Label.frame.height
             - 14 // question3Label과 answer3TextView 사이의 spacing
             - 24) //bottom padding
        )
        
        scrollView.contentInset.bottom = keyboardHeight
        textViewHeightConstraint.constant = textViewHeight
    }
    
    func updateRequiredLabelsLayout() {
        let answer1RequiredLabelNewHeight: CGFloat = (
            selectedPlaceCategory.value == nil ? answer1RequiredLabel.intrinsicContentSize.height : 0
        )
        let answer2RequiredLabelNewHeight: CGFloat = (
            placeDescription.value == "" ? answer2RequiredLabel.intrinsicContentSize.height : 0
        )
        
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 1
        ) { [weak self] in
            self?.answer1RequiredLabel.snp.updateConstraints { make in
                make.height.equalTo(answer1RequiredLabelNewHeight)
            }
            self?.answer2RequiredLabel.snp.updateConstraints { make in
                make.height.equalTo(answer2RequiredLabelNewHeight)
            }
            self?.scrollView.layoutIfNeeded()
        }
    }
    
    func updateAnswer1RequiredLabelLayout() {
        let answer1RequiredLabelNewHeight: CGFloat = (
            selectedPlaceCategory.value == nil ? answer1RequiredLabel.intrinsicContentSize.height : 0
        )
        
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 1
        ) { [weak self] in
            self?.answer1RequiredLabel.snp.updateConstraints { make in
                make.height.equalTo(answer1RequiredLabelNewHeight)
            }
            self?.scrollView.layoutIfNeeded()
        }
    }
    
}

// Rx Subscription
private extension ORBRecommendationOrderView {
    
    // 터치 입력을 구독
    func bindActions() {
        let tapGesture = UITapGestureRecognizer()
        tapGesture.rx.event.asDriver().drive(onNext: { [weak self] gesture in
            self?.endEditing(true)
        }).disposed(by: actionBindingDisposeBag)
        scrollView.addGestureRecognizer(tapGesture)
        
        buttonRestaurant.rx.tap.asDriver().drive(onNext: { [weak self] in
            self?.selectedPlaceCategory.accept(.restaurant)
            self?.endEditing(true)
        }).disposed(by: actionBindingDisposeBag)
        
        buttonCaffe.rx.tap.asDriver().drive(onNext: { [weak self] in
            self?.selectedPlaceCategory.accept(.caffe)
            self?.endEditing(true)
        }).disposed(by: actionBindingDisposeBag)
        
        resetOrderButton.rx.tap.asDriver().drive(
            onNext: { [weak self] in
            guard let self else { return }
            // UI 입력값 초기화
            self.selectedPlaceCategory.accept(nil)
            self.placeDescription.accept("")
            self.additionalOrder.accept("")
            
            // 데이터 구독 정보 초기화
            self.dataBindingDisposeBag = DisposeBag()
            self.bindData()
            
            // 필수 항목 안내 라벨 숨기기
            [self.answer1RequiredLabel, self.answer2RequiredLabel].forEach { label in
                label.snp.updateConstraints { $0.height.equalTo(0) }
            }
            UIView.animate(
                withDuration: 0.5,
                delay: 0,
                usingSpringWithDamping: 1,
                initialSpringVelocity: 1
            ) { [weak self] in
                self?.layoutIfNeeded()
            }
        }).disposed(by: actionBindingDisposeBag)
        
        completeButton.rx.tap.asDriver().drive(onNext: {
            // 완료 버튼 동작 구현...
        }).disposed(by: actionBindingDisposeBag)
    }
    
    // 데이터의 변화를 구독
    func bindData() {
        selectedPlaceCategory
            .enumerated()
            .asDriver(onErrorJustReturn: (index: 0, element: nil))
            .drive { [weak self] index, placeCategory in
                self?.buttonRestaurant.isSelected = (placeCategory == .restaurant)
                self?.buttonCaffe.isSelected = (placeCategory == .caffe)
                guard index > 0 else { return }
                self?.updateAnswer1RequiredLabelLayout()
            }.disposed(by: dataBindingDisposeBag)
        
        placeDescription
            .enumerated()
            .asDriver(onErrorJustReturn: (index: 0, element: ""))
            .drive { [weak self] index, placeDescription in
                self?.answer2TextField.text = placeDescription
                guard index > 0 else { return }
                self?.updateRequiredLabelsLayout()
            }.disposed(by: dataBindingDisposeBag)
        
        additionalOrder
            .enumerated()
            .asDriver(onErrorJustReturn: (index: 0, element: ""))
            .drive { [weak self] index, additionalOrder in
                self?.answer3TextView.text = additionalOrder
                guard index > 0 else { return }
                self?.updateRequiredLabelsLayout()
        }.disposed(by: dataBindingDisposeBag)
        
        Observable.combineLatest(
            selectedPlaceCategory,
            placeDescription
        )
        .asDriver(onErrorJustReturn: (nil, ""))
        .drive(onNext: { [weak self] placeCategory, placeDescription in
            self?.completeButton.isEnabled = (
                placeCategory != nil &&
                !placeDescription.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            )
        }).disposed(by: dataBindingDisposeBag)
    }
    
}

// MARK: - UIScrollViewDelegate

extension ORBRecommendationOrderView: UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.endEditing(true)
    }
    
}

// MARK: - UITextFieldDelegate

extension ORBRecommendationOrderView: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.main(.main2).cgColor
        completeButton.isEnabled = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.grayscale(.gray100).cgColor
        placeDescription.accept(textField.text!)
    }
    
}

// MARK: - UITextViewDelegate

extension ORBRecommendationOrderView: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.layer.borderColor = UIColor.main(.main2).cgColor
        completeButton.isEnabled = false
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.layer.borderColor = UIColor.grayscale(.gray100).cgColor
        additionalOrder.accept(textView.text!)
        completeButton.isEnabled = (selectedPlaceCategory.value != nil &&
                                    !placeDescription.value.isEmpty)
    }
    
}
