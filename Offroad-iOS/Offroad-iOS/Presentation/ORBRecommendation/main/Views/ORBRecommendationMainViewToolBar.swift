//
//  ORBRecommendationMainViewToolBar.swift
//  ORB_Dev
//
//  Created by 김민성 on 4/24/25.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit

final class ORBRecommendationMainViewToolBar: UIView {
    
    // MARK: - Properties
    
    var onListButtonTapped: () -> Void = {}
    var onMapButtonTapped: () -> Void = {}
    private var disposeBag = DisposeBag()
    
    // MARK: - UI Properties
    
    private let toolBarLeftLabel = UILabel()
    private let selectMapButton = ToolBarButton()
    private let selectListButton = ToolBarButton()
    private let toolBarButtonSeparator = UIView()
    private lazy var buttonStack = UIStackView(
        arrangedSubviews: [selectListButton, toolBarButtonSeparator, selectMapButton]
    )
    private let toolBarDivider = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupStyle()
        setupHierarchy()
        setupLayout()
        setupButtonActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// Initial Settings
private extension ORBRecommendationMainViewToolBar {
    
    private func setupStyle() {
        toolBarLeftLabel.do { label in
            label.font = .offroad(style: .iosTextContents)
            label.textAlignment = .left
            label.textColor = .main(.main2)
            label.text = "추천 장소"
        }
        toolBarButtonSeparator.backgroundColor = .main(.main2)
        selectMapButton.configuration?.title = "지도"
        selectListButton.configuration?.title = "리스트"
        toolBarDivider.backgroundColor = .grayscale(.gray100)
        
        buttonStack.do { stackView in
            stackView.axis = .horizontal
            stackView.alignment = .center
            stackView.distribution = .fillProportionally
        }
        
        selectListButton.isSelected = true
        selectMapButton.isSelected = false
    }
    
    private func setupHierarchy() {
        addSubviews(toolBarLeftLabel, buttonStack, toolBarDivider)
    }
    
    private func setupLayout() {
        toolBarLeftLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(24)
            make.centerY.equalToSuperview()
        }
        
        toolBarButtonSeparator.snp.makeConstraints { make in
            make.width.equalTo(1)
            make.height.equalTo(11)
        }
        
        buttonStack.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(24)
        }
        
        toolBarDivider.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    private func setupButtonActions() {
        selectListButton.rx.tap.asDriver().drive(onNext: { [weak self] in
            guard let self else { return }
            self.selectListButton.isSelected = true
            self.selectMapButton.isSelected = false
            onListButtonTapped()
        }).disposed(by: disposeBag)
        
        selectMapButton.rx.tap.asDriver().drive(onNext: { [weak self] in
            guard let self else { return }
            self.selectListButton.isSelected = false
            self.selectMapButton.isSelected = true
            onMapButtonTapped()
        }).disposed(by: disposeBag)
    }
    
}

fileprivate final class ToolBarButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configuration = UIButton.Configuration.plain()
        self.configurationUpdateHandler = { button in
            button.configuration!.contentInsets = .init(top: 16, leading: 10, bottom: 16, trailing: 10)
            button.configuration!.baseBackgroundColor = .clear
            button.configuration!.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
                var outgoing = incoming
                switch button.state {
                case .selected:
                    outgoing.foregroundColor = .main(.main2)
                    outgoing.font = .offroad(style: .iosTooltipNumber)
                default:
                    outgoing.foregroundColor = .grayscale(.gray300)
                    outgoing.font = .offroad(style: .iosTextContentsSmall)
                }
                return outgoing
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
