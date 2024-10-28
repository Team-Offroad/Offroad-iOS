//
//  SVGFetchable.swift
//  Offroad-iOS
//
//  Created by 김민성 on 10/25/24.
//

import UIKit

import SVGKit

protocol SVGFetchable {
    
    func fetchSVG(svgURLString: String, completion: @escaping (UIImage?) -> Void)
    
}

extension SVGFetchable {
    
    func fetchSVG(svgURLString: String, completion: @escaping (UIImage?) -> Void) {
        DispatchQueue.global().async {
            guard let svgURL = URL(string: svgURLString) else { completion(nil); return }
            guard let svgData = try? Data(contentsOf: svgURL) else { completion(nil); return }
            guard let svgImage = SVGKImage(data: svgData) else { completion(nil); return }
            completion(svgImage.renderedUIImage)
        }
    }
    
}


