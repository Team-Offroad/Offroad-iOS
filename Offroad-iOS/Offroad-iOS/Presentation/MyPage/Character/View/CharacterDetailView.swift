//
//  CharacterDetailView.swift
//  Offroad-iOS
//
//  Created by  정지원 on 8/13/24.
//

import UIKit

import SnapKit

class CharacterDetailView: UIView {
    
    // MARK: - Properties
    
    private var collectionViewHeightConstraint: Constraint? // 컬렉션 뷰의 동적 높이 조절을 위한 변수
    
    // MARK: - UI Properties
    
    private let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
    }
    
    private let contentView = UIView()
    
    var characterImage = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    private let labelView = UIView().then {
        $0.backgroundColor = UIColor.main(.main1)
        $0.roundCorners(cornerRadius: 10)
    }
    
    private let dottedLineView = UIView().then {
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor.home(.homeContents2).cgColor
        shapeLayer.lineWidth = 0.5
        shapeLayer.lineDashPattern = [3, 3]
        
        let viewWidth = UIScreen.main.bounds.width
        
        let path = CGMutablePath()
        path.addLines(between: [CGPoint(x: 0, y: 0),
                                CGPoint(x: viewWidth - 50, y: 0)])
        shapeLayer.path = path
        
        $0.layer.addSublayer(shapeLayer)
    }
    
    private let detailLabelView = UIView().then {
        $0.backgroundColor = UIColor.main(.main1)
        $0.roundCorners(cornerRadius: 10)
    }
    
    let nameLabel = UILabel().then {
        $0.textAlignment = .left
        $0.textColor = UIColor.sub(.sub4)
        $0.font = UIFont.offroad(style: .iosSubtitle2Bold)
    }
    
    private let mainLabel = UILabel().then {
        $0.text = "캐릭터 모션"
        $0.textAlignment = .left
        $0.textColor = UIColor.main(.main2)
        $0.font = UIFont.offroad(style: .iosTextTitle)
    }
    
    private let babyImage = UIImageView(image: UIImage(resource: .baby))
    
    var characterLogoImage = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    private let titleLabel = UILabel().then {
        $0.text = "호기심이 많은 탐험가"
        $0.textAlignment = .left
        $0.textColor = UIColor.grayscale(.gray300)
        $0.font = UIFont.offroad(style: .iosTextContentsSmall)
    }
    
    let detailLabel = UILabel().then {
        $0.textAlignment = .left
        $0.numberOfLines = 3
        $0.textColor = UIColor.grayscale(.gray400)
        $0.font = UIFont.offroad(style: .iosBoxMedi)
    }
    
    private let selectButton = UIButton().then {
        $0.setTitle("대표 캐릭터로 선택하기", for: .normal)
        $0.backgroundColor = UIColor.home(.homeBg)
        $0.setTitleColor(UIColor.main(.main1), for: .normal)
        $0.titleLabel?.font = UIFont.offroad(style: .iosTextContents)
        $0.layer.cornerRadius = 20
    }
    
    private let characterMotionView = UIView().then {
        $0.backgroundColor = UIColor.main(.main1)
        $0.roundCorners(cornerRadius: 16)
    }
    
    private lazy var layout = UICollectionViewFlowLayout().then {
        let padding: CGFloat = 20
        $0.itemSize = CGSize(width: 162, height: 214)
        $0.minimumLineSpacing = padding
        $0.minimumInteritemSpacing = padding
        $0.scrollDirection = .vertical
    }
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout).then {
        $0.register(CharacterDetailCell.self, forCellWithReuseIdentifier: "CharacterDetailCell")
        $0.backgroundColor = .clear
        $0.isScrollEnabled = false
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
    
    // MARK: - Private Functions
    
    private func setupStyle() {
        backgroundColor = UIColor.primary(.listBg)
    }
    
    private func setupHierarchy() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubviews(
            characterImage,
            labelView,
            dottedLineView,
            detailLabelView,
            selectButton,
            characterMotionView
        )
        labelView.addSubviews(
            nameLabel,
            titleLabel,
            characterLogoImage
        )
        detailLabelView.addSubview(detailLabel)
        characterMotionView.addSubviews(
            mainLabel,
            babyImage,
            collectionView
        )
    }
    
    private func setupLayout() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        characterImage.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide).inset(119)
            make.centerX.equalToSuperview()
            make.width.equalTo(155)
            make.height.equalTo(280)
        }
        
        labelView.snp.makeConstraints { make in
            make.top.equalTo(characterImage.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(84)
        }
        
        characterLogoImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(22)
            make.size.equalTo(CGSize(width: 50, height: 50))
        }
        
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(characterLogoImage.snp.trailing).offset(17)
            make.top.equalToSuperview().inset(21)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(4)
            make.leading.centerX.equalTo(nameLabel)
        }
        
        dottedLineView.snp.makeConstraints { make in
            make.top.equalTo(labelView.snp.bottom)
            make.height.equalTo(0.5)
            make.horizontalEdges.equalToSuperview().inset(48)
        }
        
        detailLabelView.snp.makeConstraints { make in
            make.top.equalTo(labelView.snp.bottom)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(104)
        }
        
        detailLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(22)
            make.centerY.equalToSuperview()
        }
        
        selectButton.snp.makeConstraints { make in
            make.top.equalTo(detailLabelView.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(24.5)
            make.height.equalTo(50)
        }
        
        characterMotionView.snp.makeConstraints { make in
            make.top.equalTo(selectButton.snp.bottom).offset(32)
            make.width.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        mainLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(30)
            make.left.equalToSuperview().inset(24.5)
        }
        
        babyImage.snp.makeConstraints { make in
            make.centerY.equalTo(mainLabel)
            make.leading.equalTo(mainLabel.snp.trailing).offset(8)
            make.size.equalTo(CGSize(width: 26, height: 21))
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(mainLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(24.5)
            collectionViewHeightConstraint = make.height.equalTo(800).constraint // 초기 높이
            make.bottom.equalToSuperview().inset(78)
        }
    }
    
    func updateCollectionViewHeight() {
        let contentHeight = collectionView.collectionViewLayout.collectionViewContentSize.height
        collectionViewHeightConstraint?.update(offset: contentHeight)
    }
}
