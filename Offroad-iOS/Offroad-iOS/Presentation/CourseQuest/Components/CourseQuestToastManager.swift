//
//  CourseQuestToastManager.swift
//  Offroad-iOS
//
//  Created by  정지원 on 7/13/25.
//
import UIKit

final class CourseQuestToastManager {
    static let shared = CourseQuestToastManager()

    private init() {}

    func show(message: String, inset: CGFloat = 66.3, highlight: ((UILabel) -> Void)? = nil) {
        let view = CourseQuestToastView(message: message, highlight: highlight)
        ORBToastManager.shared.showCustomToast(toastView: view, inset: inset)
    }
}
