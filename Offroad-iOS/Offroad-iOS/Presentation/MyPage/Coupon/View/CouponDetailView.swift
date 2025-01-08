//
//  CouponDetailView.swift
//  Offroad-iOS
//
//  Created by  정지원 on 9/5/24.
//

import UIKit

import SnapKit
import Then

final class CouponDetailView: UIScrollView {
    
    // MARK: - UI Properties
    
    let customNavigationBar = UIView().then { view in
        view.backgroundColor = .primary(.listBg)
    }
    
    let customBackButton = NavigationPopButton().then {
            $0.configureButtonTitle(titleString: "획득 쿠폰")
    }
    
    private let couponInfoView = UIView().then {
        $0.roundCorners(cornerRadius: 22)
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.primary(.stroke).cgColor
        $0.clipsToBounds = true
        $0.backgroundColor = UIColor.main(.main1)
    }
    
    let couponImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.backgroundColor = .primary(.white)
        $0.roundCorners(cornerRadius: 10)
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
        shapeLayer.lineWidth = 2
        shapeLayer.lineDashPattern = [3, 3]
        
        let viewWidth = UIScreen.main.bounds.width
        
        let path = CGMutablePath()
        path.addLines(between: [CGPoint(x: 0, y: 0), CGPoint(x: viewWidth, y: 0)])
        shapeLayer.path = path
        
        $0.layer.masksToBounds = true
        $0.layer.addSublayer(shapeLayer)
    }
    
    let couponDescriptionLabel = UILabel().then {
        $0.textColor = UIColor.main(.main2)
        $0.textAlignment = .center
        $0.font = UIFont.offroad(style: .iosText)
        $0.setLineHeight(percentage: 150)
        $0.numberOfLines = 0
    }
    
    private let usageTitleLabel = UILabel().then {
        $0.text = "사용방법"
        $0.textColor = UIColor.sub(.sub2)
        $0.font = UIFont.offroad(style: .iosHint)
    }
    
    private let usageLogoImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = .icnCouponDetailKeyAndLock
    }
    
    private let usageDescriptionLabel = UILabel().then {
        $0.text = "매장에 게시되어 있거나 매장 직원에게 전달받은 고유 코드를 입력한 후 제시해 사용해 주세요."
        $0.textColor = UIColor.grayscale(.gray400)
        $0.font = UIFont.offroad(style: .iosBoxMedi)
        $0.numberOfLines = 0
        $0.setLineHeight(percentage: 160)
    }
    
    let useButton = ShrinkableButton().then {
        $0.setTitle("사용하기", for: .normal)
        $0.setTitle("사용완료", for: .disabled)
        $0.setTitleColor(.main(.main1), for: .normal)
        $0.setTitleColor(.main(.main1), for: .disabled)
        $0.titleLabel?.textAlignment = .center
        $0.configureTitleFontWhen(normal: .offroad(style: .iosText))
        $0.configureBackgroundColorWhen(
            normal: .main(.main2),
            highlighted: .blackOpacity(.black55),
            disabled: .blackOpacity(.black15)
        )
        $0.configuration?.baseForegroundColor = .main(.main1)
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
        showsVerticalScrollIndicator = false
        backgroundColor = UIColor.primary(.listBg)
    }
    
    private func setupHierarchy() {
        customNavigationBar.addSubview(customBackButton)
        addSubviews(
            couponInfoView,
            usageTitleLabel,
            usageLogoImageView,
            usageDescriptionLabel,
            useButton,
            customNavigationBar
        )
        couponInfoView.addSubviews(
            couponImageView,
            couponTitleLabel,
            dottedLineView,
            couponDescriptionLabel
        )
    }
    
    private func setupLayout() {
        customNavigationBar.snp.makeConstraints { make in
            make.top.equalTo(frameLayoutGuide)
            make.horizontalEdges.equalTo(frameLayoutGuide)
        }
        
        customBackButton.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).inset(12)
            $0.leading.equalToSuperview().inset(12)
            $0.bottom.equalToSuperview().inset(10)
        }
        
        couponInfoView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(contentLayoutGuide).inset(78)
            make.width.equalTo(312)
        }
        
        couponImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(21)
            make.horizontalEdges.equalToSuperview().inset(21)
            make.size.equalTo(270)
        }
        
        couponTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(couponImageView.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(21)
        }
        
        dottedLineView.snp.makeConstraints { make in
            make.top.equalTo(couponTitleLabel.snp.bottom).offset(14)
            make.height.equalTo(1)
            make.horizontalEdges.equalToSuperview().inset(21.5)
        }
        
        couponDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(dottedLineView.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(21)
            make.bottom.equalToSuperview().inset(20)
            make.height.greaterThanOrEqualTo(72)
        }
        
        usageTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(couponInfoView.snp.bottom).offset(24.5)
            make.horizontalEdges.equalToSuperview().inset(50)
        }
        
        usageLogoImageView.snp.makeConstraints { make in
            make.top.equalTo(usageTitleLabel.snp.bottom).offset(12)
            make.leading.equalTo(usageTitleLabel)
            make.size.equalTo(21)
        }
        
        usageDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(usageLogoImageView)
            make.leading.equalTo(usageLogoImageView.snp.trailing).offset(8)
            make.trailing.equalTo(frameLayoutGuide).inset(50)
        }
        
        useButton.snp.makeConstraints { make in
            make.top.equalTo(usageDescriptionLabel.snp.bottom).offset(50)
            make.horizontalEdges.equalTo(frameLayoutGuide).inset(24)
            make.bottom.equalTo(contentLayoutGuide).inset(24)
            make.height.equalTo(54)
        }
    }
}
