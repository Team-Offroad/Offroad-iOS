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
}

extension NoticePostViewController {
    
    // MARK: - Private Method
    
    private func setupTarget() {
        rootView.customBackButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        rootView.contentButton.addTarget(self, action: #selector(contentButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - @objc Method
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func contentButtonTapped() {
        let redirectionURL = NSURL(string: noticeDetailInfo.externalLinks[0])
        let safariViewController = SFSafariViewController(url: (redirectionURL ?? NSURL()) as URL)
        self.present(safariViewController, animated: true, completion: nil)
    }
}
