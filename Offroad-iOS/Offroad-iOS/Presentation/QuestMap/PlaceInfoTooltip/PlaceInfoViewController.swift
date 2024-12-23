//
//  PlaceInfoViewController.swift
//  Offroad-iOS
//
//  Created by 김민성 on 10/27/24.
//

import UIKit

import RxSwift

class PlaceInfoViewController: UIViewController {
    
    //MARK: - Properties
    
    let rootView: PlaceInfoView
    let shouldHideTooltip = PublishSubject<Void>()
    let shouldShowTooltip = PublishSubject<Void>()
    
    let backgroundColorAnimator = UIViewPropertyAnimator(duration: 0.3, dampingRatio: 1)
    let tooltipTransparencyAnimator = UIViewPropertyAnimator(duration: 0.2, dampingRatio: 1)
    let tooltipShowingAnimator = UIViewPropertyAnimator(duration: 0.4, dampingRatio: 0.8)
    let tooltipHidingAnimator = UIViewPropertyAnimator(duration: 0.25, dampingRatio: 1)
    
    var disposeBag = DisposeBag()
    
    var isTooltipShown: Bool = false
    
    //MARK: - Life Cycle
    
    init(contentFrame: CGRect) {
        self.rootView = PlaceInfoView(contentFrame: contentFrame)
        super.init(nibName: nil, bundle: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapped))
        rootView.addGestureRecognizer(tapGesture)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindData()
    }
    
}

extension PlaceInfoViewController {
    
    //MARK: - @objc Func
    
    @objc private func tapped(sender: UITapGestureRecognizer) {
        guard !rootView.tooltip.frame.contains(sender.location(in: rootView.contentView)) else { return }
        shouldHideTooltip.onNext(())
    }
    
    //MARK: - Private Func
    
    private func bindData() {
        rootView.tooltip.closeButton.rx.tap.bind(onNext: { [weak self] in
            guard let self else { return }
            self.shouldHideTooltip.onNext(())
        }).disposed(by: disposeBag)
    }
    
    //MARK: - Func
    
    func showToolTip(completion: (() -> Void)? = nil) {
        rootView.tooltip.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        rootView.tooltip.alpha = 0
        rootView.layoutIfNeeded()
        tooltipHidingAnimator.stopAnimation(true)
        
        backgroundColorAnimator.addAnimations { [weak self] in
            guard let self else { return }
            self.rootView.backgroundColor = .blackOpacity(.black25)
        }
        tooltipTransparencyAnimator.addAnimations { [weak self] in
            guard let self else { return }
            self.rootView.tooltip.alpha = 1
        }
        tooltipShowingAnimator.addAnimations { [weak self] in
            guard let self else { return }
            self.rootView.tooltip.transform = .identity
            self.rootView.layoutIfNeeded()
        }
        tooltipShowingAnimator.addCompletion { _ in
            completion?()
        }
        isTooltipShown = true
        tooltipTransparencyAnimator.startAnimation()
        backgroundColorAnimator.startAnimation()
        tooltipShowingAnimator.startAnimation()
    }
    
    func hideTooltip(completion: (() -> Void)? = nil) {
        guard isTooltipShown else { return }
        tooltipShowingAnimator.stopAnimation(true)
        
        backgroundColorAnimator.addAnimations { [weak self] in
            guard let self else { return }
            self.rootView.backgroundColor = .clear
        }
        tooltipHidingAnimator.addAnimations { [weak self] in
            guard let self else { return }
            self.rootView.tooltip.transform = CGAffineTransform(scaleX: 0.05, y: 0.05)
        }
        tooltipHidingAnimator.addAnimations({ [weak self] in
            guard let self else { return }
            self.rootView.tooltip.alpha = 0
        }, delayFactor: 0.3)
        tooltipHidingAnimator.addCompletion { [weak self] _ in
            guard let self else { return }
            self.rootView.tooltip.configure(with: nil)
            completion?()
        }
        isTooltipShown = false
        backgroundColorAnimator.startAnimation()
        tooltipHidingAnimator.startAnimation()
    }
    
}
