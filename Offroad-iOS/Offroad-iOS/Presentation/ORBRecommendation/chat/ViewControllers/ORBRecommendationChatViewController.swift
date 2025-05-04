//
//  ORBRecommendationChatViewController.swift
//  ORB_Dev
//
//  Created by 김민성 on 5/4/25.
//

import UIKit

import RxSwift
import RxCocoa

final class ORBRecommendationChatViewController: UIViewController {
    
    // MARK: - Properties
    
    private let firstChatText: String
    private var firstChatItem: CharacterChatItem {
        CharacterChatItem.message(
            .orbCharacter(content: firstChatText, createdDate: Date(), id: nil)
        )
    }
    private lazy var chats: [CharacterChatItem] = [firstChatItem]
    private lazy var dataSource = ORBRecommendationChatDataSource(collectionView: rootView.collectionView)
    private var disposeBag = DisposeBag()
    private(set) var rootView = ORBRecommendationChatView()
    
    // MARK: - Life Cycle
    
    init(firstChatText: String = "") {
        self.firstChatText = firstChatText
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rootView.collectionView.delegate = self
        dataSource.applySnapshot(of: chats)
        bindActions()
    }
    
}

// Initial Settings
private extension ORBRecommendationChatViewController {
    
    func bindActions() {
        rootView.xButton.rx.tap.asDriver().drive { _ in
            self.dismiss(animated: true)
        }.disposed(by: disposeBag)
        
        // 채팅 UI 테스트용
        rootView.chatInputView.onSendingText.subscribe(onNext: { [weak self] text in
            guard let self else { return }
            let lastChatItem = dataSource.snapshot().itemIdentifiers.last!
            let newChatItem: CharacterChatItem
            switch lastChatItem {
            case .message(let messageItem):
                switch messageItem {
                case .user:
                    newChatItem = CharacterChatItem.message(.orbCharacter(content: text, createdDate: Date(), id: 0))
                case .orbCharacter:
                    newChatItem = CharacterChatItem.message(.user(content: text, createdDate: Date(), id: 0))
                }
            case .loading:
                return
            }
            
            self.chats.append(newChatItem)
            self.dataSource.applySnapshot(of: self.chats) {
                self.rootView.chatInputView.isSendingAllowed = true
            }
            self.rootView.collectionView.scrollToItem(at: .init(item: self.chats.count - 1, section: 0), at: .top, animated: true)
        }).disposed(by: disposeBag)
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ORBRecommendationChatViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return .zero }
        switch item {
        case .message(let messageItem):
            switch messageItem {
            case .user:
                return ChatLogCellUser.calculatedCellSize(
                    item: messageItem,
                    fixedWidth: collectionView.bounds.width
                )
            case .orbCharacter:
                return ChatLogCellCharacter.calculatedCellSize(
                    item: messageItem,
                    characterName: "오브",
                    fixedWidth: collectionView.bounds.width
                )
            }
        case .loading:
            return ChatLogCellCharacterLoading.calculatedCellSize(
                item: .loading(createdDate: Date()),
                characterName: "오브",
                fixedWidth: collectionView.bounds.width
            )
        }
    }
    
}

