//
//  QuestListEmptyPlaceholder.swift
//  Offroad-iOS
//
//  Created by 김민성 on 4/4/25.
//

import UIKit

/// 퀘스트 목록에서 엠티 케이스 시 띄울 뷰
final class QuestListEmptyPlaceholder: UIView, ORBEmptyPlaceholderType {
    
    // MARK: - Properties
    
    var emptyCaseMessage: String = EmptyCaseMessage.activeQuests
    
    let imageView = UIImageView(image: .imgEmptyCaseNova)
    let emptyMessageLabel = UILabel()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupHierarchy()
        setupStyle()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension QuestListEmptyPlaceholder {
    
    private func setupHierarchy() {
        addSubviews(imageView, emptyMessageLabel)
    }
    
    private func setupStyle() {
        imageView.contentMode = .scaleAspectFit
        
        emptyMessageLabel.do { label in
            label.text = emptyCaseMessage
            label.numberOfLines = 0
            label.textAlignment = .center
            label.textColor = .blackOpacity(.black55)
            label.font = .offroad(style: .iosBoxMedi)
        }
    }
    
    private func setupLayout() {
        imageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-40)
            make.size.equalTo(172)
        }
        emptyMessageLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
    }
    
}
