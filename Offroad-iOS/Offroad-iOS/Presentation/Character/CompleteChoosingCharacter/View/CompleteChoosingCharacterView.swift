//
//  CompleteChoosingCharacterView.swift
//  Offroad-iOS
//
//  Created by  정지원 on 7/15/24.
//

import UIKit

import SnapKit
import Then

final class CompleteChoosingCharacterView: UIView {
    
    //MARK: - Properties
    
    private let mainLabel = UILabel().then {
        $0.text = "프로필 생성을 축하드려요!\n지금 바로 모험을 떠나볼까요?"
        $0.textAlignment = .center
        $0.numberOfLines = 2
        $0.textColor = UIColor(named: "#FFF7E7")
        $0.font = UIFont.offroad(style: .iosTitle)
    }
    
    let standingGroundView = UIView().then {
        $0.backgroundColor = UIColor(named: "#FFDDA9")
    }
    
    let offloadLogoView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(resource: .imgOffroadLogo)
        // 17.8도를 라디안으로 변환
        $0.transform = CGAffineTransform(rotationAngle: CGFloat(17.8 * .pi / 180))
        // 투명도 설정
        $0.alpha = 0.3
    }
    
    let characterView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(resource: .imgCompleteCharacterBrown)
    }
    
    let shadowView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(resource: .imgCharacterShadowBrown)
    }
    
    let doorView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(resource: .imgCharacterDoorBrown)
    }
    
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
}

extension CompleteChoosingCharacterView {
    
    // MARK: - Private Func
    
    private func setupHierarchy() {
        addSubviews(
            mainLabel,
            standingGroundView,
            offloadLogoView,
            characterView,
            doorView
        )
        standingGroundView.addSubview(shadowView)
    }
    
    private func setupStyle() {
        backgroundColor = UIColor(named: "452B0F")
    }
    
    private func setupLayout() {
        
        mainLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(102)
            make.horizontalEdges.equalToSuperview()
        }
        
        standingGroundView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }
        
        offloadLogoView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(12)
            make.trailing.equalToSuperview().offset(195)
        }
        
        shadowView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(45)
            make.horizontalEdges.equalToSuperview().inset(133)
        }
        
        characterView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(289)
            make.horizontalEdges.equalToSuperview().inset(133)
        }
        
        doorView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(45)
        }
        
    }
}

