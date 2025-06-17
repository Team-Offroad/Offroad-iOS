//
//  SVGFetchable.swift
//  Offroad-iOS
//
//  Created by 김민성 on 10/25/24.
//

import UIKit

import SVGKit

enum SVGImageFetchingError: Error {
    case dataLoadingFailed
}

protocol SVGFetchable {
    
    func fetchSVG(svgURLString: String, completion: @escaping (UIImage?) -> Void)
    func fetchSVG(svgURLString: String) async throws -> UIImage
    
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
    
    func fetchSVG(svgURLString: String) async throws -> UIImage {
        guard let imageURL = URL(string: svgURLString) else {
            throw URLError(.badURL)
        }
        let (imageData, urlResponse) = try await URLSession.shared.data(from: imageURL)
        
        guard let httpResponse = urlResponse as? HTTPURLResponse else {
            print("URLResponse를 HTTPURLResponse로 캐스팅하는 데 실패했습니다.")
            throw NetworkResultError.unknown(nil)
        }
        
        guard (200..<300).contains(httpResponse.statusCode) else {
            throw NetworkResultError.httpError(statusCode: httpResponse.statusCode)
        }
        
        if let image = UIImage(data: imageData) {
            return image
        } else if let svgImage = SVGKImage(data: imageData), let renderedImage = svgImage.renderedUIImage {
            return renderedImage
        } else {
            throw SVGImageFetchingError.dataLoadingFailed
        }
    }
    
}


