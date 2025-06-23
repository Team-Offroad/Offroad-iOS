//
//  ORBRecommendationChatViewController.swift
//  ORB_Dev
//
//  Created by 김민성 on 5/4/25.
//

import Combine
import UIKit

import RxSwift
import RxCocoa

final class ORBRecommendationChatViewController: UIViewController {
    
    // MARK: - Properties
    
    /// 추천소 채팅 로그 뷰에서 장소 추천 채팅이 성공했을 때 이벤트를 방출하는 `PassthroughSubject`
    // RxSwift에서 PublishRelay 역할
    let shouldUpdatePlaces = PassthroughSubject<[ORBRecommendationPlaceModel], Never>()
    
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
private extension ORBRecommendationChatViewController {
    
    func sendChat(text: String) {
        // 채팅이 시작하면 X 버튼 비활성화
        rootView.xButton.isEnabled = false
        
        let myNewChatItem = CharacterChatItem.message(
            .user(content: text, createdDate: Date(), id: nil)
        )
        chats.append(myNewChatItem)
        dataSource.applySnapshot(of: chats) { [weak self] in
            guard let self else { return }
            let loadingChatItem = CharacterChatItem.loading(createdDate: Date())
            self.chats.append(loadingChatItem)
            self.dataSource.applySnapshot(of: self.chats) {
                self.getChatResponse(onSending: text)
            }
        }
    }
    
    /// 서버에 채팅을 요청하고 응답값을 받아서 UI에 반영하는 함수.
    /// - Parameter text: (서버에) 보낼 체팅 문구
    func getChatResponse(onSending text: String) {
        
        /// 응답 메시지를 채팅 화면에 반영하는 함수.
        ///
        /// `getChatResponse(onSending:)`의 중첩 함수임.
        func addReply(_ reply: String) {
            let characterAnswerChatItem = CharacterChatItem.message(
                .orbCharacter(content: reply, createdDate: Date(), id: nil)
            )
            if case .loading = chats.last {
                self.chats.removeLast()
            }
            self.chats.append(characterAnswerChatItem)
            self.dataSource.applySnapshot(of: self.chats)
        }
        
        Task { [weak self] in
            guard let self else { return }
            defer {
                // 채팅이 끝난 후에는 X버튼, 전송 버튼 활성화.
                rootView.xButton.isEnabled = true
                rootView.chatInputView.isSendingAllowed = true
            }
            
            let characterReply = await getChatReplyText(onSending: text)
            addReply(characterReply)
        }
    }
    
    /// 채팅을 보낸 후 캐릭터가 답변할 텍스트를 비동기적으로 반환하는 함수. 추천 로직 결과 및 추천 장소 유무에 따라 분기처리됨.
    /// - Parameter text: 사용자가 채팅을 보낸 문자열
    /// - Returns: 캐릭터가 답변할 텍스트 문자열.
    func getChatReplyText(onSending text: String) async -> String {
        let networkService = NetworkService.shared.orbRecommendationService
        guard let (recommendationSuccess, answer) = try? await networkService.sendRecommendationChat(content: text) else {
            return "이런...장소 추천에 실패했어..잠시 후에 다시 시도해볼래?"
        }
        
        // 서버의 장소 추천 로직이 성공하였는가?
        guard recommendationSuccess else {
            // 서버 로직 상 추천이 되지 않았을 경우
            return answer
        }
        
        // 추천 장소 목록을 성공적으로 불러왔는가?
        guard let recommendedPlaces = try? await networkService.getRecommendedPlaces() else {
            // 업데이트된 추천 장소 목록을 받아오는 데 실패한 경우
            return "이런...추천 장소 목록을 받아오는 데 실패했어..잠시 후에 다시 시도해볼래?"
        }
        // 업데이트된 추천 장소 목록 외부로 전파.
        shouldUpdatePlaces.send(recommendedPlaces)
        
        // 추천 장소 목록이 비어있지는 않은가?
        guard !recommendedPlaces.isEmpty else {
            // 장소 추천 로직은 성공했으나, 추천된 장소가 하나도 없는 경우
            return "적절한 장소를 찾지 못했어..다른 조건으로 장소를 찾아봐줄래?"
        }
        
        // (서버 추천 로직 성공 && 추천 장소 업데이트 성공 && 추천 장소 목록 존재) 인 경우
        return answer
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
