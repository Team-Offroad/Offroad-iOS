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
            userTitleIndex = titleModelList?.firstIndex(where: { $0.emblemName == userTitleString }) ?? Int()
        }
    }
    
    private var selectedTitleString = ""
    private var selectedTitleCode = ""
    private var userTitleString = ""
    private var userTitleIndex = Int()
    
    // MARK: - Life Cycle
    
    init(emblemString: String) {
        userTitleString = emblemString
        
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
        rootView.setupChangeTitleButton(action: changeTitleButtonTapped)
    }
    
    private func changeTitleButtonTapped() {
        print("changeTitleButtonTapped")
        
        delegate?.fetchTitleString(titleString: selectedTitleString)
        changeUserEmblem(emblemCode: selectedTitleCode)
        rootView.dismissPopupView()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4){
            self.dismiss(animated: false)
        }
    }
    
    private func closeButtonTapped() {
        print("closeButtonTapped")
        
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
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.className, for: indexPath) as? TitleCollectionViewCell else { return UICollectionViewCell() }
        if let titleModelList {
            cell.configureCell(data: titleModelList[indexPath.item])
            
            if indexPath.item == userTitleIndex {
                cell.changeCellState(true)
            }
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
        indexPath.item == userTitleIndex ? rootView.toggleChangeTitleButtonState(false) : rootView.toggleChangeTitleButtonState(true)

        if let titleModelList {
            if userTitleString != titleModelList[indexPath.item].emblemName{
                
                if let targetCell = collectionView.cellForItem(at: IndexPath(item: userTitleIndex, section: 0)) as? TitleCollectionViewCell {
                    targetCell.changeCellState(false)
                }
            }
            
            selectedTitleString = titleModelList[indexPath.item].emblemName
            selectedTitleCode = titleModelList[indexPath.item].emblemCode
        }
    }
}
