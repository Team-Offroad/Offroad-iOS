//
//  NoticePostViewController.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 8/16/24.
//

import UIKit

final class NoticePostViewController: UIViewController {
    
    //MARK: - Properties
    
    private let rootView = NoticePostView()
    
    private let noticePostData = NoticePostModel.noticePostModel
    
    // MARK: - Life Cycle
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rootView.setPostText(data: noticePostData)
    }
}
