//
//  ConsoleLogView.swift
//  ORB(Dev)
//
//  Created by 김민성 on 1/31/25.
//

import UIKit

class ConsoleLogView: UIView {
    
//    let floatingButton = ShrinkableButton(shrinkScale: 0.9)
    let floatingView = UIView()
    let floatingViewGrabber = UIView()
    let floatingButton = UIButton()
    let logTextView = UITextView()
    
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

extension ConsoleLogView {
    
    // MARK: - Layout Func
    
    private func setupStyle() {
        floatingButton.do { button in
            button.setTitle("🛠️", for: .normal)
            button.backgroundColor = UIColor.black.withAlphaComponent(0.7)
            button.setTitleColor(.white, for: .normal)
            button.roundCorners(cornerRadius: 30)
            button.frame = CGRect(x: 20, y: 100, width: 60, height: 60)
        }
        
        floatingView.do { view in
            view.backgroundColor = .black.withAlphaComponent(0.3)
            view.isHidden = true
            view.roundCorners(cornerRadius: 20)
            view.layer.cornerCurve = .continuous
            let transform = CGAffineTransform(scaleX: 1, y: 0.1)
            view.transform = transform
        }
        
        floatingViewGrabber.do { view in
            view.backgroundColor = .black.withAlphaComponent(0.4)
            view.roundCorners(cornerRadius: 3)
        }
        
        logTextView.do { textView in
            textView.backgroundColor = .black.withAlphaComponent(0.6)
            textView.isEditable = false
            textView.isSelectable = false
            textView.delegate = self
            textView.font = .systemFont(ofSize: 10)
            textView.textColor = .white
            textView.contentInset = .init(top: 2, left: 5, bottom: 2, right: 5)
            textView.roundCorners(cornerRadius: 16)
            textView.layer.cornerCurve = .continuous
        }
    }
    
    // MARK: - Private Func
    
    private func setupHierarchy() {
        floatingView.addSubviews(logTextView, floatingViewGrabber)
        addSubviews(floatingView, floatingButton)
    }
    
    private func setupLayout() {
        
        floatingViewGrabber.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(7)
            make.width.equalTo(90)
            make.height.equalTo(6)
        }
        
        if #available(iOS 16.0, *) {
            floatingView.anchorPoint = .init(x: 0.5, y: 0)
            floatingView.snp.makeConstraints { make in
                make.centerY.equalTo(safeAreaLayoutGuide.snp.top)
                make.horizontalEdges.equalToSuperview().inset(20)
                make.height.equalTo(300)
            }
        } else {
            floatingView.snp.makeConstraints { make in
                make.top.equalTo(safeAreaLayoutGuide)
                make.horizontalEdges.equalToSuperview().inset(20)
                make.height.equalTo(300)
            }
        }
        
        logTextView.snp.makeConstraints { make in
            make.top.equalTo(floatingViewGrabber.snp.bottom).offset(7)
            make.horizontalEdges.bottom.equalToSuperview().inset(5)
        }
    }
    
}

//MARK: - UITextViewDelegate

extension ConsoleLogView: UITextViewDelegate {
    
}
