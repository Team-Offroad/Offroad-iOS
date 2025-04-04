//
//  DeveloperModeViewController.swift
//  ORB
//
//  Created by 김민성 on 4/4/25.
//

import UIKit

import RxSwift
import RxCocoa

final class DeveloperModeViewController: UIViewController {
    
    let rootView = DeveloperModeView()
    
    var disposeBag = DisposeBag()
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rootView.customBackButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }).disposed(by: disposeBag)
    }
    
}
