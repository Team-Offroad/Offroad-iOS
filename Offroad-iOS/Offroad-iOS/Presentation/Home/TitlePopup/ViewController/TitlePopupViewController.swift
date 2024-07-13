//
//  TitlePopupViewController.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 7/11/24.
//

import UIKit

protocol selectedTitleProtocol: AnyObject {
    func fetchTitleString(titleString: String)
}

final class TitlePopupViewController: UIViewController {
    
    //MARK: - Properties

    private let rootView = TitlePopupView()
    
    weak var delegate: selectedTitleProtocol?

    private let titleModelList = TitleModel.dummy()
    private var selectedTitleString = ""
    
    // MARK: - Life Cycle
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTarget()
    }
}

extension TitlePopupViewController {
    
    // MARK: - Private Func
    
    private func setupTarget() {
        rootView.setupTitleCollectionView(self)
        rootView.setupCloseButton(action: closeButtonTapped)
    }
    
    private func changeTitleButtonTapped() {
        print("changeTitleButtonTapped")
        
        delegate?.fetchTitleString(titleString: selectedTitleString)
        self.dismiss(animated: false)
    }
    
    private func closeButtonTapped() {
        print("closeButtonTapped")
        
        self.dismiss(animated: false)
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.cellForItem(at: indexPath)?.isSelected = true
        rootView.setupChangeTitleButton(action: changeTitleButtonTapped)
        
        selectedTitleString = titleModelList[indexPath.item].titleString
    }
}
