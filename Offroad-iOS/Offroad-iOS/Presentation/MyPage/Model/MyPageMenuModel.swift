//
//  MyPageMenuModel.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 8/7/24.
//

import UIKit

struct MyPageMenuModel {
    let menuString: String
    let menuImage: UIImage
}

extension MyPageMenuModel {
    static func dummy() -> [MyPageMenuModel] {
        return [
            MyPageMenuModel(menuString: "획득 캐릭터", menuImage: UIImage(resource: .imgCollectedCharacter)),
            MyPageMenuModel(menuString: "획득 쿠폰", menuImage: UIImage(resource: .imgCollectedCoupon)),
            MyPageMenuModel(menuString: "획득 칭호", menuImage: UIImage(resource: .imgCollectedTitle)),
            MyPageMenuModel(menuString: "설정", menuImage: UIImage(resource: .imgSetting))
        ]
    }
}

