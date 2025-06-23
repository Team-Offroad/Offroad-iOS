//
//  CourseQuestCategoryIcon.swift
//  Offroad-iOS
//
//  Created by  정지원 on 6/24/25.
//

import UIKit

enum CourseQuestCategoryIcon {
    static func image(for category: String) -> UIImage {
        switch category.uppercased() {
        case "카페":
            return UIImage.icnQuestListCafe
        case "공원":
            return UIImage.icnQuestListPark
        case "식당":
            return UIImage.icnQuestListRestaurant
        case "문화":
            return UIImage.icnQuestListShow
        default:
            return UIImage.icnQuestListCheckBox
        }
    }
}
