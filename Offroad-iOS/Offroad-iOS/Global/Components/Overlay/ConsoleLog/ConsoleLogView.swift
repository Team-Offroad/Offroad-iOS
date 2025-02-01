//
//  ConsoleLogView.swift
//  ORB(Dev)
//
//  Created by 김민성 on 1/31/25.
//

import UIKit

class ConsoleLogView: UIView {
    
//    let floatingButton = ShrinkableButton(shrinkScale: 0.9)
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
        
        logTextView.do { textView in
            textView.backgroundColor = .black.withAlphaComponent(0.6)
            textView.isHidden = true
            textView.isEditable = false
            textView.isSelectable = false
            textView.delegate = self
            textView.font = .systemFont(ofSize: 14)
            textView.textColor = .white
            textView.contentInset = .init(top: 5, left: 5, bottom: 5, right: 5)
            textView.roundCorners(cornerRadius: 20)
            textView.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
            let transform = CGAffineTransform(scaleX: 1, y: 0.1)
            textView.transform = transform
        }
    }
    
    // MARK: - Private Func
    
    private func setupHierarchy() {
        addSubviews(logTextView, floatingButton)
    }
    
    private func setupLayout() {
        if #available(iOS 16.0, *) {
            logTextView.anchorPoint = .init(x: 0.5, y: 0)
            logTextView.snp.makeConstraints { make in
                make.centerY.equalTo(safeAreaLayoutGuide.snp.top)
                make.horizontalEdges.equalToSuperview().inset(20)
                make.height.equalTo(100)
            }
        } else {
            logTextView.snp.makeConstraints { make in
                make.top.equalTo(safeAreaLayoutGuide)
                make.horizontalEdges.equalToSuperview().inset(20)
                make.height.equalTo(100)
            }
        }
    }
    
}

//MARK: - UITextViewDelegate

extension ConsoleLogView: UITextViewDelegate {
    
}
