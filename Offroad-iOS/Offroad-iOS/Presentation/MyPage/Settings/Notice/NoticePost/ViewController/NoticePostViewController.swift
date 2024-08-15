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
    
    // MARK: - Life Cycle
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
