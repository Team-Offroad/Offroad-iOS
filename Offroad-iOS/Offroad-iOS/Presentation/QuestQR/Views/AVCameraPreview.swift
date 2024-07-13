//
//  AVCameraPreview.swift
//  Offroad-iOS
//
//  Created by 김민성 on 2024/07/13.
//

import AVFoundation
import UIKit

class AVCameraPreview: UIView {
    
    override class var layerClass: AnyClass {
        AVCaptureVideoPreviewLayer.self
    }
    
    var previewLayer: AVCaptureVideoPreviewLayer {
        layer as! AVCaptureVideoPreviewLayer
    }
    
    var session: AVCaptureSession? {
        get { previewLayer.session }
        set { previewLayer.session = newValue }
    }
    
}
