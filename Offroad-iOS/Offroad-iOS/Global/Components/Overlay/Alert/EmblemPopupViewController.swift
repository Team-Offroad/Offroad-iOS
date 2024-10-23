//
//  EmblemPopupViewController.swift
//  Offroad-iOS
//
//  Created by 김민성 on 10/20/24.
//

import UIKit

final class EmblemPopupViewController: ORBOverlayViewController, ORBPopup {
    
    private var emblemsDataSource: [EmblemList]
    
    var currentEmblemName: String
    let presentationAnimator = UIViewPropertyAnimator(duration: 0.4, dampingRatio: 0.7)
    let dismissalAnimator = UIViewPropertyAnimator(duration: 0.2, dampingRatio: 1)
    
    private var selectedTitleString = ""
    private var selectedTitleCode = ""
    private var userTitleString = ""
    private var userTitleIndex = Int()
    
    var rootView = ORBAlertBackgroundView(type: .acquiredEmblem)
    
    init(title: String? = nil, emblemList: [EmblemList], currentEmblemName: String) {
        rootView.alertView.titleLabel.text = title
        self.currentEmblemName = currentEmblemName
        self.emblemsDataSource = emblemList
        
        super.init(nibName: nil, bundle: nil)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTargets()
        setupDelegate()
        reloadCollcetionView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        showAlertView()
    }
    
    override func dismiss(animated: Bool, completion: (() -> Void)? = nil) {
        view.endEditing(true)
        if animated {
            hideAlertView { super.dismiss(animated: false, completion: completion) }
        } else {
            super.dismiss(animated: false, completion: completion)
        }
    }
    
}

extension EmblemPopupViewController {
    
    //MARK: - @objc Func
    
    @objc private func closeButtonDidTapped() {
        dismiss(animated: true)
    }
    
    //MARK: - Private Func
    
    private func setupTargets() {
        let alertView = rootView.alertView as! ORBAlertViewAcquiredEmblem
        alertView.closeButton.addTarget(self, action: #selector(closeButtonDidTapped), for: .touchUpInside)
    }
    
    private func setupDelegate() {
        let alertView = rootView.alertView as! ORBAlertViewAcquiredEmblem
        alertView.collectionView.dataSource = self
        alertView.collectionView.delegate = self
    }
    
    private func reloadCollcetionView() {
        let alertView = rootView.alertView as! ORBAlertViewAcquiredEmblem
        alertView.collectionView.reloadData()
    }
    
}

//MARK: - UICollectionViewDataSource

extension EmblemPopupViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return emblemsDataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TitleCollectionViewCell.className,
            for: indexPath
        ) as? TitleCollectionViewCell else { return UICollectionViewCell() }
        
        cell.configureCell(data: emblemsDataSource[indexPath.item])
        return cell
    }
    
}

//MARK: - UICollectionViewDelegate

extension EmblemPopupViewController: UICollectionViewDelegate {
    
}
