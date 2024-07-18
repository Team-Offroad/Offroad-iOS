//
//  UIImageView+.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 7/18/24.
//

import UIKit

import SVGKit

extension UIImageView {
    
    func fetchSvgURLToImageView(svgUrlString: String) {
        guard let svgURL = URL(string: svgUrlString) else { return }
        
        let task = URLSession.shared.dataTask(with: svgURL) { data, response, error in
            if let error = error {
                print("Error fetching image: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            guard let svgImage = SVGKImage(data: data) else { return }
            
            DispatchQueue.main.async {
                self.image = svgImage.renderedUIImage
            }
        }
        
        task.resume()
    }
}
