//
//  CouponDetailView.swift
//  Offroad-iOS
//
//  Created by  정지원 on 9/5/24.
//

import UIKit

import SnapKit
import Then

final class CouponDetailView: UIView {
    
    // MARK: - Properties
    
    let couponUsagePopupView = CouponUsagePopupView().then {
        $0.isHidden = true
    }
    
    // MARK: - UI Properties
    
    let customBackButton = NavigationPopButton().then {
            $0.configureButtonTitle(titleString: "획득 쿠폰")
    }
    
    private let couponDetailView = UIView().then {
        $0.roundCorners(cornerRadius: 12)
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.home(.homeContents2).cgColor
        $0.clipsToBounds = true
        $0.backgroundColor = UIColor.main(.main1)
    }
    
    let couponImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.roundCorners(cornerRadius: 10)
        $0.clipsToBounds = true
    }
    
    let couponTitleLabel = UILabel().then {
        $0.textColor = UIColor.main(.main2)
        $0.textAlignment = .center
        $0.font = UIFont.offroad(style: .iosTextBold)
        $0.numberOfLines = 0
    }
    
    private let dottedLineView = UIView().then {
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor.home(.homeContents2).cgColor
        shapeLayer.lineWidth = 0.5
        shapeLayer.lineDashPattern = [3, 3]
        
        let viewWidth = UIScreen.main.bounds.width
        
        let path = CGMutablePath()
        path.addLines(between: [CGPoint(x: 0, y: 0),
                                CGPoint(x: viewWidth-50, y: 0)])
        shapeLayer.path = path
        
        $0.layer.addSublayer(shapeLayer)
    }
    
    let couponDescriptionLabel = UILabel().then {
        $0.textColor = UIColor.main(.main2)
        $0.textAlignment = .center
        $0.font = UIFont.offroad(style: .iosTextRegular)
        $0.numberOfLines = 3
    }
    
    private let usageTitleLabel = UILabel().then {
        $0.text = "사용방법"
        $0.textColor = UIColor.main(.main2)
        $0.font = UIFont.offroad(style: .iosHint)
    }
    
    private let usageLogoImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(resource: .imgKey)
    }
    
    private let usageDescriptionLabel = UILabel().then {
        $0.text = "매장에 게시되어 있거나 매장 직원에게 전달받은\n고유 코드를 입력한 후 제시해 사용해 주세요."
        $0.textColor = UIColor.grayscale(.gray400)
        $0.font = UIFont.offroad(style: .iosBoxMedi)
        $0.numberOfLines = 2
        $0.setLineSpacing(spacing: 5)
    }
    
    let useButton = UIButton().then {
        $0.setTitle("사용하기", for: .normal)
        $0.titleLabel?.textAlignment = .center
        $0.titleLabel?.font = UIFont.offroad(style: .iosTextRegular)
        $0.backgroundColor = UIColor.main(.main2)
        $0.roundCorners(cornerRadius: 5)
        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
    }
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupStyle()
        setupHierarchy()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private Func
    
    private func setupStyle() {
        backgroundColor = UIColor.primary(.listBg)
    }
    
    private func setupHierarchy() {
        addSubviews(
            customBackButton,
            couponDetailView,
            usageTitleLabel,
            usageLogoImageView,
            usageDescriptionLabel,
            useButton,
            couponUsagePopupView
        )
        couponDetailView.addSubviews(
            couponImageView,
            couponTitleLabel,
            dottedLineView,
            couponDescriptionLabel
        )
    }
    
    private func setupLayout() {
        customBackButton.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).inset(12)
            $0.leading.equalToSuperview().inset(12)
        }
        
        couponUsagePopupView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        couponDetailView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(125)
            make.horizontalEdges.equalToSuperview().inset(40)
        }
        
        couponImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(22)
            make.horizontalEdges.equalToSuperview().inset(21.5)
            make.centerX.equalToSuperview()
        }
        
        couponTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(couponImageView.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }
        
        dottedLineView.snp.makeConstraints { make in
            make.top.equalTo(couponTitleLabel.snp.bottom).offset(14)
            make.height.equalTo(0.5)
            make.horizontalEdges.equalToSuperview().inset(21.5)
        }
        
        couponDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(dottedLineView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(20)
        }
        
        usageTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(couponDetailView.snp.bottom).offset(24.5)
            make.leading.equalToSuperview().inset(51.36)
        }
        
        usageLogoImageView.snp.makeConstraints { make in
            make.top.equalTo(usageTitleLabel.snp.bottom).offset(12)
            make.leading.equalTo(usageTitleLabel)
        }
        
        usageDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(usageLogoImageView)
            make.leading.equalTo(usageLogoImageView.snp.trailing).offset(8)
            make.trailing.equalToSuperview().inset(51.36)
        }
        
        useButton.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide).inset(24)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(54)
        }
    }
}
