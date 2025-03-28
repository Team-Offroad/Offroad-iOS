//
//  NoticePostViewController.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 8/16/24.
//

import UIKit

import SafariServices

final class NoticePostViewController: UIViewController {
    
    //MARK: - Properties
    
    private let rootView = NoticePostView()
    
    private var noticeDetailInfo: NoticeInfo
    
    // MARK: - Life Cycle
    
    init(noticeInfo: NoticeInfo) {
        noticeDetailInfo = noticeInfo
        
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
        
        rootView.setPostText(data: noticeDetailInfo)
        setupTarget()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let offroadTabBarController = self.tabBarController as? OffroadTabBarController else { return }
        offroadTabBarController.hideTabBarAnimation()
    }
}

extension NoticePostViewController {
    
    // MARK: - Private Method
    
    private func setupTarget() {
        rootView.customBackButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        rootView.contentButton.addTarget(self, action: #selector(contentButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Func
    
    func setupCustomBackButton(buttonTitle: String) {
        rootView.customBackButton.configureButtonTitle(titleString: buttonTitle)
    }

    
    // MARK: - @objc Method
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func contentButtonTapped() {
        let redirectionURL = noticeDetailInfo.externalLinks[0]
        guard let url = URL(string: redirectionURL), ["http", "https"].contains(url.scheme?.lowercased()) else {
            ORBToastManager.shared.showToast(message: "콘텐츠 링크를 찾을 수 없습니다.", inset: 30)
            return
        }
        let safariViewController = SFSafariViewController(url: url)
        present(safariViewController, animated: true)
    }
}
