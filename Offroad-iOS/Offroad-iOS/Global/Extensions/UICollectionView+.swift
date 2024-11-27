//
//  UICollectionView+.swift
//  Offroad-iOS
//
//  Created by 김민성 on 11/25/24.
//

import UIKit

extension UICollectionView {
    
    /// 컬렉션뷰의 마지막에서 n번째 `IndexPath`를 반환하는 메서드.
    /// - Parameter index: 마지막에서 몇 번째 IndexPath를 반환할 지 정하는 값. 1일 경우, 마지막 item의 IndexPath를 반환하며, 0일 경우 `nil`을 반환한다.
    /// - Returns: 마지막에서 `index`번째의 IndexPath. 컬렉션뷰에 item이 하나도 없거나 마지막에서 `index`번째의 `IndexPath`가 존재하지 않을 경우(`index`가 전체 item의 갯수보다 클 경우) `nil`을 반환
    ///
    /// 마지막에서 `index`번째 item의 `IndexPath`를 반환한다. 해당하는 값을 구할 수 없을 경우 `nil`을 반환한다.
    func getIndexPathFromLast(index: Int) -> IndexPath? {
        guard index > 0, numberOfSections > 0 else { return nil }
        var countLeft: Int = index
        for section in stride(from: numberOfSections - 1, through: 0, by: -1) {
            let itemCount = numberOfItems(inSection: section)
            guard itemCount > 0 else { continue }
            for item in stride(from: itemCount - 1, through: 0, by: -1) {
                countLeft -= 1
                if countLeft == 0 {
                    return IndexPath(item: item, section: section)
                }
            }
        }
        return nil
    }
    
}
