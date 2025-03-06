//
//  DiaryViewController.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 3/4/25.
//

import UIKit

final class DiaryViewController: UIViewController {
    
    // MARK: - Properties
    
    private let rootView = DiaryView()
    
    private var isGuideConfirmed = false {
        didSet {
            if isGuideConfirmed {
                showSettingDiaryTimeAlert()
            }
        }
    }
    
    // MARK: - Life Cycle
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTarget()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let offroadTabBarController = self.tabBarController as? OffroadTabBarController else { return }
        offroadTabBarController.hideTabBarAnimation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        //TODO: - 서버 연결 이후 수정 예정(뷰 진입 시 가이드 화면 표시 여부 결졍)
        
        let diaryGuideViewController = DiaryGuideViewController()
        diaryGuideViewController.delegate = self
        diaryGuideViewController.modalPresentationStyle = .overCurrentContext
        present(diaryGuideViewController, animated: false)
    }
}

extension DiaryViewController {
    
    // MARK: - Func
    
    func setupCustomBackButton(buttonTitle: String) {
        rootView.customBackButton.configureButtonTitle(titleString: buttonTitle)
    }
}

private extension DiaryViewController {
    
    // MARK: - Private Method
    
    func setupTarget() {
        rootView.customBackButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        rootView.guideButton.addTarget(self, action: #selector(guideButtonTapped), for: .touchUpInside)
    }
    
    func showSettingDiaryTimeAlert() {
        let alertController = ORBAlertController(title: AlertMessage.diaryTimeGuideTitle, message: AlertMessage.diaryTimeGuideMessage, type: .normal)
        alertController.configureMessageLabel{ label in
            label.setLineHeight(percentage: 150)
            label.highlightText(targetText: "설정", font: .offroad(style: .iosTextBold), color: .grayscale(.gray400))
            label.highlightText(targetText: "에서 일기 받을 시간을 바꿀 수 있어요.", color: .grayscale(.gray400))
        }
        alertController.xButton.isHidden = true
        let cancelAction = ORBAlertAction(title: "설정", style: .cancel) { _ in
            let diaryTimeViewController = DiaryTimeViewController()
            diaryTimeViewController.setupCustomBackButton(buttonTitle: "일기")
            self.navigationController?.pushViewController(diaryTimeViewController, animated: true)
        }
        let okAction = ORBAlertAction(title: "확인", style: .default) { _ in return }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
}
    
@objc private extension DiaryViewController {

    // MARK: - @objc Method
    
    func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func guideButtonTapped() {
        let diaryGuideViewController = DiaryGuideViewController()
        diaryGuideViewController.modalPresentationStyle = .overCurrentContext
        present(diaryGuideViewController, animated: false)
    }
}

extension DiaryViewController: GuideConfirmDelegate {
    func toggleIsGuideConfirmed() {
        isGuideConfirmed = true
    }
}
