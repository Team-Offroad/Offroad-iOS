//
//  MyPageMenuModel.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 8/7/24.
//

import UIKit

struct MyPageMenuModel {
    let backgroundColor: UIColor
    let menuString: String
    let menuImage: UIImage
}

extension MyPageMenuModel {
    static func dummy() -> [MyPageMenuModel] {
        return [
            MyPageMenuModel(backgroundColor: UIColor(hexCode:"FFF2C1") ?? UIColor(), menuString: "획득 캐릭터", menuImage: UIImage(resource: .imgCollectedCharacter)),
            MyPageMenuModel(backgroundColor: UIColor(hexCode:"F1DCBB") ?? UIColor(), menuString: "획득 쿠폰", menuImage: UIImage(resource: .imgCollectedCoupon)),
            MyPageMenuModel(backgroundColor: UIColor(hexCode:"FFE1C5") ?? UIColor(), menuString: "획득 칭호", menuImage: UIImage(resource: .imgCollectedTitle)),
            MyPageMenuModel(backgroundColor: UIColor(hexCode:"F9E5D2") ?? UIColor(), menuString: "설정", menuImage: UIImage(resource: .imgSetting))
        ]
    }
}

