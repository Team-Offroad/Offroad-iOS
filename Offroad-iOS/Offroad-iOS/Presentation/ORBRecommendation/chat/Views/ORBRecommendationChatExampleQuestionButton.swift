//
//  ORBRecommendationChatExampleQuestionButton.swift
//  ORB_Dev
//
//  Created by 김민성 on 5/7/25.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit

/// 오브의 추천소 채팅에서 예시 질의 데이터
fileprivate struct ORBRecommendationChatExampleQuestion {
    var title: String
    var highlightedText: String
}

private let question1 = ORBRecommendationChatExampleQuestion(
    title: "오늘 날씨에 맞는 식당을\n추천해줘.",
    highlightedText: "오늘 날씨에 맞는 식당"
)
private let question2 = ORBRecommendationChatExampleQuestion(
    title: "기분이 별로야.\n스트레스 풀릴만한 음식 없을까?",
    highlightedText: "스트레스 풀릴만한 음식"
)
private let question3 = ORBRecommendationChatExampleQuestion(
    title: "신촌역 근처에\n분위기 좋은 카페 좀 찾아줘.",
    highlightedText: "신촌역 근처에\n분위기 좋은 카페"
)

/// 오브의 추천소 채팅에서 예시 질의 버튼을 나타낼 버튼
fileprivate final class ORBRecommendationChatExampleQuestionButton: ShrinkableButton {
    
    // MARK: - Properties
    
    let question: ORBRecommendationChatExampleQuestion
    
    // MARK: - Life Cycle
    
    init(question: ORBRecommendationChatExampleQuestion) {
        self.question = question
        super.init(frame: .zero)
        backgroundColor = .whiteOpacity(.white75)
        contentEdgeInsets = .init(top: 10, left: 19, bottom: 10, right: 19)
        layer.cornerCurve = .continuous
        configureTitleDesign(with: question)
        roundCorners(cornerRadius: 15)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 버튼의 `title`중 특정 텍스트를 강조 하는 메서드.
    /// - Parameter question: 버튼에 표시할 예시 질의 데이터
    private func configureTitleDesign(with question: ORBRecommendationChatExampleQuestion) {
        let attributedString = NSMutableAttributedString(string: question.title)
        let range = (question.title as NSString).range(of: question.highlightedText)
        attributedString.addAttribute(
            .foregroundColor,
            value: UIColor.blackOpacity(.black55),
            range: range
        )
        setAttributedTitle(attributedString, for: .normal)
        setTitleColor(.blackOpacity(.black25), for: .normal)
        titleLabel?.numberOfLines = 2
        titleLabel?.font = .offroad(style: .iosBoxMedi)
    }
    
}

/// 오브의 추천소 채팅에서 예시 질의 버튼을 띄울 스크롤 뷰. 채팅 입력창 위에 표시되며 가로로 스크롤됨.
final class ORBRecommendationChatExampleQuestionListView: UIScrollView {
    
    // MARK: - Properties
    
    // Rx Properties
    private var disposeBag = DisposeBag()
    let exampleQuestionSelected = PublishRelay<String>()
    
    // MARK: - UI Properties
    
    private let button1 = ORBRecommendationChatExampleQuestionButton(question: question1)
    private let button2 = ORBRecommendationChatExampleQuestionButton(question: question2)
    private let button3 = ORBRecommendationChatExampleQuestionButton(question: question3)
    private lazy var buttonStack = UIStackView(arrangedSubviews: [button1, button2, button3])
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setupStyle()
        setupHierarchy()
        setupLayout()
        bindActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesShouldCancel(in view: UIView) -> Bool {
        if view is ORBRecommendationChatExampleQuestionButton {
            return true
        }
        return super.touchesShouldCancel(in: view)
    }
    
}

// Initial Settings
private extension ORBRecommendationChatExampleQuestionListView {
    
    func setupStyle() {
        contentInset = .init(top: 0, left: 24, bottom: 0, right: 24)
        contentOffset = .init(x: -24, y: 0)
        delaysContentTouches = false
        showsHorizontalScrollIndicator = false
        
        buttonStack.do { stackView in
            stackView.axis = .horizontal
            stackView.spacing = 12
            stackView.alignment = .fill
            stackView.distribution = .fill
        }
    }
    
    func setupHierarchy() {
        addSubview(buttonStack)
    }
    
    func setupLayout() {
        buttonStack.snp.makeConstraints { make in
            make.verticalEdges.equalTo(frameLayoutGuide)
            make.horizontalEdges.equalTo(contentLayoutGuide)
        }
    }
    
    func bindActions() {
        [button1, button2, button3].forEach { button in
            button.rx.tap.asDriver().drive { [weak self] _ in
                self?.exampleQuestionSelected.accept(button.question.title)
            }.disposed(by: self.disposeBag)

        }
    }
    
}
