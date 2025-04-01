//
//  MemoryLightViewController.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 3/17/25.
//

import UIKit

import Photos

final class MemoryLightViewController: UIViewController {
    
    // MARK: - Properties
    
    private let rootView = MemoryLightView()
    private let viewModel = MemoryLightViewModel()

    private var displayedDiaryIndex = 0
    private var exportedImage: UIImage?
    
    // MARK: - Life Cycle
    
    init(firstDisplayedDate: Date? = nil, memoryLightsData: [Diary]) {
        viewModel.displayedDate = firstDisplayedDate
        viewModel.memoryLightsData = memoryLightsData
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTarget()
        setupCollectionView()
        if let displayedDate = viewModel.displayedDate {
            updateBackgroundView(dateIndex: viewModel.indexforDiary(diary: viewModel.diaryForDate(date: displayedDate)))
        } else {
            updateBackgroundView(dateIndex: viewModel.indexforDiary(diary: viewModel.memoryLightsData.last!))
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if let displayedDate = viewModel.displayedDate {
            displayedDiaryIndex = viewModel.indexforDiary(diary: viewModel.diaryForDate(date: displayedDate))
        } else {
            displayedDiaryIndex = viewModel.indexforDiary(diary: viewModel.memoryLightsData.last!)
            
            let calendar = Calendar(identifier: .gregorian)
            var dateComponents = DateComponents()
            dateComponents.year = viewModel.memoryLightsData[displayedDiaryIndex].year
            dateComponents.month = viewModel.memoryLightsData[displayedDiaryIndex].month
            dateComponents.day = viewModel.memoryLightsData[displayedDiaryIndex].day

            viewModel.displayedDate = calendar.date(from: dateComponents)
        }
        
        let indexPath = IndexPath(item: displayedDiaryIndex, section: 0)

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        DispatchQueue.main.async {
            self.rootView.memoryLightCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
            self.viewModel.patchDiaryCheck(date: dateFormatter.string(from: self.viewModel.displayedDate ?? Date()))
        }
    }
}

private extension MemoryLightViewController {
    
    // MARK: - Private Method
    
    func setupTarget() {
        rootView.closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        rootView.shareButton.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
    }
    
    func setupCollectionView() {
        rootView.memoryLightCollectionView.delegate = self
        rootView.memoryLightCollectionView.dataSource = self
    }
    
    func updateBackgroundView(dateIndex: Int) {
        DispatchQueue.main.async {
            self.rootView.updateBackgroundViewUI(pointColorCode: self.viewModel.memoryLightsData[dateIndex].hexCodes[0].small,
                                                 baseColorCode: self.viewModel.memoryLightsData[dateIndex].hexCodes[0].large)
        }
    }
}
    
@objc private extension MemoryLightViewController {

    // MARK: - @objc Method
    
    func closeButtonTapped() {
        dismiss(animated: false)
    }
    
    func shareButtonTapped() {
        if let cell = rootView.memoryLightCollectionView.cellForItem(at: IndexPath(item: displayedDiaryIndex, section: 0)) {
            if let image = cell.convertViewToImage() {
                exportedImage = image
            }
        }
        
        PHPhotoLibrary.requestAuthorization { status in
            print(status)
        }
        
        if let image = exportedImage {
            let imageProvider = ShareableImageProvider(image: image)

            let activityViewController = UIActivityViewController(activityItems: [imageProvider], applicationActivities: nil)
            activityViewController.excludedActivityTypes = [.addToReadingList, .assignToContact, .mail]
            
            if let popoverController = activityViewController.popoverPresentationController {
                popoverController.sourceView = rootView.shareButton
                popoverController.sourceRect = rootView.shareButton.bounds
                popoverController.permittedArrowDirections = .any
            }
            
            self.present(activityViewController, animated: true)
        }
    }
}

//MARK: - UICollectionViewDataSource

extension MemoryLightViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.memoryLightsData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MemoryLightCollectionViewCell.className, for: indexPath) as? MemoryLightCollectionViewCell else { return UICollectionViewCell() }
            cell.configureCell(data: self.viewModel.memoryLightsData[indexPath.item])

        return cell
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension MemoryLightViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: rootView.memoryLightCollectionView.bounds.width - 48, height: rootView.memoryLightCollectionView.bounds.height)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard let layout = rootView.memoryLightCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        
        let cellWidthIncludingSpacing = rootView.memoryLightCollectionView.bounds.width - 48 + layout.minimumLineSpacing
        var offset = targetContentOffset.pointee
        let currentIndex = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing
        
        let index: CGFloat
        if abs(velocity.x) > 0.3 {
            index = velocity.x > 0 ? ceil(currentIndex) : floor(currentIndex)
        } else {
            index = round(currentIndex)
        }
        
        displayedDiaryIndex = Int(index)
        updateBackgroundView(dateIndex: Int(index))
        
        offset = CGPoint(x: index * cellWidthIncludingSpacing - scrollView.contentInset.left, y: 0)
        targetContentOffset.pointee = offset
        
        let calendar = Calendar(identifier: .gregorian)
        var dateComponents = DateComponents()
        dateComponents.year = viewModel.memoryLightsData[displayedDiaryIndex].year
        dateComponents.month = viewModel.memoryLightsData[displayedDiaryIndex].month
        dateComponents.day = viewModel.memoryLightsData[displayedDiaryIndex].day

        viewModel.displayedDate = calendar.date(from: dateComponents)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        viewModel.patchDiaryCheck(date: dateFormatter.string(from: self.viewModel.displayedDate ?? Date()))
    }
}
