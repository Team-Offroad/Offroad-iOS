//
//  TermsModel.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 8/28/24.
//

struct TermsModel {
    let isRequired: Bool
    let titleString: String
}

extension TermsModel {
    static func getTermsModelList() -> [TermsModel] {
        return [
            TermsModel(isRequired: true, titleString: "서비스 이용약관"),
            TermsModel(isRequired: true, titleString: "개인정보수집/이용 동의"),
            TermsModel(isRequired: true, titleString: "위치기반 서비스 이용약관"),
            TermsModel(isRequired: false, titleString: "마케팅 정보 수신 동의")
        ]
    }
}
