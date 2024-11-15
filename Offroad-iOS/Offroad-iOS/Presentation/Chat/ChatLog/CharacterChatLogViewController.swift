//
//  CharacterChatLogViewController.swift
//  Offroad-iOS
//
//  Created by 김민성 on 11/12/24.
//

import UIKit

class CharacterChatLogViewController: OffroadTabBarViewController {
    
    //MARK: - Properties
    
    private let chatButtonHidingAnimator = UIViewPropertyAnimator(duration: 0.5, dampingRatio: 1)
    private let rootView: CharacterChatLogView
    private var chatLogDataList: [ChatData] = []
    private var chatLogDataSource: [[ChatData]] = [[]]
    private var isChatButtonHidden: Bool = false
    
    //MARK: - Life Cycle
    
    init(background: UIView) {
        rootView = CharacterChatLogView(background: background)
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
        
        setupTargets()
        setupDelegates()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let tabBarController = tabBarController as? OffroadTabBarController else { return }
        tabBarController.showTabBarAnimation()
        rootView.backgroundView.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        rootView.backgroundView.isHidden = false
        guard let tabBarController = tabBarController as? OffroadTabBarController else { return }
        tabBarController.enableTabBarInteraction()
        
        DispatchQueue.main.asyncAfter(
            deadline: .now() + 0.3,
            execute: { [weak self] in
                guard let self else { return }
                self.chatLogDataList = [
                    ChatData(role: "USER", content: "안녕!", createdAt: "2024-11-14T00:36:21.057055"),
                    ChatData(role: "ORB_CHARACTER", content: "오랜만이네! 그동안 뭐 했어?", createdAt: "2024-11-14T00:36:21.060499"),
                    ChatData(role: "USER", content: "안녕!", createdAt: "2024-11-14T15:17:56.081005"),
                    ChatData(role: "ORB_CHARACTER", content: "오랜만이네! 그동안 뭐 했어?", createdAt: "2024-11-14T22:20:53.193968"),
                    ChatData(role: "USER", content: "만나서 반가워", createdAt: "2024-11-14T15:17:56.081005"),
                    ChatData(role: "ORB_CHARACTER", content: "난 루미야! 만나서 진짜 반갑다", createdAt: "2024-11-14T22:20:53.20989"),
                    ChatData(role: "USER", content: "너 이름이 루미야?", createdAt: "2024-11-14T22:28:56.40375"),
                    ChatData(role: "ORB_CHARACTER", content: "응 맞아! 나는 루미라고 해", createdAt: "2024-11-14T22:28:56.40531"),
                    ChatData(role: "USER", content: "오늘 저녁으로 뭐 먹었어?", createdAt: "2024-11-14T23:15:42.845442"),
                    ChatData(role: "ORB_CHARACTER", content: "나는 먹을 수 없어! 나는 별이라서 음식을 먹지는 못하지만 네가 먹은 건 정말 맛있었을 것 같아!", createdAt: "2024-11-14T23:15:43.264053"),
                    ChatData(role: "USER", content: "안녕?", createdAt: "2024-11-15T01:04:20.099255"),
                    ChatData(role: "ORB_CHARACTER", content: "오랜만이네! 그동안 뭐하고 지냈어?", createdAt: "2024-11-15T01:04:20.179212"),
                    ChatData(role: "USER", content: "만나서 반가워", createdAt: "2024-11-15T01:04:52.32285"),
                    ChatData(role: "ORB_CHARACTER", content: "나는 루미라고 해! 나와 함께 모험을 떠나지 않을래?", createdAt: "2024-11-15T01:04:52.326831"),
                    ChatData(role: "USER", content: "어디로 떠나?", createdAt: "2024-11-15T01:05:05.892205"),
                    ChatData(role: "ORB_CHARACTER", content: "마지막으로 갔던 곳은 어땠어?", createdAt: "2024-11-15T01:05:05.895514"),
                    ChatData(role: "USER",content: "좋았어.\n너가 마지막으로 떠난 곳은 어디야?",createdAt: "2024-11-15T01:05:36.241319"),
                    ChatData(role: "ORB_CHARACTER",content: "내가 마지막으로 떠났던 곳은 '한강공원'이야. 거기서 산책하면서 강을 바라보는 게 참 좋더라고!",createdAt: "2024-11-15T01:05:36.243746"),
                    ChatData(role: "USER",content: "어디 한강공원?",createdAt: "2024-11-15T01:05:57.415001"),
                    ChatData(role: "ORB_CHARACTER",content: "반포한강공원! 거기 밤도깨비 야시장 가봤어?",createdAt: "2024-11-15T01:05:57.419354"),
                    ChatData(role: "USER",content: "오 거기 맛있지.\n근데 거기 밤도깨비 야시장 할 때는 사람이 너무 많아서 자리 잡기가 힘들었어...",createdAt: "2024-11-15T01:06:45.978242"),
                    ChatData(role: "ORB_CHARACTER",content: "맞아! 밤도깨비 야시장 기간에는 사람이 너무 많아서 힘들긴 하지만 맛있는 음식도 많고 분위기도 좋아서 나는 좋더라!",createdAt: "2024-11-15T01:06:45.987619"),
                    ChatData(role: "USER",content: "거기서 뭐 먹었어?",createdAt: "2024-11-15T01:07:08.256136"),
                    ChatData(role: "ORB_CHARACTER",content: "마지막으로 먹었던 음식 맛있었어?",createdAt: "2024-11-15T01:07:08.258636"),
                    ChatData(role: "USER",content: "너는 뭐 먹었어?",createdAt: "2024-11-15T01:07:58.049077"),
                    ChatData(role: "ORB_CHARACTER",content: "나는 에너지를 모아 둬서 음식을 먹지 않아도 괜찮아! 그래도 네가 먹는 건 궁금한데, 오늘은 맛있는 거 먹었니?",createdAt: "2024-11-15T01:07:58.053557"),
                    ChatData(role: "USER",content: "오늘은 오므라이스 먹었음",createdAt: "2024-11-15T01:08:17.219935"),
                    ChatData(role: "ORB_CHARACTER",content: "오므라이스 맛있었겠다! 난 저번에 먹은 돈까스 맛있었는데 넌 어땠어?",createdAt: "2024-11-15T01:08:17.222784")
                    
                ]
                self.rootView.chatLogCollectionView.reloadData()
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        rootView.backgroundView.isHidden = true
    }
    
}

extension CharacterChatLogViewController {
    
    //MARK: - @objc Func
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Private Func
    
    private func setupTargets() {
        rootView.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    private func setupDelegates() {
        rootView.chatLogCollectionView.dataSource = self
        rootView.chatLogCollectionView.delegate = self
    }
    
    private func hideChatButton() {
        guard !isChatButtonHidden else { return }
        isChatButtonHidden = true
        chatButtonHidingAnimator.stopAnimation(true)
        chatButtonHidingAnimator.addAnimations { [weak self] in
            guard let self else { return }
            self.rootView.chatButtonBottomConstraint.constant = 0
            self.rootView.layoutIfNeeded()
        }
        chatButtonHidingAnimator.startAnimation()
    }
    
    private func showChatButton() {
        guard isChatButtonHidden else { return }
        isChatButtonHidden = false
        chatButtonHidingAnimator.stopAnimation(true)
        chatButtonHidingAnimator.addAnimations { [weak self] in
            guard let self else { return }
            self.rootView.chatButtonBottomConstraint.constant = -(self.rootView.safeAreaInsets.bottom + 67.3)
            self.rootView.layoutIfNeeded()
        }
        chatButtonHidingAnimator.startAnimation()
    }
    
}

//MARK: - UICollectionViewDataSource

extension CharacterChatLogViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        chatLogDataList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterChatLogCell.className, for: indexPath) as? CharacterChatLogCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: chatLogDataList[indexPath.item])
        return cell
    }
    
}

//MARK: - UICollectionViewDelegate

extension CharacterChatLogViewController: UICollectionViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollOffsetAtBottom = max(scrollView.contentSize.height - (scrollView.bounds.height - rootView.safeAreaInsets.bottom - 135), 0)
        
        if scrollView.contentOffset.y > scrollOffsetAtBottom {
            showChatButton()
        } else {
            hideChatButton()
        }
    }
    
}
