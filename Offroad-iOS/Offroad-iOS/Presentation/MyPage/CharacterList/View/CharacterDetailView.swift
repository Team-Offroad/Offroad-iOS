//
//  CharacterDetailView.swift
//  Offroad-iOS
//
//  Created by  정지원 on 8/13/24.
//

import UIKit

import SnapKit
import SVGKit
import Then

class CharacterDetailView: UIView, SVGFetchable {
    
    // MARK: - Properties
    
    private var collectionViewHeightConstraint: Constraint? // 컬렉션 뷰의 동적 높이 조절을 위한 변수
    
    // MARK: - UI Properties
    
    let customNavigationBar = UIView()
    let customBackButton = NavigationPopButton()
    let chatLogButton = ShrinkableButton(shrinkScale: 0.93)
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    let characterImageView = UIImageView()
    private let labelView = UIView()
    private let dottedLineView = UIView()
    private let detailLabelView = UIView()
    let nameLabel = UILabel()
    private let characterMotionViewTitleLabel = UILabel()
    private let orbCharacterIconImage = UIImageView(image: .icnCharacterDetailOrbCharacter)
    private let titleLabel = UILabel()
    let crownBadgeImageView = UIImageView(image: .imgCrownTag)
    private let detailLabel = UILabel()
    let selectButton = UIButton()
    private let characterMotionView = UIView()
    
    private var layoutMaker: UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        let padding: CGFloat = 20
        let itemWidth = (UIScreen.main.bounds.width - 2*24.5 - padding)/2
        let itemHeight: CGFloat = itemWidth * (214 / 162)
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        layout.minimumLineSpacing = padding
        layout.minimumInteritemSpacing = padding
        layout.scrollDirection = .vertical
        return layout
    }
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layoutMaker)
    
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
    
}

extension CharacterDetailView {
    
    //MARK: - Layout Func
    
    private func setupLayout() {
        customNavigationBar.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(safeAreaLayoutGuide.snp.top).offset(76)
        }
        
