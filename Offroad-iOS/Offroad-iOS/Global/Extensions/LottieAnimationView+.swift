//
//  LottieAnimationView+.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 7/19/24.
//

import Foundation

import Lottie

extension LottieAnimationView {
    
    func fetchMotionURLToAnimationView(motionUrlString: String) {
        guard let motionURL = URL(string: motionUrlString) else { return }
        
        URLSession.shared.dataTask(with: motionURL) { data, response, error in
            guard let data = data, error == nil else {
                print("Error loading Lottie animation: \(String(describing: error))")
                return
            }
            
            DispatchQueue.main.async {
                let animation = try? LottieAnimation.from(data: data)
                self.animation = animation
                self.play()
            }
        }.resume()
    }
}
