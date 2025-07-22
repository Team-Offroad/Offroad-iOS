//
//  CourseQuestPopUp.swift
//  Offroad-iOS
//
//  Created by  정지원 on 7/1/25.
//
import UIKit

import SnapKit

final class CourseQuestToastView: ORBToastView {

    init(message: String, highlight: ((UILabel) -> Void)? = nil) {
        super.init(message: message, withImage: UIImage(resource: .icnCheckFilled))

        resetIconLayout()

        highlight?(messageLabel)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// 기존 ORBToastView의 레이아웃을 덮어쓰기 위한 함수
    private func resetIconLayout() {
        imageView.snp.removeConstraints()

        imageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(21)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(22)
        }

        messageLabel.snp.remakeConstraints {
            $0.leading.equalTo(imageView.snp.trailing).offset(11)
            $0.trailing.lessThanOrEqualToSuperview().inset(24)
            $0.centerY.equalToSuperview()
            $0.verticalEdges.equalToSuperview().inset(10.8)
        }
    }
}


