//
//  OFRAlertController.swift
//  Offroad-iOS
//
//  Created by 김민성 on 9/12/24.
//

import UIKit

import RxSwift
import RxCocoa

class OFRAlertController: ORBOverlayViewController, ORBPopup {
    
    //MARK: - Properties
    
    private let viewModel = OFRAlertViewModel()
    private var disposeBag = DisposeBag()
    
    let presentationAnimator = UIViewPropertyAnimator(duration: 0.4, dampingRatio: 0.7)
    let dismissalAnimator = UIViewPropertyAnimator(duration: 0.2, dampingRatio: 1)
    
    /**
     팝업의 제목
     */
    override var title: String? {
        get { rootView.alertView.title }
        set { viewModel.titleRelay.accept(newValue) }
    }
    
    /**
     팝업의 메시지
     */
    var message: String? {
        get { rootView.alertView.message }
        set { viewModel.messageRelay.accept(newValue) }
    }
    
    var actions: [OFRAlertAction] { rootView.alertView.actions }
    
    /**
     해당 변수에 해당하는 텍스트필드는 alert가 present되면서 자동으로 `firstResponder`가 되고, 키보드가 같이 올라오게 된다.
     alert controller의 type을 `.textField`로 설정할 경우, 기본 제공되는 텍스트필드가 할당됨.
     type이 `.textFiled`가 아닌 `.custom`이고 별도 text field를 추가한 경우에는 이 변수에 직접 할당해 주어야 함.
     */
    //var textFieldToBeFirstResponder: UITextField? = nil
    
    /**
     팝업에 textField가 있을 경우, 키보드가 자동으로 올라오는지 여부
     
     기본값은 `true`.
     
     `textFieldToBeFirstResponder`이 nil이 아닐 경우, 자동으로 키보드가 올라오도록 설정.
     해당 속성을 false로 할당할 경우, `textFieldToBeFirstResponder`가 `nil`이 아닐 경우에도 키보드가 자동으로 올라오지 않음.
     */
    var showsKeyboardWhenPresented: Bool = true
    
    var textFieldToBeFirstResponder: UITextField? {
        get { viewModel.textFieldToBeFirstResponder }
        set { viewModel.textFieldToBeFirstResponderSubject.onNext(newValue) }
    }
    
    //MARK: - UI Properties
    
    let rootView: OFRAlertBackgroundView
    
    private var defaultTextField: UITextField? {
        if let alertViewTextField = rootView.alertView as? ORBAlertViewTextField {
            alertViewTextField.defaultTextField
        } else if let alertViewTextFieldWithSubMessage = rootView.alertView as? ORBAlertViewTextFieldWithSubMessage {
            alertViewTextFieldWithSubMessage.defaultTextField
        } else {
            nil
        }
    }
    
    var buttons: [OFRAlertButton] {
        rootView.alertView.buttons
    }
    
    var xButton: UIButton {
        rootView.alertView.closeButton
    }
    
    //MARK: - Life Cycle
    
    
    init(title: String? = nil, message: String? = nil, type: OFRAlertType) {
        self.rootView = OFRAlertBackgroundView(type: type)
        super.init(nibName: nil, bundle: nil)
        
        bindData()
        viewModel.alertTypeSubject.onNext(type)
        viewModel.titleRelay.accept(title)
        viewModel.messageRelay.accept(message)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = rootView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNotification()
        setupGestureRecognizer()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        showAlertView()
    }
    
    override func dismiss(animated: Bool, completion: (() -> Void)? = nil) {
        view.endEditing(true)
        if animated {
            hideAlertView { super.dismiss(animated: false, completion: completion) }
        } else {
            super.dismiss(animated: false, completion: completion)
        }
    }
    
}


extension OFRAlertController {
    
    //MARK: - @objc Func
    
    @objc private func closeButtonDidTapped() {
        dismiss(animated: true)
    }
    
    @objc private func alertButtonTapped(sender: OFRAlertButton) {
        print(#function)
        self.dismiss(animated: true) {
            sender.action.handler(sender.action)
        }
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRect = keyboardFrame.cgRectValue
            viewModel.keyboardFrameRelay.accept(keyboardRect)
        }
    }
    
    @objc private func keyboardWillHide() {
        rootView.setupLayout(of: .textField, keyboardRect: nil)
        rootView.layoutIfNeeded()
    }
    
    //MARK: - Private Func
    
