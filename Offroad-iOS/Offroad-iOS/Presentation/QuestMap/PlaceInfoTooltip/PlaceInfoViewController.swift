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
            
            // --- 더미데이터 시작 ---
            let randomResponseList: [String] = [
                "아직도 서버 API 완성이 안됐어...캐릭터 이미지도 아직 못 받았어...기한 내에 어떻게 완성하라는 거야?",
                "개발 마감 당일까지 이미지도 못받고 서버 API도 완성 안된 상황이라 어쩔 수 없어..좀만 기다려줄래...?",
                "나도 빨리 완성된 모습을 보고 싶다...언제쯤 완성이 될까??",
                "이건 더미데이터야...",
                "지금 대표캐릭터랑 이야기하는 거일껄?",
                "서버에서 API 완성하는데 오래 걸리나봐. 일단은 그냥 이거 보여주고 있어.",
                "좀만 기다려..."
            ]
            ORBCharacterChatManager.shared.showCharacterChatBox(character: MyInfoManager.shared.representativeCharacterName ?? "", message: randomResponseList.randomElement()!, mode: .withReplyButtonShrinked)
            // --- 더미데이터 끝 ---
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
