//
//  CharacterChatLogViewController.swift
//  Offroad-iOS
//
//  Created by 김민성 on 11/12/24.
//

import UIKit


// 채팅 API 연결 브랜치가 완성되지 않아서 DataSource로 사용할 타입을 임시로 미리 정의.
// 채팅 API 연결 브랜치 main에 머지되면 여기에 있는 코드는 삭제할 예정입니다.
struct ChatData: Codable {
    var role: String // "USER" 또는 "ORB_CHARACTER"
    var content: String
    var createdAt: String
}

class CharacterChatLogViewController: UIViewController {
    
    //MARK: - Properties
    
    private let rootView: CharacterChatLogView
    private var chatLogDataSource: [ChatData] = []
    
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
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: { [weak self] in
            guard let self else { return }
            self.chatLogDataSource = [
                ChatData(role: "USER", content: "안녕!", createdAt: "2024-11-14T00:36:21.057055"),
                ChatData(role: "ORB_CHARACTER", content: "오랜만이네! 그동안 뭐 했어?", createdAt: "2024-11-14T00:36:21.060499"),
                ChatData(role: "USER", content: "안녕!", createdAt: "2024-11-14T15:17:56.081005"),
                ChatData(role: "ORB_CHARACTER", content: "오랜만이네! 그동안 뭐 했어?", createdAt: "2024-11-14T15:17:56.181871")
            ]
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
}

//MARK: - UICollectionViewDataSource

extension CharacterChatLogViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
    }
    
    
}

//MARK: - UICollectionViewDelegate

extension CharacterChatLogViewController: UICollectionViewDelegate {
    
}
