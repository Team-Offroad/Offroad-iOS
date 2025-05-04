//
//  ORBRecommendationChatDataSource.swift
//  ORB_Dev
//
//  Created by 김민성 on 5/4/25.
//

import UIKit

final class ORBRecommendationChatDataSource: UICollectionViewDiffableDataSource<Int, CharacterChatItem> {
    
    init(collectionView: UICollectionView) {
        let orbCharacterCellRegistration = UICollectionView.CellRegistration<ChatLogCellCharacter, CharacterChatMessageItem>(
            handler: { cell, indexPath, item in
                cell.setRecommendationMode()
                cell.configure(with: item, characterName: "오브")
            }
        )
        
        let userCellRegistration = UICollectionView.CellRegistration<ChatLogCellUser, CharacterChatMessageItem>(
            handler: { cell, indexPath, item in
                cell.setRecommendationMode()
                cell.configure(with: item)
            }
        )
        
        let orbCharacterLoadingCellRegistration = UICollectionView.CellRegistration<ChatLogCellCharacterLoading, CharacterChatItem>(
            handler: { cell, indexPath, item in
                cell.setRecommendationMode()
                cell.configure(with: item, characterName: "오브")
            }
        )
        
        super.init(collectionView: collectionView) { collectionView, indexPath, item in
            switch item {
            case .message(let messageItem):
                switch messageItem {
                case .user:
                    return collectionView.dequeueConfiguredReusableCell(
                        using: userCellRegistration,
                        for: indexPath,
                        item: messageItem
                    )
                case .orbCharacter:
                    return collectionView.dequeueConfiguredReusableCell(
                        using: orbCharacterCellRegistration,
                        for: indexPath,
                        item: messageItem
                    )
                }
            case .loading:
                return collectionView.dequeueConfiguredReusableCell(
                    using: orbCharacterLoadingCellRegistration,
                    for: indexPath,
                    item: item
                )
            }
        }
    }
    
    func applySnapshot(
        of chats: [CharacterChatItem],
        animatingDifferences: Bool = true,
        completion: (() -> Void)? = nil
    ) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, CharacterChatItem>()
        snapshot.appendSections([0])
        snapshot.appendItems(chats, toSection: 0)
        self.apply(snapshot, animatingDifferences: animatingDifferences, completion: completion)
    }
}
