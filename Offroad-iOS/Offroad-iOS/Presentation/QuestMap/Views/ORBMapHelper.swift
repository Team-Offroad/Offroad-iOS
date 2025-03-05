//
//  ORBMapHelper.swift
//  Offroad-iOS
//
//  Created by 김민성 on 2/6/25.
//

import Foundation

import NMapsMap

final class ORBMapHelper {
    
    //MARK: - Properties
    
    unowned let mapView: NMFMapView
    
    //MARK: - Life Cycle
    
    init (map: NMFMapView) {
        self.mapView = map
    }
    
}

extension ORBMapHelper {
    
    //MARK: - Func
    
    /// 지도의 카메라를 지정된 좌표(`NMGLatLng`)로 이동시키는 함수
    /// - Parameters:
    ///   - coordinate: 이동하고자 하는 좌표값. `NMGLatLng` 타입
    ///   - animationCurve: 지도가 움직일 때의 애니메이션 종류. NMFCameraUpdateAnimation 타입.
    ///   - animationDuration: 애니메이션 시간. 0으로 설정할 경우, 애니메이션 없이 바로 이동. 기본값은 NAVER Map iOS SDK에서 설정하는 0.2
    ///   - reason: 카메라 이동에 사용될 `NMFCameraUpdate` 타입의 `reason` 속성에 할당할 값. 기본값은 `NMFMapChangedByDeveloper`이며, -1에 해당. (개발자가 API를 호출해 카메라가 움직였음을 의미)
    ///   - completion: 카메라 이동이 완료되었을 때 호출되는 콜백 블록. 애니메이션이 있으면 완전히 끝난 후에 호출됩니다. `Bool` 타입의 매개변수는 카메라 이동이 완료되기 전에 다른 카메라 이동이 호출되거나 사용자가 제스처로 지도를 조작한 경우 `true`입니다.
    func moveCamera(
        scrollTo coordinate: NMGLatLng,
        animationCurve: NMFCameraUpdateAnimation = .easeOut,
        // NAVER Map iOS SDK에서 지정하는 기본값이 0.2
        animationDuration: TimeInterval = 0.2,
        reason: Int32 = Int32(NMFMapChangedByDeveloper),
        completion: ((Bool) -> Void)? = nil
    ) {
        let cameraUpdate = NMFCameraUpdate(scrollTo: coordinate)
        cameraUpdate.reason = reason
        cameraUpdate.animation = animationCurve
        cameraUpdate.animationDuration = animationDuration
        DispatchQueue.main.async { [weak self] in
            self?.mapView.moveCamera(cameraUpdate) { isCancelled in
                completion?(isCancelled)
            }
        }
    }
    
    /// 지도의 카메라를 현재 위치에서 `delta` 포인트만큼 이동시키는 함수
    /// - Parameters:
    ///   - delta: 이동할 거리. 가로, 세로로 `pt` 단위이며 각각의 값을 `x`, `y` 속성으로 갖는 `CGPoint` 값.
    ///   - animationCurve: 지도가 움직일 때의 애니메이션 종류. NMFCameraUpdateAnimation 타입.
    ///   - animationDuration: 애니메이션 시간. 0으로 설정할 경우, 애니메이션 없이 바로 이동. 기본값은 NAVER Map iOS SDK에서 설정하는 0.2
    ///   - reason: 카메라 이동에 사용될 `NMFCameraUpdate` 타입의 `reason` 속성에 할당할 값. 기본값은 `NMFMapChangedByDeveloper`이며, -1에 해당. (개발자가 API를 호출해 카메라가 움직였음을 의미)
    ///   - completion: 카메라 이동이 완료되었을 때 호출되는 콜백 블록. 애니메이션이 있으면 완전히 끝난 후에 호출됩니다. `Bool` 타입의 매개변수는 카메라 이동이 완료되기 전에 다른 카메라 이동이 호출되거나 사용자가 제스처로 지도를 조작한 경우 `true`입니다.
    func moveCamera(
        scrollBy delta: CGPoint,
        animationCurve: NMFCameraUpdateAnimation = .easeOut,
        // NAVER Map iOS SDK에서 지정하는 기본값이 0.2
        animationDuration: TimeInterval = 0.2,
        reason: Int32 = Int32(NMFMapChangedByDeveloper),
        completion: ((Bool) -> Void)? = nil
    ) {
        let cameraUpdate = NMFCameraUpdate(scrollBy: delta)
        cameraUpdate.reason = reason
        cameraUpdate.animation = animationCurve
        cameraUpdate.animationDuration = animationDuration
        mapView.moveCamera(cameraUpdate) { isCancelled in
            completion?(isCancelled)
        }
    }
    
}
