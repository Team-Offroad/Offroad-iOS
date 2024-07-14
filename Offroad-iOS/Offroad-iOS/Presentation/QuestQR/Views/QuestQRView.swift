//
//  QuestQRView.swift
//  Offroad-iOS
//
//  Created by 김민성 on 2024/07/11.
//

import AVFoundation
import UIKit

import SnapKit
import Then

class QuestQRView: UIView {
    
    //MARK: - Properties
    
    var qrTargetAreaSideLength: CGFloat!
    
    //MARK: - UI Properties
    
    let qrTargetRectBox = UIView()
    let qrShapeBoxImageView = UIImageView(image: .icnSquareDashedCornerLeft)
    let qrInstructionLabel = UILabel()
    
    var previewLayer = AVCaptureVideoPreviewLayer()
    var notDetectingQRRectView = UIView()
    var cameraView = AVCameraPreview()
    var blueView = UIView().then({ $0.backgroundColor = .systemBlue })
    
    //MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupHierarchy()
        setupLayout()
        setupStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let path = CGMutablePath()
        path.addRect(bounds)
        path.addRoundedRect(in: qrTargetRectBox.frame, cornerWidth: 24, cornerHeight: 24)
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = path
        maskLayer.fillColor = UIColor.blackOpacity(.qrCamera).cgColor
        maskLayer.fillRule = .evenOdd
        
        notDetectingQRRectView.layer.addSublayer(maskLayer)
    }
    
}

extension QuestQRView {
    
    //MARK: - @objc func
    
    //MARK: - private func
    
    private func setupHierarchy() {
        addSubviews(cameraView, notDetectingQRRectView, qrTargetRectBox, qrShapeBoxImageView, qrInstructionLabel)
    }
    
    private func setupLayout() {
        cameraView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        notDetectingQRRectView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let screenWidth = UIScreen.main.bounds.width
        let inset: CGFloat = 24
        qrTargetAreaSideLength = screenWidth - inset * 2
        qrTargetRectBox.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(19)
            make.width.height.equalTo(qrTargetAreaSideLength)
            make.centerX.equalToSuperview()
        }
        
        qrShapeBoxImageView.snp.makeConstraints { make in
            make.top.equalTo(qrTargetRectBox.snp.bottom).offset(42)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(30)
        }
        
        qrInstructionLabel.snp.makeConstraints { make in
            make.top.equalTo(qrShapeBoxImageView.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
        }
    }
    
    private func setupStyle() {
        backgroundColor = .primary(.black)
        qrTargetRectBox.do { view in
            view.clipsToBounds = true
            view.layer.cornerRadius = 24
            view.layer.borderWidth = 3
            view.layer.borderColor = UIColor.sub(.sub).cgColor
        }
        
        qrInstructionLabel.do { label in
            label.text = """
            QR 코드가 잘 보이도록
            카메라를 비춰주세요
            """
            label.numberOfLines = 2
            label.textColor = .primary(.white)
            label.highlightText(targetText: "QR 코드", font: .offroad(style: .iosTextBold), color: .primary(.white))
        }
    }
    
}
