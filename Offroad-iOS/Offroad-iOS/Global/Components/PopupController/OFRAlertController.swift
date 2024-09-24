//
//  OFRAlertController.swift
//  Offroad-iOS
//
//  Created by 김민성 on 9/12/24.
//

import UIKit

import RxSwift
import RxCocoa

class OFRAlertController: UIViewController {
    
    //MARK: - Properties
    
    private let viewModel = OFRAlertViewModel()
    private var disposeBag = DisposeBag()
    
    private let transitionDelegate = ZeroDurationTransitionDelegate()
    private let presentationAnimator = UIViewPropertyAnimator(duration: 0.4, dampingRatio: 0.7)
    private let dismissalAnimator = UIViewPropertyAnimator(duration: 0.2, dampingRatio: 1)
    
    /**
     팝업의 제목
     */
    override var title: String? {
        get { backgroundView.alertView.title }
        set { viewModel.titleRelay.accept(newValue) }
    }
    
    /**
     팝업의 메시지
     */
    var message: String? {
        get { backgroundView.alertView.message }
        set { viewModel.messageRelay.accept(newValue) }
    }
    
    var actions: [OFRAlertAction] { backgroundView.alertView.actions }
    
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
    
    private let backgroundView = OFRAlertBackgroundView()
    
    private var defaultTextField: UITextField {
        backgroundView.alertView.defaultTextField
    }
    
    var buttons: [OFRAlertButton] {
        backgroundView.alertView.buttons
    }
    
    //MARK: - Life Cycle
    
    private override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        
        setupPresentationStyle()
        bindData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(title: String? = nil, message: String? = nil, type: OFRAlertViewType) {
        self.init(nibName: nil, bundle: nil)
        
        viewModel.titleRelay.accept(title)
        viewModel.messageRelay.accept(message)
        
        viewModel.type = type
        backgroundView.alertView.setFinalLayout(of: type)
        backgroundView.alertView.layoutIfNeeded()
        
        if type == .textField {
            viewModel.textFieldToBeFirstResponder = defaultTextField
        }
    }
    
    override func loadView() {
        view = backgroundView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNotification()
        setupGestureRecognizer()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        showAlertView()
        showKeyboardIfNeeded()
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
        backgroundView.setupLayout(of: .textField, keyboardRect: nil)
        backgroundView.layoutIfNeeded()
    }
    
    //MARK: - Private Func
    
    private func setupPresentationStyle() {
        self.transitioningDelegate = transitionDelegate
        self.modalPresentationStyle = .custom
    }
    
    private func setupTargets() {
        backgroundView.alertView.closeButton.addTarget(self, action: #selector(closeButtonDidTapped), for: .touchUpInside)
        buttons.forEach { button in
            button.addTarget(self, action: #selector(alertButtonTapped(sender:)), for: .touchUpInside)
        }
    }
    
    private func showAlertView() {
        backgroundView.alertView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        backgroundView.layoutIfNeeded()
        
        presentationAnimator.addAnimations { [weak self] in
            self?.backgroundView.backgroundColor = .blackOpacity(.black25)
            self?.backgroundView.alertView.alpha = 1
            self?.backgroundView.alertView.transform = .identity
        }
        presentationAnimator.startAnimation()
        viewModel.animationStartedSubject.onNext(true)
    }
    
    private func hideAlertView(completion: (() -> Void)? = nil) {
        dismissalAnimator.addAnimations { [weak self] in
            self?.backgroundView.backgroundColor = .clear
            self?.backgroundView.alertView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            self?.backgroundView.alertView.alpha = 0
        }
        dismissalAnimator.addCompletion { _ in completion?() }
        dismissalAnimator.startAnimation()
    }
    
    private func showKeyboardIfNeeded() {
        if viewModel.type == .textField && showsKeyboardWhenPresented {
            viewModel.textFieldToBeFirstResponder?.becomeFirstResponder()
        }
    }
    
    private func setupNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func setupGestureRecognizer() {
        backgroundView.addGestureRecognizer(viewModel.backgroundTapGesture)
    }
    
    private func bindData() {
        viewModel.titleRelay.bind(to: backgroundView.alertView.titleLabel.rx.text).disposed(by: disposeBag)
        viewModel.messageRelay.bind(to: backgroundView.alertView.messageLabel.rx.text).disposed(by: disposeBag)
        
        viewModel.keyboardFrameRelay
            .subscribe { [weak self] rect in
                self?.backgroundView.setupLayout(of: .textField, keyboardRect: rect)
                self?.view.layoutIfNeeded()
            }
            .disposed(by: disposeBag)
        
        viewModel.isInputEmptyObservable
            .subscribe(onNext: {
                print($0 ? "비었음" : "입력됨")
                for button in self.buttons { button.isEnabled = !$0 }
            })
            .disposed(by: disposeBag)
        
        defaultTextField.rx.text.orEmpty
            .do(onNext: { print($0) })
            .subscribe(onNext: { [weak self] string in
                self?.viewModel.textInput.accept(string)
            })
            .disposed(by: disposeBag)
        
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
                self?.backgroundView.endEditing(true)
            }.disposed(by: disposeBag)
        
    }
    
    //MARK: - Func
    
    func addAction(_ action: OFRAlertAction) {
        backgroundView.alertView.actions.append(action)
        setupTargets()
        backgroundView.layoutIfNeeded()
    }
    
    /**
     alert controller의 type이 `.textField`인 경우 `defaultTextField`의 속성을 변경하는 함수.
     alert controller의 type이 `.textField`가 아닌 경우, 이 함수는 아무런 동작도 하지 않는다.
     */
    func configureDefaultTextField(_ configure: (UITextField) -> Void) {
        guard viewModel.type == .textField else { return }
        configure(defaultTextField)
    }
    
    func configureMessageLabel(_ configure: (UILabel) -> Void) {
        configure(self.backgroundView.alertView.messageLabel)
    }
    
}
