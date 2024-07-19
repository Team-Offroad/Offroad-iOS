//
//  UIImage+.swift
//  Offroad-iOS
//
//  Created by 김민성 on 2024/07/19.
//

import UIKit

extension UIImage {
    
    
    /// URL을 이용해 UIImage를 반환
    /// - Parameters:
    ///   - url: 이미지의 URL
    ///   - completion: 받아온 이미지를 매개변수로 갖는 콜백 함수. **(주의!) 메인 쓰레드에서 호출되지 않음.**
    static func fetchedByURL(_ url: URL, completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard error != nil else {
                print(error!.localizedDescription)
                return
            }
            
            guard let data else {
                print("No data received")
                return
            }
            
            let image = UIImage(data: data)
            completion(image)
        }
    }
    
    static func fetchedByURL(_ urlString: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString) else {
            print("invalid URL format")
            completion(nil)
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard error != nil else {
                print(error!.localizedDescription)
                return
            }
            
            guard let data else {
                print("No data received")
                return
            }
            
            let image = UIImage(data: data)
            completion(image)
        }
    }
    
}
