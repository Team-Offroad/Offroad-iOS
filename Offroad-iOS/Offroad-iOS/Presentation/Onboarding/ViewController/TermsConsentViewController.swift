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
    
    private var termsModelData = TermsModel.getTermsModelList() {
        didSet {
            termsModelData[0].isSelected && termsModelData[1].isSelected && termsModelData[2].isSelected ? rootView.nextButton.changeState(forState: .isEnabled) : rootView.nextButton.changeState(forState: .isDisabled)
        }
    }
    
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
    
    //MARK: - @Objc Func
    
    @objc private func agreeAllButtonTapped() {        
        controlAllButtonState()
        rootView.agreeAllButton.isSelected.toggle()
        rootView.termsListTableView.reloadData()
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
}
