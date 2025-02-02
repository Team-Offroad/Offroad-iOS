//
//  LogPrinterView.swift
//  ORB(Dev)
//
//  Created by 김민성 on 1/31/25.
//

import UIKit
import SnapKit
import Then

internal class LogPrinterView: UIView {
    
    //MARK: - Properties
    
    lazy var floatingViewTopConstraintToSafeArea = floatingView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 5)
    
    //MARK: - UI Properties
    
    let floatingView = UIView()
    let floatingViewGrabber = UIView()
    let floatingViewGrabberTouchArea = UIView()
    let floatingButton = UIButton()
    let logTextView = UITextView()
    
    //MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupStyle()
        setupHierarchy()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension LogPrinterView {
    
    // MARK: - Layout Func
    
    private func setupLayout() {
        floatingViewGrabber.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(8)
            make.width.equalTo(90)
            make.height.equalTo(6)
        }
        
        floatingViewGrabberTouchArea.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.width.equalTo(90)
            make.bottom.equalTo(logTextView.snp.top).offset(5)
        }
        
        floatingViewTopConstraintToSafeArea.isActive = true
        floatingView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(5)
            make.height.equalTo(250)
        }
        
        logTextView.snp.makeConstraints { make in
            make.top.equalTo(floatingViewGrabber.snp.bottom).offset(8)
            make.horizontalEdges.bottom.equalToSuperview().inset(5)
        }
    }
    
    // MARK: - Private Func
    
    private func setupStyle() {
        floatingButton.do { button in
            button.setTitle("💬", for: .normal)
            button.backgroundColor = UIColor.black.withAlphaComponent(0.7)
            button.setTitleColor(.white, for: .normal)
            button.layer.cornerRadius = 30
            button.clipsToBounds = true
            button.frame = CGRect(x: LogPrinterWindow.currentWindow.screen.bounds.width - 20 - 60,
                                  y: LogPrinterWindow.currentWindow.screen.bounds.height * 3/4,
                                  width: 60,
                                  height: 60)
        }
        
        floatingView.do { view in
            view.backgroundColor = .black.withAlphaComponent(0.3)
            view.isHidden = true
            view.layer.cornerRadius = 20
            view.clipsToBounds = true
            view.layer.cornerCurve = .continuous
            let transform = CGAffineTransform(scaleX: 1, y: 0.1)
            view.transform = transform
        }
        
        floatingViewGrabberTouchArea.do { view in
            view.backgroundColor = .clear
            view.isUserInteractionEnabled = true
        }
        
        floatingViewGrabber.do { view in
            view.backgroundColor = .black.withAlphaComponent(0.4)
            view.layer.cornerRadius = 3
            view.clipsToBounds = true
        }
        
        logTextView.do { textView in
            textView.backgroundColor = .black.withAlphaComponent(0.6)
            textView.isEditable = false
            textView.isSelectable = false
            textView.font = .systemFont(ofSize: 10)
            textView.textColor = .white
            textView.contentInset = .init(top: 2, left: 5, bottom: 2, right: 5)
            textView.layer.cornerRadius = 16
            textView.clipsToBounds = true
            textView.layer.cornerCurve = .continuous
        }
    }
    
    private func setupHierarchy() {
        [logTextView, floatingViewGrabber, floatingViewGrabberTouchArea].forEach { view in
            floatingView.addSubview(view)
        }
        addSubview(floatingView)
        addSubview(floatingButton)
    }
    
}
