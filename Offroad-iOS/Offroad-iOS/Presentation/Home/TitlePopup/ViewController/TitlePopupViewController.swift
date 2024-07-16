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

    private var titleModelList: [EmblemList]? {
        didSet {
            rootView.reloadCollectionView()
        }
    }
    
    private var selectedTitleString = ""
    private var selectedTitleCode = ""
    
    // MARK: - Life Cycle
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTarget()
        
        getEmblemList()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        rootView.presentPopupView()
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
        changeUserEmblem(emblemCode: selectedTitleCode)
        self.dismiss(animated: false)
        rootView.dismissPopupView()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4){
            self.dismiss(animated: false)
        }
    }
    
    private func closeButtonTapped() {
        print("closeButtonTapped")
        
        self.dismiss(animated: false)
        rootView.dismissPopupView()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4){
            self.dismiss(animated: false)
        }
    }
    
    private func getEmblemList() {
        NetworkService.shared.emblemService.getEmblemInfo { response in
            switch response {
            case .success(let data):
                self.titleModelList = data?.data.emblems
            default:
                break
            }
        }
    }
    
    private func changeUserEmblem(emblemCode: String) {
        NetworkService.shared.emblemService.patchUserEmblem(parameter: emblemCode) { response in
            switch response {
            case .success:
                print("칭호 변경 성공!!!!!!!")
            default:
                break
            }
        }
    }
}

//MARK: - UICollectionViewDataSource

extension TitlePopupViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let titleModelList {
            return titleModelList.count
        }
        return Int()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.className, for: indexPath) as? TitleCollectionViewCell else {
            return UICollectionViewCell()
        }
        if let titleModelList {
            cell.configureCell(data: titleModelList[indexPath.item])
        }
        
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
        
        if let titleModelList {
            selectedTitleString = titleModelList[indexPath.item].emblemName
            selectedTitleCode = titleModelList[indexPath.item].emblemCode
        }
    }
}
