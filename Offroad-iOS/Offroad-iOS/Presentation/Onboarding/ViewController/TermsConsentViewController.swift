//
//  TermsConsentViewController.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 8/23/24.
//

import UIKit

final class TermsConsentViewController: UIViewController {
    
    //MARK: - Properties
    
    private let rootView = TermsConsentView()
    
    private var termsModelData = TermsListModel.getTermsListModel() {
        didSet {
            termsModelData[0].isSelected && termsModelData[1].isSelected && termsModelData[2].isSelected ? rootView.nextButton.changeState(forState: .isEnabled) : rootView.nextButton.changeState(forState: .isDisabled)
        }
    }
    private var termsDetailModel = TermsDetailModel.getTermsDetailModel()

    // MARK: - Life Cycle
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDelegate()
        setupAddTarget()
    }
}

extension TermsConsentViewController {
    
    //MARK: - Private Func
    
    private func setupDelegate() {
        rootView.termsListTableView.dataSource = self
        rootView.termsListTableView.delegate = self
    }
    
    private func setupAddTarget() {
        rootView.agreeAllButton.addTarget(self, action: #selector(agreeAllButtonTapped), for: .touchUpInside)
        rootView.nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }
    
    private func agreeButtonInCellTapped() {
        rootView.agreeAllButton.isSelected = checkAllButtonisSelected()
    }
    
    private func controlAllButtonState() {
        if rootView.agreeAllButton.isSelected {
            for i in 0..<termsModelData.count {
                termsModelData[i].isSelected = false
            }
        } else {
            for i in 0..<termsModelData.count {
                termsModelData[i].isSelected = true
            }
        }
    }
    
    private func checkAllButtonisSelected() -> Bool {
        for data in termsModelData {
            if data.isSelected == false { return false }
        }
        
        return true
    }
    
    private func presentNavigationController(navigationController: UINavigationController) {
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.modalTransitionStyle = .crossDissolve
        
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = .fade
        transition.subtype = .fromRight
        rootView.fordissolveAnimationView.isHidden = false
        rootView.window?.layer.add(transition, forKey: kCATransition)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.present(navigationController, animated: true, completion: nil)
        }
    }
    
    private func patchMarketingConsent(isAgreed: MarketingConsentRequestDTO) {
        NetworkService.shared.profileService.patchMarketingConsent(body: isAgreed) { response in
            switch response {
            case .success:
                print("마케팅 수신 여부 변경 성공!\n요청 성공 값: \(isAgreed.marketing)")
            default:
                break
            }
        }
    }
    
    //MARK: - @Objc Func
    
    @objc private func agreeAllButtonTapped() {        
        controlAllButtonState()
        rootView.agreeAllButton.isSelected.toggle()
        rootView.termsListTableView.reloadData()
    }
    
    @objc private func nextButtonTapped() {
        patchMarketingConsent(isAgreed: MarketingConsentRequestDTO(marketing: termsModelData[3].isSelected))
        
        let nicknameViewController = NicknameViewController()
        let navigationController = UINavigationController(rootViewController: nicknameViewController)
        
        self.presentNavigationController(navigationController: navigationController)
    }
}

//MARK: - UITableViewDataSource

extension TermsConsentViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return termsModelData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TermsListTableViewCell.className, for: indexPath) as? TermsListTableViewCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        cell.setupAgreeButton {
            self.termsModelData[indexPath.row].isSelected.toggle()
            self.agreeButtonInCellTapped()
        }
        cell.configureCell(data: termsModelData[indexPath.row])
        return cell
    }
}

//MARK: - UITableViewDelegate
    
extension TermsConsentViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let termsConsentPopupViewController = TermsConsentPopupViewController(
            titleString: termsDetailModel[indexPath.row].titleString,
            descriptionString: termsDetailModel[indexPath.row].descriptionString,
            contentString: termsDetailModel[indexPath.row].contentString,
            index: indexPath.row
        )
        termsConsentPopupViewController.delegate = self
        termsConsentPopupViewController.modalPresentationStyle = .overCurrentContext
        self.present(termsConsentPopupViewController, animated: false)
    }
}


extension TermsConsentViewController: checkButtonDelegate {
    func changeCheckState(index: Int, state: Bool) {
        termsModelData[index].isSelected = state
        rootView.termsListTableView.reloadData()
        agreeButtonInCellTapped()
    }
}
