//
//  OffroadTabBarController.swift
//  Offroad-iOS
//
//  Created by 김민성 on 2024/07/12.
//

import UIKit

class OffroadTabBarController: UITabBarController {
    
    // MARK: - Properties
    
    var originalTabBarHeight: CGFloat = 0
    var tabBarHeight: CGFloat = UIScreen.current.isAspectRatioTall ? 92 : 60
    private var hideTabBarAnimator = UIViewPropertyAnimator(duration: 0.4, dampingRatio: 1)
    private var showTabBarAnimator = UIViewPropertyAnimator(duration: 0.4, dampingRatio: 1)
    var isTabBarShown: Bool = true
    private let pushType: PushNotificationRedirectModel?
    
    //MARK: - UI Properties
    
    let customOffroadLogoButton = ShrinkableButton(shrinkScale: 0.95)
    let circleBlurView = CustomIntensityBlurView(blurStyle: .light, intensity: 0.1)
    let customTabBar = ORBTabBarShapeView()
    
    // MARK: - Life Cycle
    
    init(pushType: PushNotificationRedirectModel? = nil) {
        self.pushType = pushType
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupHierarchy()
        setupLayout()
        setOffroadViewControllers()
        setupStyle()
        setTabBarButtonStyle()
        setupAppearance()
        setupButtonsAction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        originalTabBarHeight = tabBar.frame.height
        
        let tabBarHeightFromBottomEdge: CGFloat = tabBarHeight
        var newFrame = tabBar.frame
        newFrame.size.height = tabBarHeightFromBottomEdge
        newFrame.origin.y = view.frame.size.height - tabBarHeightFromBottomEdge
        tabBar.frame = newFrame
    }
    
}

extension OffroadTabBarController {
    
    @objc private func centerTabBarButtonItemTapped() {
        selectedIndex = 1
    }
    
    // MARK: - Layout
    
    private func setupHierarchy() {
        tabBar.addSubview(customTabBar)
        tabBar.addSubview(circleBlurView)
        tabBar.addSubview(customOffroadLogoButton)
    }
    
    private func setupLayout() {
        customOffroadLogoButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            // 28: 오브 로고 버튼과 탭바의 세로 영역이 겹치는 부분의 높이
            make.bottom.equalToSuperview().inset(tabBarHeight - 28)
            make.width.height.equalTo(74)
        }
        
        circleBlurView.snp.makeConstraints { make in
            make.edges.equalTo(customOffroadLogoButton)
        }
        
        customTabBar.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalToSuperview()
            make.height.equalTo(tabBarHeight)
        }
    }
    
    private func setupStyle() {
        
        customOffroadLogoButton.do { button in
            button.setImage(.icnTabBarOrbLogo, for: .normal)
        }
        
        circleBlurView.do { view in
            // 탭바의 가운데 버튼 가로/세로 길이: 74
            view.roundCorners(cornerRadius: 37)
        }
        
        tabBar.tintColor = .main(.main1)
        tabBar.unselectedItemTintColor = .main(.main175)
    }
    
    private func setOffroadViewControllers() {
        let homeNavigationController = ORBNavigationController(rootViewController: HomeViewController(pushType: pushType))
        let mypageNavigationController = ORBNavigationController(rootViewController: MyPageViewController())
        
        let viewControllersArray: [UIViewController] = [
            homeNavigationController,
            ORBNavigationController(rootViewController: ORBMapViewController()),
            mypageNavigationController
        ]
        
        setViewControllers(viewControllersArray, animated: false)
        selectedIndex = 0
    }
    
    private func setTabBarButtonStyle() {
        tabBar.items?[0].image = .icnTabBarHomeUnselected
        tabBar.items?[0].selectedImage = .icnTabBarHomeSelected
        tabBar.items?[0].title = "HOME"
        
        tabBar.items?[1].image = nil
        tabBar.items?[1].title = nil
        tabBar.items?[1].isEnabled = false
        
        tabBar.items?[2].image = .icnTabBarMyUnselected
        tabBar.items?[2].selectedImage = .icnTabBarMySelected
        tabBar.items?[2].title = "MY"
    }
    
    private func setupAppearance() {
        let titleAttributes: [NSAttributedString.Key : Any] = [.font: UIFont.offroad(style: .bothBottomLabel)]
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithTransparentBackground()
        tabBarAppearance.stackedLayoutAppearance.normal.titleTextAttributes = titleAttributes
        tabBarAppearance.stackedLayoutAppearance.selected.titleTextAttributes = titleAttributes
        tabBarAppearance.stackedItemPositioning = .centered
        tabBar.standardAppearance = tabBarAppearance
        tabBar.scrollEdgeAppearance = tabBarAppearance
    }
    
    private func setupButtonsAction() {
        customOffroadLogoButton.addTarget(self, action: #selector(centerTabBarButtonItemTapped), for: .touchUpInside)
    }
    
    func disableTabBarInteraction() {
        tabBar.isUserInteractionEnabled = false
        tabBar.items?.enumerated().forEach({ index, item in
            guard index != selectedIndex else { return }
            item.isEnabled = false
        })
        customOffroadLogoButton.isUserInteractionEnabled = false
    }
    
    func enableTabBarInteraction() {
        tabBar.isUserInteractionEnabled = true
        tabBar.items?.forEach({ item in
            guard item != tabBar.items?[1] else { return }
            item.isEnabled = true
        })
        customOffroadLogoButton.isUserInteractionEnabled = true
    }
    
    // MARK: - Func
    
    func hideTabBarAnimation(delayFactor: CGFloat = 0) {
        isTabBarShown = false
        disableTabBarInteraction()
        view.layoutIfNeeded()
        showTabBarAnimator.stopAnimation(true)
        hideTabBarAnimator.addAnimations({ [weak self] in
            self?.tabBar.frame.origin.y = UIScreen.current.bounds.height + 50
        }, delayFactor: delayFactor)
        hideTabBarAnimator.addCompletion { _ in
            self.tabBar.isHidden = true
        }
        hideTabBarAnimator.startAnimation()
    }
    
    func showTabBarAnimation(delayFactor: CGFloat = 0) {
        guard !isTabBarShown else { return }
        disableTabBarInteraction()
        if tabBar.isHidden {
            tabBar.frame.origin.y = UIScreen.current.bounds.height + 30
            tabBar.isHidden = false
        }
        self.hideTabBarAnimator.stopAnimation(true)
        showTabBarAnimator.addAnimations({ [weak self] in
            guard let self else { return }
            self.tabBar.frame.origin.y = UIScreen.current.bounds.height - self.tabBarHeight
        }, delayFactor: delayFactor)
        showTabBarAnimator.addCompletion { [weak self] _ in
            guard let self else { return }
            self.isTabBarShown = true
        }
        showTabBarAnimator.startAnimation()
    }
}
