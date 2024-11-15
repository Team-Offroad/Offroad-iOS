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
    private var chatLogDataSource: [ChatDataModel] = []
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
        requestChatLogDataSource()
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
    
    private func requestChatLogDataSource() {
        NetworkService.shared.characterChatService.getChatLog(completion: { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let responseDTO):
                guard let responseDTO else {
                    fatalError()
                }
                chatLogDataSource = responseDTO.data.map({ ChatDataModel(data: $0) })
                rootView.chatLogCollectionView.reloadData()
            case .networkFail:
                showToast(message: "네트워크 연결 상태를 확인해주세요.", inset: 66)
            case .decodeErr:
                showToast(message: "디코딩 에러.", inset: 66)
            default:
                self.showToast(message: "Something went wrong", inset: 60)
            }
        })
    }
    
}

//MARK: - UICollectionViewDataSource

extension CharacterChatLogViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        chatLogDataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterChatLogCell.className, for: indexPath) as? CharacterChatLogCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: chatLogDataSource[indexPath.item])
        return cell
    }
    
}

//MARK: - UICollectionViewDelegate

extension CharacterChatLogViewController: UICollectionViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView.contentSize.height > 0 else { return }
        let scrollOffsetAtBottomEdge =
        max(scrollView.contentSize.height - (scrollView.bounds.height - rootView.safeAreaInsets.bottom - 135), 0)
        
        if scrollView.contentOffset.y >= scrollOffsetAtBottomEdge {
            showChatButton()
        } else {
            hideChatButton()
        }
    }
    
}
