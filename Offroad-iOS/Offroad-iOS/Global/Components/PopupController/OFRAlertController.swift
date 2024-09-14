//
//  OFRAlertController.swift
//  Offroad-iOS
//
//  Created by 김민성 on 9/12/24.
//

import UIKit

class OFRAlertController: UIViewController {
    
    //MARK: - Properties
    
    let presentationAnimator = UIViewPropertyAnimator(duration: 0.5, dampingRatio: 5)
    let dismissalAnimator = UIViewPropertyAnimator(duration: 0.5, dampingRatio: 5)
    
    /**
     팝업의 제목
     */
    override var title: String? {
        get { backgroundView.popupView.title }
        set { backgroundView.popupView.title = newValue }
    }
    
    /**
     팝업의 메시지
     */
    var message: String?
    var actions: [UIAction] = []
    
    /**
     해당 변수에 해당하는 텍스트필드는 popup이 present되면서 자동으로 `firstResponder`가 되고, 키보드가 같이 올라오게 된다.
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
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = backgroundView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupPresentationStyle()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
}


extension OFRAlertController {
    
    //MARK: - Layout
    
    //MARK: - @objc Func
    
    //MARK: - Private Func
    
    private func setupPresentationStyle() {
        modalPresentationStyle = .overFullScreen
    }
    
    
    //MARK: - Func
    
    func addAction(_ action: UIAction) {
        
    }
    
}
