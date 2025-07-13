//
//  CourseQuestToastWindow.swift
//  Offroad-iOS
//
//  Created by  정지원 on 7/13/25.
//

import UIKit

final class CourseQuestToastWindow: ORBToastWindow {

    init(message: String, inset: CGFloat = 66.3, withImage image: UIImage? = nil, highlight: ((UILabel) -> Void)? = nil) {
        let toastView = CourseQuestToastView(message: message, highlight: highlight)
        super.init(toastView: toastView, inset: inset)
    }

    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
