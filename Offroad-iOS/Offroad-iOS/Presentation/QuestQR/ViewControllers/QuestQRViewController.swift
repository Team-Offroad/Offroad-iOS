//
//  QuestQRViewController.swift
//  Offroad-iOS
//
//  Created by 김민성 on 2024/07/11.
//

import AVFoundation
import UIKit

import SnapKit
import Then

class QuestQRViewController: UIViewController {
    
    //MARK: - Properties
    
    let metadataOutput = AVCaptureMetadataOutput()
    
    var captureSession = AVCaptureSession()
    var videoInput: AVCaptureDeviceInput? = {
        // 시뮬레이터에서 실행할 경우, captureDevice에 nil 이 할당되어 오류 발생
        let captureDevice = AVCaptureDevice.default(for: .video)
        do {
            return try AVCaptureDeviceInput(device: captureDevice!)
        } catch {
            // 카메라가 없는 기기의 경우 인식 불가
            // 추후 별도 안내창 필요
            return nil
        }
    }()
    
    //MARK: - UI Properties
    
    let questQRView = QuestQRView()
    
    //MARK: - Life Cycle
    
    override func loadView() {
        view = questQRView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationController()
        setupNavigationControllerGesture()
        setupCaptureSession()
        setupDelegates()
        setupPrevieLayer()
        
        DispatchQueue.global().async { [weak self] in self?.captureSession.startRunning() }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let questMapNavigationController = navigationController as! QuestMapNavigationController
        questMapNavigationController.setCustomAppearance(state: .questQR)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let screenSize = UIScreen.current.bounds
        let qrTargetRect = questQRView.qrTargetRectBox.frame
        let rectOfInterest = CGRect(
            x: qrTargetRect.minX / screenSize.width,
            y: qrTargetRect.minY / screenSize.height,
            width: qrTargetRect.width / screenSize.width,
            height: qrTargetRect.height / screenSize.height
        )
        metadataOutput.rectOfInterest = questQRView.qrTargetRectBox.frame
        metadataOutput.rectOfInterest = CGRect(x: 0.25, y: 0.25, width: 0.5, height: 0.5)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let offroadTabBarController = tabBarController as! OffroadTabBarController
        offroadTabBarController.hideTabBarAnimation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        let questMapNavigationController = navigationController as! QuestMapNavigationController
        questMapNavigationController.setCustomAppearance(state: .questMap)
        
        let offroadTabBarController = tabBarController as! OffroadTabBarController
        offroadTabBarController.showTabBarAnimation()
    }
    
}

extension QuestQRViewController {
    
    //MARK: - Private Func
    
    private func setNavigationController() {
        self.navigationItem.setHidesBackButton(true, animated: false)        
    }
    
    private func setupNavigationControllerGesture() {
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    private func setupCaptureSession() {
        guard let videoInput else { return }
        captureSession.addInput(videoInput)
        captureSession.addOutput(metadataOutput)
        metadataOutput.metadataObjectTypes = [.qr]
    }
    
    private func setupDelegates() {
        metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.global())
    }
    
    private func setupPrevieLayer() {
        questQRView.cameraView.session = captureSession
    }
    
    //MARK: - Func
}

//MARK: - UIGestureRecognizerDelegate

extension QuestQRViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        print(#function)
        
        // Navigation stack에서 root view controller가 아닌 경우에만 pop 제스처를 허용
        return navigationController!.viewControllers.count > 1
    }
    
}

//MARK: - AVCaptureMetadataOutputObjectDelefate

extension QuestQRViewController: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            print("QR:", stringValue)
            
            let alertCon = UIAlertController(title: "QR코드 인식됨", message: "URL: \(stringValue)", preferredStyle: .actionSheet)
            let okAction = UIAlertAction(title: "넵!", style: .default)
            alertCon.addAction(okAction)
            DispatchQueue.main.async { [weak self] in
                self?.present(alertCon, animated: true)
            }
        }
    }
    
}
