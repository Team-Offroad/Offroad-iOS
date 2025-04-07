//
//  QuestListCollectionView.swift
//  Offroad-iOS
//
//  Created by 김민성 on 4/4/25.
//

import UIKit

/// 퀘스트 목록을 보여줄 collection view
final class QuestListCollectionView: UICollectionView, ORBEmptyCaseStyle, ORBCenterLoadingStyle, ORBScrollLoadingStyle {
    
    typealias placeholder = QuestListEmptyPlaceholder
    
    // MARK: - UI Properties
    
    let emptyPlaceholder = QuestListEmptyPlaceholder()
    
    // MARK: - Life Cycle
    
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = .init(top: 20, left: 24, bottom: 0, right: 24)
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 100
        layout.estimatedItemSize.width = UIScreen.current.bounds.width - 32
        
        super.init(frame: .zero, collectionViewLayout: layout)
        
        indicatorStyle = .black
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension QuestListCollectionView {
    
    func showEmptyPlaceholder() {
        showEmptyPlaceholder(view: emptyPlaceholder)
    }
    
    func setEmptyState(_ emptyState: Bool) {
        if emptyState {
            showEmptyPlaceholder()
        } else {
            removeEmptyPlaceholder()
        }
    }
    
}