    private func setupTargets() {
        rootView.alertView.closeButton.addTarget(self, action: #selector(closeButtonDidTapped), for: .touchUpInside)
        buttons.forEach { button in
            button.addTarget(self, action: #selector(alertButtonTapped(sender:)), for: .touchUpInside)
        }
    }
    
    private func setupNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func setupGestureRecognizer() {
        rootView.addGestureRecognizer(viewModel.backgroundTapGesture)
    }
    
    private func bindData() {
        viewModel.titleRelay.bind(to: rootView.alertView.titleLabel.rx.text).disposed(by: disposeBag)
        viewModel.messageRelay.bind(to: rootView.alertView.messageLabel.rx.text).disposed(by: disposeBag)
        viewModel.alertTypeSubject
            .filter({ $0 == .textField || $0 == .textFieldWithSubMessage })
            .subscribe(onNext: { [weak self] type in
                guard let self else { return }
                self.viewModel.textFieldToBeFirstResponderSubject.onNext(self.defaultTextField)
            })
            .disposed(by: disposeBag)
        
        viewModel.alertTypeSubject
            .filter({ $0 == .acquiredEmblem })
            .subscribe(onNext: { _ in
                // 획득 칭호 뷰 설정하기
                // 획득 칭호 모델 설정
                // delegate 설정 등
                // 획득 칭호 모델 팝업은 그냥 별도의 팝업 뷰 컨트롤러로 구현하는 것 고려
            })
        
        viewModel.textFieldToBeFirstResponderSubject
            .subscribe { textField in
                textField?.becomeFirstResponder()
            }
            .disposed(by: disposeBag)
        
        viewModel.keyboardFrameRelay
            .subscribe { [weak self] rect in
                self?.rootView.setupLayout(of: .textField, keyboardRect: rect)
                self?.view.layoutIfNeeded()
            }
            .disposed(by: disposeBag)
        
        viewModel.isInputEmptyObservable
            .subscribe(onNext: {
                print($0 ? "비었음" : "입력됨")
                for button in self.buttons { button.isEnabled = !$0 }
            })
            .disposed(by: disposeBag)
        
        if let defaultTextField {
            defaultTextField.rx.text.orEmpty
                .do(onNext: { print($0) })
                .subscribe(onNext: { [weak self] string in
                    self?.viewModel.defaultTextInput.accept(string)
                })
                .disposed(by: disposeBag)
        }
        
        viewModel.backgroundTapGesture.rx.event
            .filter({ $0.numberOfTouches < 2 })
            .filter({
                [weak self] _ in
                guard let self,
                      let textField = viewModel.textFieldToBeFirstResponder else { return false }
                return textField.isFirstResponder
            })
            .bind { [weak self] recognizer in
                print("tapped in view")
                self?.rootView.endEditing(true)
            }.disposed(by: disposeBag)
        
    }
    
    //MARK: - Func
    
    func addAction(_ action: OFRAlertAction) {
        rootView.alertView.actions.append(action)
        setupTargets()
        rootView.layoutIfNeeded()
    }
    
    func configureTitleLabel(_ configure: (UILabel) -> Void) {
        configure(self.rootView.alertView.titleLabel)
    }
    
    /**
     alert controller의 type이 `.textField`인 경우 `defaultTextField`의 속성을 변경하는 함수.
     alert controller의 type이 `.textField`가 아닌 경우, 이 함수는 아무런 동작도 하지 않는다.
     */
    func configureDefaultTextField(_ configure: (UITextField) -> Void) {
        guard viewModel.type == .textField || viewModel.type == .textFieldWithSubMessage else { return }
        configure(defaultTextField!)
    }
    
    func configureMessageLabel(_ configure: (UILabel) -> Void) {
        configure(self.rootView.alertView.messageLabel)
    }
    
    func configureSubMessagelabel(_ configure: (UILabel) -> Void) {
        guard let alertViewTextFieldWithSubMessage = rootView.alertView as? ORBAlertViewTextFieldWithSubMessage else { return }
        configure(alertViewTextFieldWithSubMessage.subMessageLabel)
    }
    
    func configureScrollableContentView(_ configure: (UIView) -> Void) {
        guard let alertViewScrollableContent = rootView.alertView as? ORBAlertViewScrollableContent else { return }
        configure(alertViewScrollableContent.scrollableContentView)
    }
    
    func configureExplorationResultImage(_ configure: (UIImageView) -> Void) {
        guard let alertViewExplorationResult = rootView.alertView as? ORBAlertViewExplorationResult else { return }
        configure(alertViewExplorationResult.explorationResultImageView)
    }
    
}
