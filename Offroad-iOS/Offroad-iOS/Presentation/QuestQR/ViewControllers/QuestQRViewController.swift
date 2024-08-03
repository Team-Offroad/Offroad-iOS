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
    
    let networkService = NetworkService.shared
    let placeInformation: RegisteredPlaceInfo
    let metadataOutput = AVCaptureMetadataOutput()
    
    var captureSession = AVCaptureSession()
    var captureDevice: AVCaptureDevice? = nil
    lazy var videoInput: AVCaptureDeviceInput? = {
        // 시뮬레이터에서 실행할 경우, captureDevice에 nil 이 할당되어 오류 발생
        captureDevice = AVCaptureDevice.default(for: .video)
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
    
    init(placeInformation: RegisteredPlaceInfo) {
        self.placeInformation = placeInformation
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = questQRView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationController()
        setupNavigationControllerGesture()
        setupCaptureSession()
        setupDelegates()
        setupButtonsAction()
        setupPrevieLayer()
        
        DispatchQueue.global().async { [weak self] in self?.captureSession.startRunning() }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
        let offroadTabBarController = tabBarController as! OffroadTabBarController
        offroadTabBarController.hideTabBarAnimation()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let screenSize = UIScreen.current.bounds
        let qrTargetRect = questQRView.qrTargetRectBox.frame
        
        // 주의!!) rectOfInterest를 정할 때
        // (0, 0)은 화면의 우측 상단, (1, 1)은 화면의 좌측 하단이다.
        let rectOfInterest = CGRect(
            x: qrTargetRect.minY / screenSize.height,
            y: qrTargetRect.minX / screenSize.width,
            width: qrTargetRect.height / screenSize.height,
            height: qrTargetRect.width / screenSize.width
        )
        
        // rectOfInterest의 범위는 (0, 0) ~ (1, 1)
        metadataOutput.rectOfInterest = rectOfInterest
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        AVCaptureDevice.requestAccess(for: .video) { [weak self] isGranted in
            guard isGranted else {
                self?.showAlert(title: "카메라 사용 권한 막힘", message: "카메라 접근 권한을 허용해주세요.", okCompletionHandler: { _ in
                    DispatchQueue.main.async {
                        self?.navigationController?.popViewController(animated: true)
                    }
                })
                return
            }
            return
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
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
    
    private func setupButtonsAction() {
        questQRView.customBackButton.addTarget(self, action: #selector(customBackButtonDidTapped), for: .touchUpInside)
    }
    
    @objc private func customBackButtonDidTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    private func setupPrevieLayer() {
        questQRView.cameraView.session = captureSession
    }
    
    private func showAlert(title: String, stringValue: String) {
        DispatchQueue.main.async { [weak self] in
            let alertCon = UIAlertController(title: title, message: "UUID: \(stringValue)", preferredStyle: .actionSheet)
            let okAction = UIAlertAction(title: "넵!", style: .default) { [weak self] _ in
                DispatchQueue.global().async {
                    self?.captureSession.startRunning()
                }
            }
            alertCon.addAction(okAction)
            
            self?.tabBarController?.present(alertCon, animated: true)
        }
    }
    
    private func showAlert(title: String, message: String, okCompletionHandler: ((UIAlertAction) -> Void)? = nil) {
        print(#function)
        DispatchQueue.main.async { [weak self] in
            let alertCon = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
            let okAction = UIAlertAction(title: "넵!", style: .default, handler: okCompletionHandler)
            alertCon.addAction(okAction)
            
            self?.present(alertCon, animated: true)
        }
    }
    
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
            captureSession.stopRunning()
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            print("QR:", stringValue)
            
            let adventureAuthRequestDTO = AdventuresQRAuthenticationRequestDTO(
                placeId: placeInformation.id,
                qrCode: stringValue,
                latitude: placeInformation.latitude,
                longitude: placeInformation.longitude
            )
            networkService.adventureService.authenticateQRAdventure(adventureAuthDTO: adventureAuthRequestDTO) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let response):
                    print("성공")
                    guard let data = response?.data else {
                        self.showAlert(title: "디코딩 실패한 듯", stringValue: "...")
                        return
                    }
                    let notiTitle = data.isQRMatched ? "탐험 성공" : "탐험 실패"
                    let imageURL = data.characterImageUrl
                    let questResultViewController: QuestResultViewController
                    if data.isQRMatched {
                        questResultViewController = QuestResultViewController(result: .success, placeInfo: placeInformation, imageURL: imageURL)
                    } else {
                        questResultViewController = QuestResultViewController(result: .wrongQR, placeInfo: placeInformation, imageURL: imageURL)
                    }
                    
                    questResultViewController.modalPresentationStyle = .overCurrentContext
                    self.navigationController?.popViewController(animated: true)
                    self.tabBarController?.present(questResultViewController, animated: false)
                default:
                    self.showAlert(title: "서버에서 응답이 안왔어여", stringValue: stringValue)
                    return
                }
            }
            
            
        }
    }
    
}
