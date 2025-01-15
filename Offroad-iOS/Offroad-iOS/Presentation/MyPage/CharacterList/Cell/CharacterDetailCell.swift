//
//  CharacterDetailCell.swift
//  Offroad-iOS
//
//  Created by  정지원 on 8/13/24.
//
import UIKit

import SnapKit

class CharacterDetailCell: UICollectionViewCell, SVGFetchable {
    
    // MARK: - Properties
    
    let containerView = UIView().then {
        $0.backgroundColor = UIColor.primary(.characterSelectBg3)
        $0.roundCorners(cornerRadius: 10)
        $0.clipsToBounds = true
    }
    
    private var motionImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    private let motionTitleLabel = UILabel().then {
        $0.text = ""
        $0.textAlignment = .center
        $0.textColor = UIColor.primary(.white)
        $0.font = UIFont.offroad(style: .iosTextContents)
    }
    
    private let shadowView = UIView().then {
        $0.backgroundColor = .blackOpacity(.black25)
        $0.isHidden = true
    }
    
    private let lockImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(resource: .imgLock)
        $0.isHidden = true
    }
    
    private let newBadgeView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(resource: .imgNewTag)
        $0.isHidden = true
    }
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStyle()
        setupHierarchy()
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        motionImageView.image = nil
    }
    
}

extension CharacterDetailCell {
    
    // MARK: - Private Functions
    
    private func setupStyle() {
        contentView.roundCorners(cornerRadius: 10)
        contentView.clipsToBounds = true
        contentView.backgroundColor = UIColor.home(.homeCharacterName)
    }
    
    private func setupHierarchy() {
        contentView.addSubviews(
            containerView,
            motionTitleLabel,
            shadowView,
            newBadgeView
        )
        shadowView.addSubview(lockImageView)
        containerView.addSubview(motionImageView)
    }
    
    private func setupLayout() {
        contentView.clipsToBounds = true
        
        containerView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.horizontalEdges.equalTo(contentView).inset(10)
        }
        
        motionImageView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(17.5)
            make.verticalEdges.equalToSuperview().inset(17.5)
        }
        
        motionTitleLabel.snp.makeConstraints{ make in
            make.top.equalTo(containerView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(10)
        }
        
        shadowView.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
        
        lockImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(33)
            make.height.equalTo(37)
        }
        
        newBadgeView.snp.makeConstraints { make in
            make.top.trailing.equalTo(containerView).inset(8)
            make.size.equalTo(24)
        }
    }
    
    //MARK: - Func
    
    func configureContent(with data: CharacterMotionInfoData) {
        fetchSVG(svgURLString: data.characterMotionImageUrl) { image in
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.motionImageView.image = image
            }
        }
        
        switch data.category {
        case "CAFFE":
            motionTitleLabel.text = "카페 방문 시"
        case "PARK":
            motionTitleLabel.text = "공원 방문 시"
        case "CULTURE":
            motionTitleLabel.text = "문화 방문 시"
        case "RESTAURANT":
            motionTitleLabel.text = "식당 방문 시"
        case "SPORT":
            motionTitleLabel.text = "헬스장 방문 시"
        default:
            motionTitleLabel.text = ""
        }
        shadowView.isHidden = data.isGained
        lockImageView.isHidden = data.isGained
        newBadgeView.isHidden = !data.isNewGained
    }
    
    func configureColor(mainColor: String?, subColor: String?){
        contentView.backgroundColor = UIColor(hex: mainColor ?? "000000")
        containerView.backgroundColor = UIColor(hex: subColor ?? "000000")
    }
    
}
