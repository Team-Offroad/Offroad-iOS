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
            guard let imageURL = URL(string: svgURLString) else { completion(nil); return }
            guard let imageData = try? Data(contentsOf: imageURL) else { completion(nil); return }
            
            if let image = UIImage(data: imageData) {
                completion(image)
            } else if let svgImage = SVGKImage(data: imageData) {
                completion(svgImage.renderedUIImage)
            } else {
                completion(nil)
            }
        }
    }
    
}


