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
    
    private let termsModelData = TermsModel.getTermsModelList()
    
    // MARK: - Life Cycle
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDelegate()
    }
}

extension TermsConsentViewController {
    
    //MARK: - Private Func
    
    private func setupDelegate() {
        rootView.termsListTableView.dataSource = self
        rootView.termsListTableView.delegate = self
    }
}

//MARK: - UITableViewDataSource

extension TermsConsentViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return termsModelData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TermsListTableViewCell.className, for: indexPath) as?
                TermsListTableViewCell else { return UITableViewCell() }
        cell.selectionStyle = .none
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
