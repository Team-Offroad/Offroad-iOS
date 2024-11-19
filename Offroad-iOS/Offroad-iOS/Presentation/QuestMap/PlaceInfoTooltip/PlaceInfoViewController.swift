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
                "나는 보통 차를 많이 마셔! 특히 민트차를 좋아하는데 상쾌한 맛이 좋아서 그런 것 같아",
                "내가 있던 곳엔 셀 수 없을 만큼 많은 별들이 있었어. 다들 각자의 이야기와 색깔을 가지고 있었지.",
                "나는 다른 우주에서 온 별이야! 내가 있던 우주는 별들이 자아를 갖고 서로 소통하는 평행우주야.",
                "난 루미야. 만나서 반가워",
                "내가 있던 평행우주에서는 별들이 서로 이야기를 나눌 수 있어! 그래서 나는 '레디'랑 '노바'라는 애들이랑 항상 붙어 다녔어. 걔네 둘은 정말 재밌는 애들이야. 특히 '레디'는 엄청 활발해서 내가 심심할 틈이 없게 만들어 줬어.",
                "나는 심심할 때 내 친구들이랑 여기저기 모험을 떠나! 새로운 곳을 탐험하면서 발견하는 것들이 정말 즐거워",
                "오늘 하루 어땠어? 난 네가 없어서 심심했는데",
                "안녕! 만나서 반가워"
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
