//
//  ORBEmptyCaseStyle.swift
//  Offroad-iOS
//
//  Created by 김민성 on 4/4/25.
//

import UIKit

import SnapKit

public protocol ORBEmptyCaseStyle: UIView {
    
    associatedtype placeholder: ORBEmptyCaseViewType
    
    func showEmptyPlaceholder(view: placeholder)
    func removeEmptyPlaceholder()
    
}

public extension ORBEmptyCaseStyle {
    
    func showEmptyPlaceholder(view: placeholder) {
        addSubview(view)
        view.snp.makeConstraints { make in
            if let scrollView = self as? UIScrollView {
                make.edges.equalTo(scrollView.frameLayoutGuide)
            } else {
                make.edges.equalToSuperview()
            }
        }
        layoutIfNeeded()
    }
    
    func removeEmptyPlaceholder() {
        subviews.forEach { view in
            if view is placeholder {
                view.removeFromSuperview()
            }
        }
    }
    
}

public protocol ORBEmptyCaseViewType: UIView {
    var emptyCaseMessage: String { get }
}
