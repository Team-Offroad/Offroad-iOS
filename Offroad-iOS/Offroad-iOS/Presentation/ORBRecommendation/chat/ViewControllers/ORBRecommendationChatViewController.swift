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
    
    private let rootView = ORBRecommendationChatView()
    private let firstChatText: String
    private var firstChatItem: CharacterChatItem {
        CharacterChatItem.message(
            .orbCharacter(content: firstChatText, createdDate: Date(), id: nil)
        )
    }
    private lazy var chats: [CharacterChatItem] = [firstChatItem]
    private lazy var dataSource = ORBRecommendationChatDataSource(collectionView: rootView.collectionView)
    private var disposeBag = DisposeBag()
    
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
        dataSource.applySnapshot(of: chats, animatingDifferences: false)
        bindActions()
        rootView.chatInputView.startChat()
    }
    
}

// Initial Settings
private extension ORBRecommendationChatViewController {
    
    func bindActions() {
        rootView.xButton.rx.tap.asDriver().drive { _ in
            self.dismiss(animated: true)
        }.disposed(by: disposeBag)
        
        // 채팅 UI 테스트용 - 번갈아가며 채팅 내용 입력할 수 있도록 임시로 구현
        rootView.chatInputView.onSendingText.subscribe(onNext: { [weak self] text in
            guard let self else { return }
            self.rootView.exampleQuestionListView.isHidden = true
            self.sendChat(text: text)
        }).disposed(by: disposeBag)
        
        rootView.exampleQuestionListView.exampleQuestionSelected
            .asDriver(onErrorJustReturn: "")
            .drive { [weak self] text in
                guard let self else { return }
                self.rootView.exampleQuestionListView.isHidden = true
                self.sendChat(text: text)
        }.disposed(by: disposeBag)
    }
    
}

// Custom Transition 관련
extension ORBRecommendationChatViewController {
    
    var firstCell: ChatLogCellCharacter? {
        rootView.collectionView.cellForItem(at: .init(item: 0, section: 0)) as? ChatLogCellCharacter
    }
    
    var firstChatBubbleFrame: CGRect? {
        guard let firstCell else { return nil }
        return firstCell.chatBubble.convert(firstCell.chatBubble.frame, to: rootView)
    }
    
    var firstChatBubbleAlpha: CGFloat {
        get { firstCell?.chatBubble.alpha ?? 0.0 }
        set { firstCell?.chatBubble.alpha = newValue }
    }
    
    var collectionViewAlpha: CGFloat {
        get { rootView.collectionView.alpha }
        set { rootView.collectionView.alpha = newValue }
    }
    
}

// 채팅 기능 관련
extension ORBRecommendationChatViewController {
    
    func sendChat(text: String) {
        let myNewChatItem = CharacterChatItem.message(
            .user(content: text, createdDate: Date(), id: nil)
        )
        chats.append(myNewChatItem)
        dataSource.applySnapshot(of: chats) { [weak self] in
            guard let self else { return }
            let loadingChatItem = CharacterChatItem.loading(createdDate: Date())
            self.chats.append(loadingChatItem)
            self.dataSource.applySnapshot(of: self.chats)
        }
        
        Task { [weak self] in
            guard let self else { return }
            do {
                let networkService = NetworkService.shared.orbRecommendationService
                let (recommendationSuccess, answer) = try await networkService.sendRecommendationChat(content: text)
                
                // 서버 내부 장소 추천 로직이 성공했을 때 처리
                if recommendationSuccess {
                    // ...외부로 이벤트 방출 필요 -> Combine 사용 시도?
                }
                
                // 응답 메시지 채팅 화면에 반영
                let characterAnswerChatItem = CharacterChatItem.message(
                    .orbCharacter(content: answer, createdDate: Date(), id: nil)
                )
                self.chats.removeLast()
                self.chats.append(characterAnswerChatItem)
                self.dataSource.applySnapshot(of: self.chats)
            } catch let error as NetworkResultError {
                switch error {
                case .timeout, .notConnectedToInternet, .unknownURLError(_):
                    showToast(message: ErrorMessages.networkError, inset: 66)
                default:
                    showToast(message: "문제가 발생했어요. 잠시 후 다시 시도해 주세요.", inset: 66)
                }
            }
            // 채팅이 끝난 후에는 전송 버튼 활성화.
            rootView.chatInputView.isSendingAllowed = true
        }
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
            case .orbRecommendation:
                fatalError("오브의 추천소 채팅에는 추천소로 이동을 유도하는 셀이 존재할 수 없습니다.")
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
