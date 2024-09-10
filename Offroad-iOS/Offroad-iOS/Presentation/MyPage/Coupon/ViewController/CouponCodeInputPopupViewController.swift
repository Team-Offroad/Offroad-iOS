//
//  CouponCodeInputPopupViewController.swift
//  Offroad-iOS
//
//  Created by 김민성 on 9/9/24.
//

import UIKit

class CouponCodeInputPopupViewController: UIViewController {
    
    //MARK: - Properties
    
    let presentationAnimator = UIViewPropertyAnimator(duration: 0.5, dampingRatio: 1)
    let dismissalAnimator = UIViewPropertyAnimator(duration: 0.4, dampingRatio: 1)
    
    var keyboardHeight: CGFloat = 0 {
        didSet {
            print("keyboardHeight didSet: \(self.keyboardHeight)")
            popupPresentation()
        }
    }
    
    //MARK: - UI Properties
    
    let rootView = CouponCodeInputPopupView()
    
    //MARK: - Life Cycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        
        setupPresentation()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupControlsTarget()
        setupNotification()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        executePopupPresentation()
    }
    
}

extension CouponCodeInputPopupViewController {
    
    //MARK: - @objc Func
    
    @objc private func closeButtonTapped() {
        dismissalAnimator.addAnimations { [weak self] in
            self?.rootView.backgroundColor = .clear
        }
        dismissalAnimator.startAnimation()
        
        rootView.couponCodeTextField.resignFirstResponder()
        // duration: 0.4
        rootView.popupView.executeDismissPopupAnimation { [weak self] isFinished in
            guard isFinished else { return }
            guard let self else { return }
            dismiss(animated: false)
        }
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            self.keyboardHeight = keyboardHeight
        }
    }
    
    //MARK: - Private Func
    
    private func setupPresentation() {
        modalPresentationStyle = .overFullScreen
    }
    
    private func setupControlsTarget() {
        rootView.closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
    }
    
    private func setupNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    private func executePopupPresentation() {
        rootView.couponCodeTextField.becomeFirstResponder()
    }
    
    private func popupPresentation() {
        rootView.popupViewBottomConstraint.constant = -(keyboardHeight + 40)
        rootView.popupView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        rootView.popupView.alpha = 0.1
        rootView.layoutIfNeeded()
        
        presentationAnimator.addAnimations { [weak self] in
            guard let self else { return }
            self.rootView.backgroundColor = .blackOpacity(.black55)
            self.rootView.popupView.transform = CGAffineTransform.identity
            self.rootView.popupView.alpha = 1
        }
        presentationAnimator.startAnimation()
        //rootView.popupView.executePresentPopupAnimation()
    }
    
}
