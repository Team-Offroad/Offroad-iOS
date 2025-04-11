//
//  AdventureMapView.swift
//  Offroad-iOS
//
//  Created by 김민성 on 2024/07/07.
//

import UIKit

import NMapsMap
import RxSwift
import RxCocoa
import SnapKit
import Then

class AdventureMapView: UIView, ORBCenterLoadingStyle {
    
    //MARK: - UI Properties
    
    let customNavigationBar = UIView()
    let navigationBarSeparator = UIView()
    let titleLabel = UILabel()
    let gradientView = UIView()
    let gradientLayer = CAGradientLayer()
    let reloadPlaceButton = ShrinkableButton()
    let switchTrackingModeButton = UIButton()
    let listButtonStackView = UIStackView()
    let questListButton = ORBMapListButton(image: .iconListBullet, title: "퀘스트 목록")
    let placeListButton = ORBMapListButton(image: .iconPlaceMarker, title: "장소 목록")
    
    lazy var orbMapView = ORBMapView()
    let compass = NMFCompassView()
    private let triangleArrowOverlayImage = NMFOverlayImage(image: .icnQuestMapNavermapLocationOverlaySubIcon1)
    let locationOverlayImage = NMFOverlayImage(image: .icnQuestMapCircleInWhiteBorder)
    
    private var disposBag = DisposeBag()
    
    //MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupHierarchy()
        setupStyle()
        setupLayout()
        setupCustomCompass()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        gradientLayer.frame = gradientView.bounds
        gradientView.layer.addSublayer(gradientLayer)
    }
    
}

extension AdventureMapView {
    
    //MARK: - Layout Func
    
    private func setupLayout() {
        customNavigationBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(123)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(safeAreaLayoutGuide).inset(24)
            make.bottom.equalToSuperview().inset(20)
        }
        
        navigationBarSeparator.snp.makeConstraints { make in
            make.top.equalTo(customNavigationBar.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(1)
        }
        
        gradientView.snp.makeConstraints { make in
            make.top.equalTo(listButtonStackView).offset(-63)
            make.horizontalEdges.bottom.equalToSuperview()
        }
        
        reloadPlaceButton.snp.makeConstraints { make in
            make.top.equalTo(customNavigationBar.snp.bottom).offset(23)
            make.centerX.equalToSuperview()
            make.width.equalTo(136)
            make.height.equalTo(33)
        }
        
        orbMapView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(navigationBarSeparator.snp.bottom)
            make.bottom.equalToSuperview()
        }
        
        switchTrackingModeButton.snp.makeConstraints { make in
            make.top.equalTo(customNavigationBar.snp.bottom).offset(24)
            make.trailing.equalTo(safeAreaLayoutGuide).inset(24)
            make.width.height.equalTo(44)
        }
        
        listButtonStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(40)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(59)
            make.height.greaterThanOrEqualTo(48)
        }
        
        compass.snp.makeConstraints { make in
            make.top.equalTo(switchTrackingModeButton.snp.bottom).offset(24)
            make.trailing.equalTo(switchTrackingModeButton.snp.trailing)
            make.width.height.equalTo(44)
        }
    }
    
    //MARK: - Private Func
    
    private func setupHierarchy() {
        orbMapView.addSubviews(gradientView, reloadPlaceButton, switchTrackingModeButton)
        listButtonStackView.addArrangedSubviews(questListButton, placeListButton)
        customNavigationBar.addSubview(titleLabel)
        addSubviews(
            orbMapView,
            listButtonStackView,
            compass,
            customNavigationBar,
            navigationBarSeparator
        )
    }
    
    private func setupStyle() {
        customNavigationBar.do { view in
            view.backgroundColor = .main(.main1)
        }
        
        titleLabel.do { label in
            label.textColor = .main(.main2)
            label.font = .offroad(style: .iosSubtitle2Bold)
            label.text = "어디를 탐험해 볼까요?"
        }
        
        navigationBarSeparator.do { view in
            view.backgroundColor = .grayscale(.gray100)
        }
        
        gradientView.isUserInteractionEnabled = false
        gradientLayer.do { layer in
            layer.type = .axial
            layer.colors = [UIColor(hex: "5B5B5B")!.withAlphaComponent(0.55).cgColor, UIColor.clear.cgColor]
            layer.startPoint = CGPoint(x: 0, y: 1)
            layer.endPoint = CGPoint(x: 0, y: 0)
            layer.locations = [0, 1]
        }
        
        reloadPlaceButton.do { button in
            button.setTitle("현 지도에서 검색", for: .normal)
            button.setImage(.icnReloadArrow, for: .normal)
            button.setImage(.icnReloadArrow, for: .disabled)
            button.configureBackgroundColorWhen(
                normal: .primary(.white),
                highlighted: .grayscale(.gray100),
                disabled: .grayscale(.gray100)
            )
            button.configureTitleFontWhen(normal: .pretendardFont(ofSize: 13.2, weight: .medium))
            button.setTitleColor(.grayscale(.gray400), for: .normal)
            button.setTitleColor(.grayscale(.gray400), for: .highlighted)
            button.setTitleColor(.grayscale(.gray400), for: .disabled)
            button.clipsToBounds = true
            button.layer.cornerRadius = 5.5
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.grayscale(.gray200).cgColor
        }
        
        switchTrackingModeButton.do { button in
            button.setImage(.btnDotScope, for: .normal)
        }
        
        listButtonStackView.do { stackView in
            stackView.axis = .horizontal
            stackView.spacing = 14
            stackView.alignment = .fill
            stackView.distribution = .fillEqually
        }
        
        orbMapView.onMapViewCameraIdle.subscribe(onNext: { [weak self] in
            self?.reloadPlaceButton.isEnabled = true
        }).disposed(by: disposBag)
    }
    
    private func setupCustomCompass() {
        compass.contentMode = .scaleAspectFit
        compass.mapView = orbMapView.mapView
    }
    
}
