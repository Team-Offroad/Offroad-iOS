//
//  ConsoleLogViewController.swift
//  ORB(Dev)
//
//  Created by 김민성 on 1/31/25.
//

import UIKit

import RxSwift
import RxCocoa

class ConsoleLogViewController: UIViewController {
    
    var disposeBag = DisposeBag()
    
    let rootView = ConsoleLogView()
    let panGesture = UIPanGestureRecognizer()
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupGestures()
        setupActions()
    }
    
}

extension ConsoleLogViewController {
    
    //MARK: - Private Func
    
    private func setupGestures() {
        rootView.floatingButton.addGestureRecognizer(panGesture)
        panGesture.rx.event.subscribe(onNext: { [weak self] gesture in
            self?.panGestureAction(sender: gesture)
        }).disposed(by: disposeBag)
    }
    
    private func panGestureAction(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        rootView.floatingButton.center = CGPoint(x: rootView.floatingButton.center.x + translation.x,
                                                 y: rootView.floatingButton.center.y + translation.y)
        sender.setTranslation(.zero, in: view)
    }
    
    private func setupActions() {
        rootView.floatingButton.rx.tap
            .subscribe(onNext: { [weak self] in
                // floatingButton action
                print("floatingButton action")
            }).disposed(by: disposeBag)
    }
    
}
