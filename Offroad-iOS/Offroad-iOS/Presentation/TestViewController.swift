//
//  TestViewController.swift
//  Offroad-iOS
//
//  Created by  정지원 on 11/15/24.
//

import UIKit

class TestViewController: UIViewController {
    
    // 로딩 뷰 인스턴스 생성
    private let loadingView = CenterLoadingLottieView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        // 화면 로딩 시 로딩 애니메이션을 보여주기
        showLoading()
        
        // 임의로 2초 뒤 로딩 뷰를 숨기는 예시
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.hideLoading()
        }
    }
    
    // 로딩 뷰를 보여주는 함수
    func showLoading() {
        loadingView.showCenterLottieView(in: view)
    }
    
    // 로딩 뷰를 숨기는 함수
    func hideLoading() {
        loadingView.hideCenterLottieView()
    }
}


