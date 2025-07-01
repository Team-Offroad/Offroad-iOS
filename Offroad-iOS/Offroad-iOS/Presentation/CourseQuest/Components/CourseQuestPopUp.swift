//
//  CourseQuestPopUp.swift
//  Offroad-iOS
//
//  Created by  정지원 on 7/1/25.
//
import UIKit

import SnapKit
import Then

final class CourseQuestPopUp: UIView {

    // MARK: - UI Components

    private let iconImageView = UIImageView().then {
        $0.image = UIImage(resource: .icnCheckFilled)
        $0.contentMode = .scaleAspectFit
    }

    private let messageLabel = UILabel().then {
        $0.font = .offroad(style: .iosText)
        $0.textColor = .white
        $0.numberOfLines = 0
    }

    // MARK: - Life Cycle

    /// 일반적인 문자열과 하이라이트 클로저를 받아 초기화하는 생성자
    init(message: String, highlight: ((UILabel) -> Void)? = nil) {
        super.init(frame: .zero)
        backgroundColor = .blackOpacity(.black55)
        layer.cornerRadius = 10
        clipsToBounds = true

        addSubviews(iconImageView, messageLabel)

        iconImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(21)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(22)
        }

        messageLabel.snp.makeConstraints {
            $0.leading.equalTo(iconImageView.snp.trailing).offset(11)
            $0.centerY.equalToSuperview()
            $0.trailing.lessThanOrEqualToSuperview().inset(24)
        }

        messageLabel.text = message
        highlight?(messageLabel)
    }

    /// NSAttributedString으로 직접 전달받는 경우를 위한 생성자 (선택사항)
    convenience init(attributedMessage: NSAttributedString) {
        self.init(message: "")
        messageLabel.attributedText = attributedMessage
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Toast Presentation

    static func showPopUp(on view: UIView, message: String, highlight: ((UILabel) -> Void)? = nil) {
        let popup = CourseQuestPopUp(message: message, highlight: highlight)
        popup.alpha = 0
        view.addSubview(popup)

        popup.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(80)
            $0.horizontalEdges.equalToSuperview().inset(24)
        }

        UIView.animate(withDuration: 0.3, animations: {
            popup.alpha = 1
        }, completion: { _ in
            UIView.animate(withDuration: 0.3, delay: 2, options: [], animations: {
                popup.alpha = 0
            }, completion: { _ in
                popup.removeFromSuperview()
            })
        })
    }
}

