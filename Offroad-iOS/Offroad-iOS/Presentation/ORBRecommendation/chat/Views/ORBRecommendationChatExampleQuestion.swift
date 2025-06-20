//
//  ORBRecommendationChatExampleQuestion.swift
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
    var highlightedTexts: [String]
}

private let question1 = ORBRecommendationChatExampleQuestion(
    title: "강남에 가는데\n오늘 날씨에 맞는 식당 추천해줘.",
    highlightedTexts: ["강남", "오늘 날씨에 맞는 식당"]
)
private let question2 = ORBRecommendationChatExampleQuestion(
    title: "기분이 별로야.\n판교에 스트레스 풀릴 음식 없나?",
    highlightedTexts: ["판교", "스트레스 풀릴"]
)
private let question3 = ORBRecommendationChatExampleQuestion(
    title: "여의도 점심 메뉴 추천해주라.\n소화 잘 되는 음식이면 좋겠어.",
    highlightedTexts: ["여의도 점심 메뉴"]
)

/// 오브의 추천소 채팅에서 예시 질의 버튼을 나타낼 버튼
fileprivate final class ExampleQuestionButton: ShrinkableButton {
    
    // MARK: - Properties
    
    let question: ORBRecommendationChatExampleQuestion
    
    // MARK: - Life Cycle
    
    init(question: ORBRecommendationChatExampleQuestion) {
        self.question = question
        super.init(frame: .zero)
        backgroundColor = .whiteOpacity(.white75)
        /// - NOTE: contentEdgeInsets 는 configuration을 사용하면 무시되기 때문에, configuration 사용 시 주의 필요.
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
        
        for highlightedText in question.highlightedTexts {
            let range = (question.title as NSString).range(of: highlightedText)
            attributedString.addAttribute(
                .foregroundColor,
                value: UIColor.blackOpacity(.black55),
                range: range
            )
        }
        titleLabel?.attributedText = attributedString
        titleLabel?.setLineHeight(percentage: 160)
        /// `setAttributedTitle(_:for:)` 메서드의 매개변수로 `NSAttributedString`이 들어가므로,
        /// 모든 `attribute`들을 다 적용한 후에 마지막으로 이 메서드를 호출해야 함.
        setAttributedTitle(titleLabel?.attributedText, for: .normal)
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
    
    private let button1 = ExampleQuestionButton(question: question1)
    private let button2 = ExampleQuestionButton(question: question2)
    private let button3 = ExampleQuestionButton(question: question3)
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
        if view is ExampleQuestionButton {
            return true
        }
        return super.touchesShouldCancel(in: view)
    }
    
}

// 오브의 추천소 채팅에서 예시 질의를 보여줄 Scroll View의 Initial Settings
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
