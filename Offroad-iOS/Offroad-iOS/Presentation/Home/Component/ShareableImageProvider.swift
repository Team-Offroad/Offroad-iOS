//
//  ShareableImageProvider.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 11/6/24.
//

import UIKit

import LinkPresentation

final class ShareableImageProvider: NSObject, UIActivityItemSource {
    private let image: UIImage

    init(image: UIImage) {
        self.image = image
        
        super.init()
    }

    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return image
    }

    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        return image
    }

    func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {
        guard let jpgImage = image.jpegData(compressionQuality: 1.0) else { return nil }
        let metadata = LPLinkMetadata()
        metadata.title = "이미지를 공유합니다."
        if #available(iOS 16.0, *) {
            metadata.originalURL = URL(filePath: "JPEG File · \(jpgImage.fileSize())")
        }
        metadata.imageProvider = NSItemProvider(object: image)
        return metadata
    }
}

private extension Data {
    func fileSize() -> String {
        let size = Double(self.count)
        if size < 1024 {
            return String(format: "%.2f bytes", size)
        } else if size < 1024 * 1024 {
            return String(format: "%.2f KB", size/1024.0)
        } else {
            return String(format: "%.2f MB", size/(1024.0*1024.0))
        }
    }
}
