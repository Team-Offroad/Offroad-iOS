//
//  PlaceInfoViewController.swift
//  Offroad-iOS
//
//  Created by 김민성 on 10/27/24.
//

import UIKit

import RxSwift

class PlaceInfoViewController: UIViewController {
    
    let rootView: PlaceInfoView
    let shouldHideTooltip = PublishSubject<Void>()
    let shouldShowTooltip = PublishSubject<Void>()
    
    var disposeBag = DisposeBag()
    
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
    
    @objc private func tapped() {
        shouldHideTooltip.onNext(())
    }
    
    private func bindData() {
        rootView.tooltip.closeButton.rx.tap.bind(onNext: { [weak self] in
            guard let self else { return }
            self.shouldHideTooltip.onNext(())
        }).disposed(by: disposeBag)
    }
    
}

extension PlaceInfoViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
}
