//
//  NicknameSettingViewModel.swift
//  Offroad-iOS
//
//  Created by 김민성 on 12/1/24.
//

import Foundation

import RxSwift
import RxCocoa

final class NicknameSettingViewModel {
    
    var duplicationCheckedNickname: String? = nil
    let duplicateCheckResult = PublishRelay<Bool>()
    let networkFail = PublishRelay<Void>()
    
    init () {
        bindData()
    }
    
    
    
    private func bindData() {
        
    }
    
    
    func checkDuplicate(input: String) {
        NetworkService.shared.nicknameService.checkNicknameDuplicate(inputNickname: input) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let dto):
                guard let dto else {
                    self.networkFail.accept(())
                    return
                }
                if dto.data.isDuplicate { self.duplicationCheckedNickname = input }
                self.duplicateCheckResult.accept(dto.data.isDuplicate)
            default:
                self.networkFail.accept(())
            }
        }
    }
    
}
