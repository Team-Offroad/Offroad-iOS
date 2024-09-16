//
//  OFRAlertController.swift
//  Offroad-iOS
//
//  Created by 김민성 on 9/12/24.
//

import UIKit

class OFRAlertController: UIViewController {
    
    //MARK: - Properties
    
    let transitionDelegate = ZeroDurationTransitionDelegate()
    let presentationAnimator = UIViewPropertyAnimator(duration: 0.4, dampingRatio: 0.8)
    let dismissalAnimator = UIViewPropertyAnimator(duration: 0.4, dampingRatio: 0.8)
    
    /**
     팝업의 제목
     */
    override var title: String? {
        get { backgroundView.alertView.title }
        set { backgroundView.alertView.title = newValue }
    }
    
    /**
     팝업의 메시지
     */
    var message: String? {
        get { backgroundView.alertView.title }
        set { backgroundView.alertView.title = newValue }
    }
    
    var actions: [OFRAlertAction] { backgroundView.alertView.actions }
    
    /**
     해당 변수에 해당하는 텍스트필드는 alert가 present되면서 자동으로 `firstResponder`가 되고, 키보드가 같이 올라오게 된다.
     */
    var textFieldToBeFirstResponder: UITextField? = nil
    
    /**
     `textFieldToBeFirstResponder`이 nil이 아닐 경우, 자동으로 키보드가 올라오도록 설정.
     해당 속성을 false로 할당할 경우, `textFieldToBeFirstResponder`가 `nil`이 아닐 경우에도 키보드가 자동으로 올라오지 않음.
     기본값은 `true`.
     */
    var isKeyboardShowWhenPresented: Bool = true
    
    /**
     팝업 우측 상단의 X 버튼(팝업 창 닫는 버튼) 이 보여지도록 할 지 설정
     */
    var showsCloseButton: Bool = false
    
    var keyboardHeight: CGFloat? = nil
    
    //MARK: - UI Properties
    
    let backgroundView = OFRAlertBackgroundView()
    
    //MARK: - Life Cycle
    
    private override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        
        setupPresentationStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(title: String? = nil, message: String? = nil) {
        self.init(nibName: nil, bundle: nil)
        
        backgroundView.alertView.title = title
        backgroundView.alertView.message = message
    }
    
    override func loadView() {
        view = backgroundView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTargets()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        showAlertView()
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        hideAlertView {
            super.dismiss(animated: flag, completion: completion)
        }
    }
    
}


extension OFRAlertController {
    
    //MARK: - Layout
    
    //MARK: - @objc Func
    
    @objc private func closeButtonDidTapped() {
        dismiss(animated: false)
    }
    
    //MARK: - Private Func
    
    private func setupPresentationStyle() {
        self.transitioningDelegate = transitionDelegate
        self.modalPresentationStyle = .custom
    }
    
    private func setupTargets() {
        backgroundView.alertView.closeButton.addTarget(self, action: #selector(closeButtonDidTapped), for: .touchUpInside)
    }
    
    private func showAlertView() {
        
        backgroundView.alertView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        
        presentationAnimator.addAnimations { [weak self] in
            self?.backgroundView.backgroundColor = .blackOpacity(.black25)
            self?.backgroundView.alertView.alpha = 1
            self?.backgroundView.alertView.transform = .identity
        }
        presentationAnimator.startAnimation()
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
    
    
    //MARK: - Func
    
    func addAction(_ action: OFRAlertAction) {
        backgroundView.alertView.actions.append(action)
    }
    
    func addTextField(configurationHandler: ((UITextField) -> Void)? = nil) {
        let textField = UITextField()
        
        configurationHandler?(textField)
    }
    
}


class OFRAlertAction {
    
    init(title: String?, style: OFRAlertAction.Style, handler: ((OFRAlertAction) -> Void)? = nil) {
        self.title = title
        self.style = style
    }
    
    var title: String?
    var style: OFRAlertAction.Style
    var isEnabled: Bool = true
}

extension OFRAlertAction {
    
    enum Style {
        case `default`
        case cancel
        case destructive
    }
    
}
