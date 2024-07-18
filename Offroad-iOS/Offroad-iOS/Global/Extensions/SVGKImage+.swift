//
//  SVGKImage+.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 7/18/24.
//

import UIKit

import SVGKit

extension SVGKImage {
    var renderedUIImage: UIImage? {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { _ in
            self.caLayerTree.render(in: UIGraphicsGetCurrentContext()!)
        }
    }
}