        customBackButton.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).inset(12)
            $0.leading.equalToSuperview().inset(12)
        }
        
        chatLogButton.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(16)
            make.leading.greaterThanOrEqualTo(customBackButton.snp.trailing).offset(10)
            make.trailing.equalTo(safeAreaLayoutGuide).inset(24)
            make.width.equalTo(84)
            make.height.equalTo(36)
        }
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        characterImageView.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide).inset(119)
            // 이미지의 좌우 여백 padding 값: 70
            make.centerX.equalToSuperview()
            make.size.equalTo(UIScreen.currentScreenSize.width - (70 * 2))
        }
        
        labelView.snp.makeConstraints { make in
            make.top.equalTo(characterImageView.snp.bottom).offset(50)
            make.horizontalEdges.equalToSuperview().inset(24)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(17)
            make.leading.equalToSuperview().inset(22)
            make.trailing.lessThanOrEqualToSuperview().inset(22)
        }
        
        crownBadgeImageView.snp.makeConstraints { make in
            make.leading.equalTo(nameLabel.snp.trailing).offset(6)
            make.trailing.lessThanOrEqualToSuperview()
            make.centerY.equalTo(nameLabel)
            make.size.equalTo(21)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(4)
            make.leading.equalTo(nameLabel)
            make.trailing.lessThanOrEqualToSuperview().inset(22)
            make.bottom.equalToSuperview().inset(17)
        }
        
        dottedLineView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.height.equalTo(1)
            make.horizontalEdges.equalToSuperview().inset(22)
        }
        
        detailLabelView.snp.makeConstraints { make in
            make.top.equalTo(labelView.snp.bottom)
            make.horizontalEdges.equalToSuperview().inset(24)
        }
        
        detailLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(22)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.verticalEdges.equalToSuperview().inset(18)
        }
        
        selectButton.snp.makeConstraints { make in
            make.top.equalTo(detailLabelView.snp.bottom).offset(17)
            make.horizontalEdges.equalToSuperview().inset(26.5)
            make.height.equalTo(44)
        }
        
        characterMotionView.snp.makeConstraints { make in
            make.top.equalTo(selectButton.snp.bottom).offset(17)
            make.width.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        characterMotionViewTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(30)
            make.left.equalToSuperview().inset(24.5)
        }
        
        orbCharacterIconImage.snp.makeConstraints { make in
            make.centerY.equalTo(characterMotionViewTitleLabel)
            make.leading.equalTo(characterMotionViewTitleLabel.snp.trailing).offset(8)
            make.size.equalTo(27)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(characterMotionViewTitleLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(24.5)
            collectionViewHeightConstraint = make.height.equalTo(800).constraint // 초기 높이
            make.bottom.equalToSuperview().inset(78)
        }
    }
    
    // MARK: - Private Func
    
    private func setupHierarchy() {
        addSubviews(
            scrollView,
            customNavigationBar,
            customBackButton,
            chatLogButton
        )
        scrollView.addSubview(contentView)
        
        contentView.addSubviews(
            characterImageView,
            labelView,
            detailLabelView,
            selectButton,
            characterMotionView
        )
        labelView.addSubviews(
            nameLabel,
            crownBadgeImageView,
            titleLabel
        )
        detailLabelView.addSubviews(
            detailLabel,
            dottedLineView
        )
        characterMotionView.addSubviews(
            characterMotionViewTitleLabel,
            orbCharacterIconImage,
            collectionView
        )
    }
    
    private func setupStyle() {
        backgroundColor = .primary(.listBg)
        customNavigationBar.backgroundColor = .primary(.listBg)
        
        customBackButton.configureButtonTitle(titleString: "획득 캐릭터")
        
        chatLogButton.do { button in
            button.setTitle("채팅 로그", for: .normal)
            button.setTitleColor(.grayscale(.gray100), for: .disabled)
            button.configureBackgroundColorWhen(normal: .sub(.sub55), highlighted: .sub(.sub), disabled: .sub(.sub55).withAlphaComponent(0.4))
            button.configuration?.baseForegroundColor = .primary(.white)
            button.configureTitleFontWhen(normal: .offroad(style: .iosTextContents))
            button.layer.borderColor = UIColor.sub(.sub).cgColor
            button.layer.borderWidth = 1
            button.roundCorners(cornerRadius: 18)
        }
        
        scrollView.showsVerticalScrollIndicator = false
        characterImageView.contentMode = .scaleAspectFit
        
        labelView.do { view in
            view.backgroundColor = .primary(.white)
            view.roundCorners(cornerRadius: 10)
        }
        
        dottedLineView.do { view in
            let shapeLayer = CAShapeLayer()
            shapeLayer.strokeColor = UIColor.home(.homeContents2).cgColor
            shapeLayer.lineWidth = 2
            shapeLayer.lineDashPattern = [4, 4]
            
            let viewWidth = UIScreen.current.bounds.width
            
            let path = CGMutablePath()
            path.addLines(between: [CGPoint(x: 0, y: 0),
                                    CGPoint(x: viewWidth - 50, y: 0)])
            shapeLayer.path = path
            view.layer.masksToBounds = true
            view.layer.addSublayer(shapeLayer)
        }
        
        detailLabelView.do { label in
            label.backgroundColor = .primary(.white)
            label.roundCorners(cornerRadius: 10)
        }
        
        nameLabel.do { label in
            label.textColor = UIColor.sub(.sub4)
            label.font = UIFont.offroad(style: .iosSubtitle2Bold)
        }
        
        characterMotionViewTitleLabel.do { label in
            label.text = "캐릭터 모션"
            label.textAlignment = .left
            label.textColor = UIColor.main(.main2)
            label.font = UIFont.offroad(style: .iosSubtitle2Bold)
        }
        
        orbCharacterIconImage.contentMode = .scaleAspectFit
        
        titleLabel.do { label in
            label.textAlignment = .left
            label.textColor = UIColor.grayscale(.gray300)
            label.font = UIFont.offroad(style: .iosTextContentsSmall)
            label.numberOfLines = 0
        }
        
        crownBadgeImageView.do { imageView in
            imageView.contentMode = .scaleAspectFit
            imageView.isHidden = true
        }
        
        detailLabel.do { label in
            label.textAlignment = .left
            label.numberOfLines = 0
            label.textColor = UIColor.grayscale(.gray400)
            label.font = UIFont.offroad(style: .iosBoxMedi)
        }
        
        selectButton.do { button in
            button.configureBackgroundColorWhen(normal: .main(.main2), highlighted: .blackOpacity(.black55), disabled: .blackOpacity(.black25))
            button.configureTitleFontWhen(normal: .offroad(style: .iosTextContents))
            button.roundCorners(cornerRadius: 20)
            button.setTitleColor(.primary(.white), for: .normal)
            button.setTitleColor(.primary(.white), for: .disabled)
            button.setTitle("대표 캐릭터로 선택하기", for: .normal)
            button.setTitle("이미 선택된 캐릭터에요", for: .disabled)
        }
        
        characterMotionView.do { view in
            view.backgroundColor = .primary(.white)
            view.roundCorners(cornerRadius: 16)
        }
        
        collectionView.do { collectionView in
            collectionView.register(CharacterDetailCell.self, forCellWithReuseIdentifier: "CharacterDetailCell")
            collectionView.backgroundColor = .clear
            collectionView.isScrollEnabled = false
        }
        
    }
    
    //MARK: - Func
    
    func updateCollectionViewHeight() {
        let contentHeight = collectionView.collectionViewLayout.collectionViewContentSize.height
        collectionViewHeightConstraint?.update(offset: contentHeight)
    }
    
    func configurerCharacterDetailView(using characterInfo: CharacterDetailInfo) {
        fetchSVG(svgURLString: characterInfo.characterBaseImageUrl) { image in
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.characterImageView.stopLoading()
                self.characterImageView.image = image
            }
        }
        
        customNavigationBar.backgroundColor = UIColor(hex: characterInfo.characterSubColorCode)
        backgroundColor = UIColor(hex: characterInfo.characterSubColorCode)
        nameLabel.text = characterInfo.characterName
        titleLabel.text = characterInfo.characterSummaryDescription
        detailLabel.text = characterInfo.characterDescription
        detailLabel.setLineSpacing(spacing: 5)
    }
    
}
