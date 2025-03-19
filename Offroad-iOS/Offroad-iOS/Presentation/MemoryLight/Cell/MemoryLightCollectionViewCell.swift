//
//  MemoryLightCollectionViewCell.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 3/17/25.
//

import UIKit

import Kingfisher
import SnapKit
import Then

final class MemoryLightCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    private let gradientView = MemoryLightGradientView()
    private let blurEffectView = CustomIntensityBlurView(blurStyle: .light, intensity: 0.1)
    private let dateLabel = UILabel()
    private let summaryLabel = UILabel()
    private let contentLabel = UILabel()
    private let dottedLineView = UIView()
    private let todayRecommendationLabel = UILabel()
    private let recommendationView = UIView()
    private let categoryImageView = UIImageView()
    private let recommendationLabel = UILabel()

    //MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupStyle()
        setupHierarchy()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        if gradientView.layer.sublayers != nil {
            gradientView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        }
    }
}

private extension MemoryLightCollectionViewCell {
    
    //MARK: - Layout
    
    func setupStyle() {
        backgroundColor = .main(.main3)
        roundCorners(cornerRadius: 20)
        
        gradientView.do {
            $0.contentMode = .scaleAspectFit
        }
        
        dateLabel.do {
            $0.textColor = .primary(.white)
            $0.numberOfLines = 2
            $0.textAlignment = .left
            $0.font = .offroad(style: .iosSubtitle2Bold)
            $0.setLineHeight(percentage: 150)
            $0.resizeFontForDevice()
            
            $0.setContentCompressionResistancePriority(UILayoutPriority.defaultHigh + 1, for: .vertical)
        }
        
        summaryLabel.do {
            $0.textColor = .main(.main2)
            $0.numberOfLines = 2
            $0.textAlignment = .left
            $0.font = .offroad(style: .iosTextBold)
            $0.setLineHeight(percentage: 150)
            $0.lineBreakMode = .byCharWrapping
            $0.resizeFontForDevice()
        }
        
        contentLabel.do {
            $0.textColor = .main(.main2)
            $0.numberOfLines = 0
            $0.textAlignment = .left
            $0.font = .offroad(style: .iosBoxMedi)
            $0.setLineHeight(percentage: 160)
            $0.lineBreakMode = .byCharWrapping
            $0.resizeFontForDevice()
       }
        
        dottedLineView.do {
            let shapeLayer = CAShapeLayer()
            shapeLayer.strokeColor = UIColor.primary(.stroke).cgColor
            shapeLayer.lineWidth = 0.5
            shapeLayer.lineDashPattern = [3, 3]
            
            let path = CGMutablePath()
            path.addLines(between: [CGPoint(x: 0, y: 0),
                                    CGPoint(x: bounds.width - 48, y: 0)])
            shapeLayer.path = path
            
            $0.layer.addSublayer(shapeLayer)
        }
        
        todayRecommendationLabel.do {
            $0.text = "오늘의 추천"
            $0.textColor = .sub(.sub)
            $0.textAlignment = .left
            $0.font = .offroad(style: .iosTextContents)
            $0.resizeFontForDevice()
        }
        
        recommendationView.do {
            $0.backgroundColor = .main(.main1)
            $0.roundCorners(cornerRadius: 9)
        }
        
        categoryImageView.do {
            $0.image = .imgRecommendCategory
        }
        
        recommendationLabel.do {
            $0.text = "내일 묵은지 돼지갈비 왕목살 김치세트 어때요?"
            $0.textColor = .main(.main2)
            $0.textAlignment = .left
            $0.font = .offroad(style: .iosMarketing)
            $0.adjustsFontSizeToFitWidth = true
            $0.minimumScaleFactor = 0.5
        }
    }
    
    func setupHierarchy() {
        contentView.addSubviews(
            gradientView,
            blurEffectView,
            dateLabel,
            summaryLabel,
            contentLabel,
            dottedLineView,
            todayRecommendationLabel,
            recommendationView
        )
        recommendationView.addSubviews(categoryImageView, recommendationLabel)
    }
    
    func setupLayout() {
        gradientView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(40)
            $0.leading.equalToSuperview().inset(5)
            $0.size.equalTo(205)
        }
        
        blurEffectView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        dateLabel.snp.makeConstraints {
            $0.top.lessThanOrEqualToSuperview().inset(112)
            $0.top.greaterThanOrEqualToSuperview().inset(75)
            $0.leading.equalToSuperview().inset(24)
        }
        
        summaryLabel.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(28)
            $0.horizontalEdges.equalToSuperview().inset(24)
        }
        
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(summaryLabel.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(24)
        }

        dottedLineView.snp.makeConstraints {
            $0.top.equalTo(contentLabel.snp.bottom).offset(32)
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.height.equalTo(0.5)
        }
        
        todayRecommendationLabel.snp.makeConstraints {
            $0.top.equalTo(dottedLineView.snp.bottom).offset(32)
            $0.leading.equalToSuperview().inset(24)
        }
        
        recommendationView.snp.makeConstraints {
            $0.top.equalTo(todayRecommendationLabel.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().inset(34)
        }
        
        categoryImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(15)
            $0.size.equalTo(24)
            $0.verticalEdges.equalToSuperview().inset(15)
        }
        
        recommendationLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(categoryImageView.snp.trailing).offset(4)
            $0.trailing.equalToSuperview().inset(15)
        }
    }
}

extension MemoryLightCollectionViewCell {
    
    //MARK: - Func
    
    func configureCell(pointColorCode: String, baseColorCode: String) {
        gradientView.setupGradientView(pointColorCode: pointColorCode, baseColorCode: baseColorCode)
        blurEffectView.applyBlurEffectAsync()
        
        dateLabel.text = "2025년 2월 11일\n오늘의 기억빛"
        summaryLabel.text = "오늘의 기억을 AI가 한 줄로 요약합니다.오늘의 기억을 AI가 한 줄로 요약합니다."
        contentLabel.text = "그리고 오늘의 기억을 오늘 하루동안 나눈 대화, 방문한 장소, 시간 데이터를 바탕으로 요약합니다. 이때 단순 요약이 아니라 AI가 남기는 일종의 메시지 형태라고 보시면 될 것 같고 앞으로에 대한 기대, 응원, 위로 등의 내용이 담겨 있습니다. 앞으로에 대한 기대, 응원, 위로 등의 내용이 담겨 있습니다. 내용이 담겨 있습니다. 앞으로에 대한 기대, 응원, 위로 등의 내용이 담겨 있습니다."
    }
}
