//
//  SplashViewController.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 7/8/24.
//

import UIKit

final class SplashViewController: UIViewController {
    
    //MARK: - Properties
    
    private let rootView = SplashView()
    
    private let pushType: PushNotificationRedirectModel?
    
    // MARK: - Life Cycle
    
    init(pushType: PushNotificationRedirectModel? = nil) {
        self.pushType = pushType
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {        
        view = rootView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        Task { [weak self] in
            do {
                guard let currentAppVersion = try self?.checkCurrentAppVersion() else { return }
                guard let minimumVersion = try await self?.checkMinimumSupportedVersion() else { return }
                if currentAppVersion < minimumVersion {
                    self?.requestUserToUpdateApp()
                } else {
                    self?.processToLogIn()
                }
            } catch {
                print(error.localizedDescription)
                if let appVersionCheckError = error as? AppVersionCheckError {
                    switch appVersionCheckError {
                    case .networkFail:
                        ORBToastManager.shared.showToast(message: ErrorMessages.networkError, inset: 0)
                    default:
                        ORBToastManager.shared.showToast(message: "알 수 없는 문제가 발생했어요. 잠시 후 다시 시도해 주세요.", inset: 0)
                    }
                } else {
                    assertionFailure(error.localizedDescription)
                }
            }
        }
    }
}

extension SplashViewController {
    
    //MARK: - Private Func
    
    private func presentViewController(viewController: UIViewController) {
        viewController.modalPresentationStyle = .overFullScreen
        viewController.modalTransitionStyle = .crossDissolve
        
        let transition = CATransition()
        transition.duration = 0.6
        transition.type = .fade
        transition.subtype = .fromRight
        view.window?.layer.add(transition, forKey: kCATransition)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            self.rootView.dismissOffroadLogiView {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    self.present(viewController, animated: true, completion: nil)
                }
            }
        }
    }
    
    private func checkUserChoosingInfo() {
        NetworkService.shared.adventureService.getAdventureInfo(category: "NONE") { [weak self] response in
            guard let self else { return }
            switch response {
            case .success(let data):
                let characterName = data?.data.characterName ?? ""
                                                
                if characterName == "" {
                    self.presentViewController(viewController: LoginViewController())
                } else {
                    MyInfoManager.shared.updateCharacterListInfo()
                    self.presentViewController(viewController: OffroadTabBarController(pushType: pushType))
                }
            default:
                break
            }
        }
    }
    
    @MainActor
    private func processToLogIn() {
        if ((UserDefaults.standard.string(forKey: "isLoggedIn")?.isEmpty) != nil
            && KeychainManager.shared.loadAccessToken() != nil) {
            checkUserChoosingInfo()
        } else {
            presentViewController(viewController: LoginViewController())
        }
    }
    
}

// 앱 버전 체크(강제 업데이트 유도) 관련
private extension SplashViewController {
    
    enum AppVersionCheckError: LocalizedError {
        case infoPlistNotFound
        case versionNotFound
        case dtoNotFound
        case dtoDecodingFailed
        case minimumSupportedVersionNotFound
        case networkFail
        
        var errorDescription: String? {
            switch self {
            case .infoPlistNotFound: "Info.plist 확인 불가"
            case .versionNotFound: "버전 번호 확인 불가"
            case .dtoNotFound: "DTO 확인 불가. 응답값에서 데이터를 포함하지 않았을 가능성이 높습니다."
            case .dtoDecodingFailed: "DTO 디코딩 실패. MinimumSupportedVersionResponseDTO의 데이터 형식을 확인하세요."
            case .minimumSupportedVersionNotFound: "최소 지원 버전 확인 불가"
            case .networkFail: "네트워크 통신 문제로 인해 최소 지원 버전 확인 불가"
            }
        }
    }
    
    // 현재 설치된 앱의 버전 확인
    func checkCurrentAppVersion() throws -> String {
        guard let infoPlist = Bundle.main.infoDictionary else {
            throw AppVersionCheckError.infoPlistNotFound
        }
        guard let version = infoPlist["CFBundleShortVersionString"] as? String else {
            throw AppVersionCheckError.versionNotFound
        }
        return version
    }
    
    // 서버에서 최소 지원 버전 확인
    func checkMinimumSupportedVersion() async throws -> String {
        do {
            let networkService = NetworkService.shared.minimumSupportedVersionService
            let networkResult = try await networkService.getMinimumSupportedVersion()
            switch networkResult {
            case .success(let dto):
                guard let dto else { throw AppVersionCheckError.dtoNotFound }
                return dto.ios
            case .networkFail:
                throw AppVersionCheckError.networkFail
            case .decodeErr:
                throw AppVersionCheckError.dtoDecodingFailed
            default:
                throw AppVersionCheckError.minimumSupportedVersionNotFound
            }
        } catch {
            throw error
        }
    }
    
    @MainActor
    func requestUserToUpdateApp() {
        let alertController = ORBAlertController(
            title: AlertMessage.enforceAppUpdateTitle,
            message: AlertMessage.enforceAppUpdateMessage,
            type: .normal
        )
        alertController.xButton.isHidden = true
        let action = ORBAlertAction(title: "업데이트하기", style: .default) { [weak self] _ in
            self?.redirectToAppStore()
        }
        alertController.addAction(action)
        present(alertController, animated: true)
    }
    
    func redirectToAppStore() {
        let urlString = "itms-apps://itunes.apple.com/app/id6541756824"
        if let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        } else {
            // 앱 설치가 불가능한 경우 사용자에게 안내.
            // 설정 앱>스크린 타임>콘텐츠 및 개인 정보 보호 제한>iTunes 및 App Store 구입 -> '허용 안 함' 인 경우
            alertIfAppStoreRedirectionFailed()
        }
    }
    
    func alertIfAppStoreRedirectionFailed() {
        let alertController = ORBAlertController(
            message: ErrorMessages.appStoreRedirectionFailure,
            type: .normal
        )
        alertController.xButton.isHidden = true
        let action = ORBAlertAction(title: "확인", style: .default) { _ in return }
        alertController.addAction(action)
        present(alertController, animated: true)
    }
    
}
