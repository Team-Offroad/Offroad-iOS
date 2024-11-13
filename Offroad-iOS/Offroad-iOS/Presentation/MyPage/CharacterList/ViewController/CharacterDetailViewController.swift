//
//  CharacterDetailViewController.swift
//  Offroad-iOS
//
//  Created by  정지원 on 8/13/24.
//

import UIKit

import RxSwift
import RxCocoa

final class CharacterDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    private let rootView = CharacterDetailView()
    let viewModel: CharacterDetailViewModel
    let viewDidAppear = PublishRelay<Void>()
    var disposeBag = DisposeBag()
    weak var delegate: SelectMainCharacterDelegate?
    
    // MARK: - Life Cycle
    
    init(characterId: Int, representativeCharacterId: Int) {
        viewModel = CharacterDetailViewModel(
            characterId: characterId,
            representativeCharacterId: representativeCharacterId
        )
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDelegate()
        bindData()
        viewModel.characterMotionInfo()
        viewModel.getCharacterDetailInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if viewModel.isCurrentCharacterRepresentative {
            rootView.selectButton.isEnabled = false
            rootView.crownBadgeImageView.isHidden = false
        }
        guard let tabBarController = tabBarController as? OffroadTabBarController else { return }
        tabBarController.hideTabBarAnimation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewDidAppear.accept(())
    }
    
}

extension CharacterDetailViewController {
    
    // MARK: - Private Func
    
    private func setupDelegate() {
        rootView.collectionView.delegate = self
        rootView.collectionView.dataSource = self
    }
    
    private func bindData() {
        viewModel.representativeCharacterSelected
            .subscribe(onNext: { [weak self] in
                guard let self else { return }
                self.rootView.crownBadgeImageView.isHidden = false
                self.rootView.selectButton.isEnabled = false
                self.delegate?.didSelectMainCharacter(characterId: self.viewModel.characterId)
                self.showToast(message: "'\($0.characterName)'로 대표 캐릭터가 변경되었어요!", inset: 66, withImage: .btnChecked)
            }).disposed(by: disposeBag)
        
        viewModel.characterDetailInfoSubject.compactMap({ $0 })
            .subscribe(onNext: { [weak self] characterDetailInfo in
                guard let self else { return }
                self.rootView.configurerCharacterDetailView(using: characterDetailInfo)
            }).disposed(by: disposeBag)
        
        viewModel.networkingSuccess
            .subscribe(onNext: { [weak self] in
            guard let self else { return }
            self.rootView.collectionView.reloadData()
        }).disposed(by: disposeBag)
        
        Observable.combineLatest(
            viewModel.networkingFailure,
            viewDidAppear.take(1)
        ).subscribe(onNext: { [weak self] _, _ in
            guard let self else { return }
            self.showToast(message: "네트워크 연결 상태를 확인해주세요.", inset: 66)
        }).disposed(by: disposeBag)
        
        rootView.customBackButton.rx.tap.bind(onNext: { [weak self] in
            guard let self else { return }
            self.navigationController?.popViewController(animated: true)
        }).disposed(by: disposeBag)
        
        rootView.selectButton.rx.tap.bind(to: viewModel.selectButtonTapped).disposed(by: disposeBag)
        rootView.chatLogButton.rx.tap.bind(onNext: { [weak self] in
            guard let self else { return }
            let snapshot = view.snapshotView(afterScreenUpdates: true)
            let chatLogViewController = CharacterChatLogViewController(background: snapshot ?? UIView())
            self.navigationController?.pushViewController(chatLogViewController, animated: true)
        }).disposed(by: disposeBag)
        
        
        /// 네트워크 끊어진 상태에서 CharacterDetailView로 진입 후(현재 빈 화면인 상태)
        /// 네트워크 연결하면 아래 구독이 실행됨.
        /// 근데 이때, 캐릭터 정보와 모션 둘 다 이전에 nil인 상태에서 둘 중 하나만 업데이트된 상태에서는 네트워크 연결을 확인하라는 문구가 뜸
        /// -> 해결 필요
        /// (combine'Latest'이기 때문)
        /// 네트워크 재연결시 flow를 별도로 만들어야 할 수도
        NetworkMonitoringManager.shared.networkConnectionChanged
            .subscribe(onNext: { [weak self] isConnected in
                guard let self else { return }
                guard isConnected else { return }
                self.viewModel.getCharacterDetailInfo()
                self.viewModel.characterMotionInfo()
            }).disposed(by: disposeBag)
    }
    
}

//MARK: - UICollectionViewDataSource

extension CharacterDetailViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.characterMotionListDataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CharacterDetailCell.className,
            for: indexPath
        ) as? CharacterDetailCell else { fatalError("Could not dequeue CharacterDetailCell") }
        
        cell.configureContent(with: viewModel.characterMotionListDataSource[indexPath.item])
        cell.configureColor(
            mainColor: viewModel.characterMainColorCode,
            subColor: viewModel.characterSubColorCode
        )
        rootView.updateCollectionViewHeight()
        return cell
    }
    
}

//MARK: - UICollectionViewDelegate

extension CharacterDetailViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Cell \(indexPath.item) selected")
    }
    
}
