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
    var isLogTextViewShown: Bool = false
    private let logTextViewAnimator = UIViewPropertyAnimator(duration: 0.3, dampingRatio: 1)
    private var dynamicAnimator: UIDynamicAnimator?
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
        dynamicAnimator = UIDynamicAnimator(referenceView: view)
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
            dynamicAnimator?.removeAllBehaviors()
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
//        let isLogTextViewShown = !rootView.logTextView.isHidden
        if isLogTextViewShown {
            self.hideLogTextView()
        } else {
            self.showLogTextView()
        }
    }
    
    private func applyInertiaEffect(velocity: CGPoint) {
        let dynamic = UIDynamicItemBehavior(items: [rootView.floatingButton])
        dynamic.addLinearVelocity(velocity, for: rootView.floatingButton)
        dynamic.resistance = 15.0
        dynamic.elasticity = 0.3
        dynamic.allowsRotation = false
        dynamicAnimator?.addBehavior(dynamic)
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
        
        dynamicAnimator?.addBehavior(collision)
        collisionBehavior = collision
    }
    
    private func showLogTextView() {
        logTextViewAnimator.stopAnimation(true)
        rootView.logTextView.isHidden = false
        isLogTextViewShown = true
        let transform = CGAffineTransform.identity
        logTextViewAnimator.addAnimations { [weak self] in
            self?.rootView.logTextView.transform = transform
            self?.rootView.logTextView.alpha = 1
        }
        logTextViewAnimator.addCompletion { [weak self] _ in
            self?.rootView.logTextView.layoutIfNeeded()
        }
        logTextViewAnimator.startAnimation()
    }
    
    private func hideLogTextView() {
        logTextViewAnimator.stopAnimation(true)
        isLogTextViewShown = false
        let transform = CGAffineTransform(scaleX: 1, y: 0.1)
        logTextViewAnimator.addAnimations { [weak self] in
            self?.rootView.logTextView.transform = transform
            self?.rootView.logTextView.alpha = 0
        }
        logTextViewAnimator.addCompletion { [weak self] _ in
            self?.rootView.logTextView.isHidden = true
        }
        logTextViewAnimator.startAnimation()
    }
    
}
