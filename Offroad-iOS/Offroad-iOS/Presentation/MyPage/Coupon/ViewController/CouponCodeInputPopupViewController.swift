//
//  CouponCodeInputPopupViewController.swift
//  Offroad-iOS
//
//  Created by 김민성 on 9/9/24.
//

import UIKit

class CouponCodeInputPopupViewController: UIViewController {
    
    //MARK: - Properties
    
    let presentationAnimator = UIViewPropertyAnimator(duration: 0.4, dampingRatio: 1)
    let dismissalAnimator = UIViewPropertyAnimator(duration: 0.4, dampingRatio: 1)
    
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
        // duration: 0.4
        rootView.popupView.executeDismissPopupAnimation { [weak self] isFinished in
            guard isFinished else { return }
            guard let self else { return }
            dismiss(animated: false)
        }
    }
    
    //MARK: - Private Func
    
    private func setupPresentation() {
        modalPresentationStyle = .overFullScreen
    }
    
    private func setupControlsTarget() {
        rootView.closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
    }
    
    private func executePopupPresentation() {
        presentationAnimator.addAnimations { [weak self] in
            guard let self else { return }
            self.rootView.backgroundColor = .blackOpacity(.black55)
        }
        presentationAnimator.startAnimation()
        rootView.popupView.executePresentPopupAnimation()
    }
    
}
