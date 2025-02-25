//
//  MyPageScrollView.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 2/25/25.
//

import UIKit

final class MyPageScrollView: UIScrollView {
  override func touchesShouldCancel(in view: UIView) -> Bool {
    if view is UIButton {
      return true
    }
    return super.touchesShouldCancel(in: view)
  }
}
