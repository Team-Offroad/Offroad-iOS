//
//  TitlePopupViewController.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 7/11/24.
//

import UIKit

final class TitlePopupViewController: UIViewController {
    
    //MARK: - Properties
    
    private let titleModelList = TitleModel.dummy()
    
    private let rootView = TitlePopupView(frame: CGRect(x: 0, y: 0, width: 345, height: 430))
    
    // MARK: - Life Cycle
    
    override func loadView() {
        view = UIView(frame: UIScreen.main.bounds)
        view.addSubview(rootView)
        rootView.center = view.center
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTarget()
    }
}

extension TitlePopupViewController {
    
    // MARK: - Private Func
    
    private func setupTarget() {
        rootView.setupButton(action: buttonTapped)
        rootView.setupTitleCollectionView(self)
    }
    
    private func buttonTapped() {
        
    }
}

//MARK: - UICollectionViewDataSource

extension TitlePopupViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titleModelList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.className, for: indexPath) as? TitleCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configureCell(data: titleModelList[indexPath.item])
        return cell
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension TitlePopupViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: rootView.getTitleCollectionViewWidth() - 48, height: 48)
    }
}
