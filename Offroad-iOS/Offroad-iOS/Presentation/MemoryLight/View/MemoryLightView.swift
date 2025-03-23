//
//  MemoryLightView.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 3/17/25.
//

import UIKit

import SnapKit
import Then

final class MemoryLightView: UIView {
    
    //MARK: - UI Properties
    
    private var gradientLayer: CAGradientLayer?
    private var blurEffectView: CustomIntensityBlurView?
    private let backgroundGradientView = UIView()
    let closeButton = UIButton()
    let memoryLightCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    let shareButton = ShrinkableButton()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupHierarchy()
        setupStyle()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundGradientView.frame = bounds
        gradientLayer?.frame = backgroundGradientView.bounds
        blurEffectView?.frame = backgroundGradientView.bounds
    }
}

private extension MemoryLightView {
    
    // MARK: - Layout
    
    func setupStyle() {
        backgroundColor = .primary(.white)
        
        closeButton.do {
            $0.setImage(.iconCloseWhite, for: .normal)
        }
        
        memoryLightCollectionView.do {
            let flowLayout = UICollectionViewFlowLayout()
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumLineSpacing = 13
            flowLayout.minimumInteritemSpacing = 0
            
            $0.collectionViewLayout = flowLayout
            $0.contentInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
            $0.decelerationRate = .fast
            $0.isPagingEnabled = false
            $0.showsHorizontalScrollIndicator = false
            $0.backgroundColor = .clear
            
            $0.register(MemoryLightCollectionViewCell.self, forCellWithReuseIdentifier: MemoryLightCollectionViewCell.className)
        }
        
        shareButton.do {
            var configuration = UIButton.Configuration.plain()
            configuration.image = .iconShare
            configuration.imagePadding = 8
            configuration.imagePlacement = .leading
            
            var attributedTitle = AttributedString("공유하기")
            attributedTitle.font = .offroad(style: .iosText)
            attributedTitle.foregroundColor = .primary(.white)

            configuration.attributedTitle = attributedTitle
            
            $0.configuration = configuration
        }
    }
    
    func setupHierarchy() {
        addSubviews(
            backgroundGradientView,
            closeButton,
            memoryLightCollectionView,
            shareButton
        )
    }
    
    func setupLayout() {
        backgroundGradientView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        closeButton.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).inset(4)
            $0.trailing.equalToSuperview().inset(14)
            $0.size.equalTo(44)
        }
        
        memoryLightCollectionView.snp.makeConstraints {
            $0.top.greaterThanOrEqualTo(safeAreaLayoutGuide).inset(81)
            $0.top.lessThanOrEqualTo(safeAreaLayoutGuide).inset(141)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(570).priority(.low)
        }
        
        shareButton.snp.makeConstraints {
            $0.top.equalTo(memoryLightCollectionView.snp.bottom).offset(32)
            $0.bottom.lessThanOrEqualTo(safeAreaLayoutGuide).inset(20)
            $0.bottom.greaterThanOrEqualTo(safeAreaLayoutGuide).inset(64)
            $0.centerX.equalToSuperview()
        }
    }
}

extension MemoryLightView {
    func updateBackgroundViewUI(pointColorCode: String, baseColorCode: String) {
        let pointColor = UIColor(hexCode: pointColorCode)?.cgColor ?? UIColor().cgColor
        let baseColor = UIColor(hexCode: baseColorCode)?.cgColor ?? UIColor().cgColor

        if let gradientLayer = self.gradientLayer {
            gradientLayer.colors = [pointColor, baseColor]
            gradientLayer.frame = backgroundGradientView.bounds
        } else {
            let gradientLayer = CAGradientLayer()
            gradientLayer.colors = [pointColor, baseColor]
            gradientLayer.type = .radial
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 1, y: 1)
            gradientLayer.locations = [0.0, 0.9]
            gradientLayer.frame = backgroundGradientView.bounds
            
            backgroundGradientView.layer.insertSublayer(gradientLayer, at: 0)
            self.gradientLayer = gradientLayer
        }

        if blurEffectView == nil {
            let blurEffectView = CustomIntensityBlurView(blurStyle: .light, intensity: 0.1)
            blurEffectView.frame = backgroundGradientView.bounds
            self.blurEffectView = blurEffectView
            backgroundGradientView.addSubview(blurEffectView)
        }
    }
}
