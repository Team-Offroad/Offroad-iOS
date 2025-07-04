//
//  Pract.swift
//  Offroad-iOS
//
//  Created by  정지원 on 7/4/25.
//

import UIKit

import SnapKit

class PractViewController: UIViewController {
    
    let mapView = UIView()
    let courseQuestScrollView = UIScrollView()
    let imageView: UIImageView = {
        let image = UIImage(systemName: "house")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    lazy var courseQuestScrollViewTopConstraint = courseQuestScrollView.topAnchor.constraint(equalTo: mapView.bottomAnchor)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.backgroundColor = .orange
        courseQuestScrollView.backgroundColor = .green
        courseQuestScrollView.isScrollEnabled = false
        
        view.backgroundColor = .blue
        
        view.addSubview(mapView)
        view.addSubview(courseQuestScrollView)
        courseQuestScrollView.addSubview(imageView)
        
        
        mapView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(250)
        }
        
        courseQuestScrollViewTopConstraint.isActive = true
        courseQuestScrollView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
        imageView.snp.makeConstraints { make in
            make.top.bottom.equalTo(courseQuestScrollView.contentLayoutGuide)
            make.horizontalEdges.equalTo(courseQuestScrollView.frameLayoutGuide)
            make.height.equalTo(1800)
        }
        
        courseQuestScrollView.delegate = self
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureHandler))
        courseQuestScrollView.addGestureRecognizer(panGesture)
    }
    
    @objc private func panGestureHandler(sender: UIPanGestureRecognizer) {
        print(#function, sender.translation(in: view).y)
        sender.velocity(in: view)
        let yTranslation = sender.translation(in: view).y
        courseQuestScrollViewTopConstraint.constant += yTranslation
        sender.setTranslation(CGPoint.zero, in: courseQuestScrollView)
        view.layoutIfNeeded()
    }
}

extension PractViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yOffset = scrollView.contentOffset.y
        print("scrollViewDidScroll offset: \(yOffset)")
        
        if 0 < yOffset && yOffset < 250 {
            courseQuestScrollView.snp.remakeConstraints { make in
                make.top.equalTo(mapView.snp.bottom).offset(-yOffset)
                make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            }
            imageView.snp.makeConstraints { make in
                make.top.equalTo(courseQuestScrollView.frameLayoutGuide)
                make.bottom.equalTo(courseQuestScrollView.contentLayoutGuide)
                make.horizontalEdges.equalTo(courseQuestScrollView.frameLayoutGuide)
                make.height.equalTo(1800)
            }
        } else if 250 <= yOffset {
            courseQuestScrollView.snp.remakeConstraints { make in
                make.top.equalTo(mapView.snp.bottom).offset(max(-250, -yOffset))
                make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            }
            imageView.snp.makeConstraints { make in
                make.top.bottom.equalTo(courseQuestScrollView.contentLayoutGuide)
                make.horizontalEdges.equalTo(courseQuestScrollView.frameLayoutGuide)
                make.height.equalTo(1800)
            }
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let yOffset = scrollView.contentOffset.y
        if 0 < yOffset && yOffset < 125 {
            targetContentOffset.pointee.y = 0
        } else if 125 <= yOffset && yOffset < 250 {
            targetContentOffset.pointee.y = -250
        }
    }
}
