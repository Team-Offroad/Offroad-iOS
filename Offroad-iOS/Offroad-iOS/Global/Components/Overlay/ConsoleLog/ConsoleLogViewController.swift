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
    private var animator: UIDynamicAnimator?
    private var dynamicBehavior: UIDynamicItemBehavior?
    private var collisionBehavior: UICollisionBehavior?
    
    
    let rootView = ConsoleLogView()
    let panGesture = UIPanGestureRecognizer()
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupGestures()
        setupActions()
        animator = UIDynamicAnimator(referenceView: view)
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
        
        switch sender.state {
        case .began:
            animator?.removeAllBehaviors()
        case .changed:
            // floatingButton 한 변의 길이: 60
            rootView.floatingButton.center = CGPoint(
                x: min(rootView.frame.width - 30, max(30, rootView.floatingButton.center.x + translation.x)),
                y: min(rootView.frame.height - 30, max(30, rootView.floatingButton.center.y + translation.y))
            )
        case .ended:
            let velocity = sender.velocity(in: rootView)
            rootView.floatingButton.layoutIfNeeded()
            applyInertiaEffect(velocity: velocity)
        default:
            break
        }
        
        sender.setTranslation(.zero, in: view)
    }
    
    private func setupActions() {
        rootView.floatingButton.rx.tap
            .subscribe(onNext: { [weak self] in
                // floatingButton action
                self?.floatingButtonAction()
            }).disposed(by: disposeBag)
    }
    
    private func floatingButtonAction() {
        print("floatingButton action")
    }
    
    private func applyInertiaEffect(velocity: CGPoint) {
        let dynamic = UIDynamicItemBehavior(items: [rootView.floatingButton])
        dynamic.addLinearVelocity(velocity, for: rootView.floatingButton)
        dynamic.resistance = 15.0
        dynamic.elasticity = 0.3
        dynamic.allowsRotation = false
        animator?.addBehavior(dynamic)
        dynamicBehavior = dynamic
        
        let inset: CGFloat = 20
        let boundaryFrame = view.bounds.insetBy(dx: inset, dy: inset)
        let collision = UICollisionBehavior(items: [rootView.floatingButton])
        collision.addBoundary(withIdentifier: "top" as NSString,
                              from: CGPoint(x: boundaryFrame.minX, y: boundaryFrame.minY),
                              to: CGPoint(x: boundaryFrame.maxX, y: boundaryFrame.minY))
        
        collision.addBoundary(withIdentifier: "left" as NSString,
                              from: CGPoint(x: boundaryFrame.minX, y: boundaryFrame.minY),
                              to: CGPoint(x: boundaryFrame.minX, y: boundaryFrame.maxY))
        
        collision.addBoundary(withIdentifier: "right" as NSString,
                              from: CGPoint(x: boundaryFrame.maxX, y: boundaryFrame.minY),
                              to: CGPoint(x: boundaryFrame.maxX, y: boundaryFrame.maxY))
        
        collision.addBoundary(withIdentifier: "bottom" as NSString,
                              from: CGPoint(x: boundaryFrame.minX, y: boundaryFrame.maxY),
                              to: CGPoint(x: boundaryFrame.maxX, y: boundaryFrame.maxY))
        
        animator?.addBehavior(collision)
        collisionBehavior = collision
    }
    
}
