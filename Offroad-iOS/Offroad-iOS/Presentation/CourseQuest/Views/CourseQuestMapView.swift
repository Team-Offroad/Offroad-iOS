//
//  CourseQuestMapView.swift
//  Offroad-iOS
//
//  Created by  정지원 on 6/24/25.
//

import UIKit
import NMapsMap
import CoreLocation

final class CourseQuestMapView: NMFNaverMapView {

    private let locationManager = CLLocationManager()
    private var markers: [NMFMarker] = []

    private let locationOverlayImage = NMFOverlayImage(image: .icnQuestMapCircleInWhiteBorder)
    private let triangleArrowOverlayImage = NMFOverlayImage(image: .icnQuestMapNavermapLocationOverlaySubIcon1)

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupMapView()
        customizeLocationOverlay()
        setupLocationManager()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupMapView() {
        mapView.logoAlign = .leftTop
        mapView.logoInteractionEnabled = true
        mapView.positionMode = .normal
        showZoomControls = false
        showCompass = false
        mapView.locationOverlay.hidden = false
    }

    private func customizeLocationOverlay() {
        mapView.locationOverlay.do { overlay in
            overlay.icon = locationOverlayImage
            overlay.subIcon = triangleArrowOverlayImage
            overlay.subAnchor = CGPoint(x: 0.5, y: 1)
            overlay.subIconWidth = 8
            overlay.subIconHeight = 17.5
            overlay.circleColor = .sub(.sub).withAlphaComponent(0.25)
        }
    }

    private func setupLocationManager() {
        locationManager.delegate = self
        
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
    }

    func configure(with places: [CourseQuestDetailPlaceDTO]) {
        // 기존 마커 제거
        markers.forEach { $0.mapView = nil }
        markers.removeAll()

        let positions = places.map { place -> NMGLatLng in
            let position = NMGLatLng(lat: place.latitude, lng: place.longitude)
            let marker = NMFMarker(position: position)

            marker.iconImage = getMarkerIconImage(for: place.category)
            marker.captionText = place.name
            marker.mapView = self.mapView

            markers.append(marker)
            return position
        }

        moveCamera(placesToShow: positions, padding: 80)
    }

    private func getMarkerIconImage(for category: String) -> NMFOverlayImage {
        switch category {
        case "카페":
            return NMFOverlayImage(image: UIImage(resource: .icnYellowIndicator))
        case "공원":
            return NMFOverlayImage(image: UIImage(resource: .icnGreenIndicator))
        case "식당":
            return NMFOverlayImage(image: UIImage(resource: .icnOrangeIndicator))
        case "문화":
            return NMFOverlayImage(image: UIImage(resource: .icnPinkIndicator))
        case "스포츠":
            return NMFOverlayImage(image: UIImage(resource: .icnBlueIndicator))
        default:
            return NMFOverlayImage(image: UIImage(resource: .icnOrangeIndicator))
        }
    }

    private func moveCamera(placesToShow coordinates: [NMGLatLng], padding: CGFloat = 0) {
        guard !coordinates.isEmpty else {
            let gwanghwamunSquare = NMGLatLng(lat: 37.5716229, lng: 126.9767879)
            let cameraUpdate = NMFCameraUpdate(scrollTo: gwanghwamunSquare)
            mapView.moveCamera(cameraUpdate)
            return
        }

        let bounds = NMGLatLngBounds(latLngs: coordinates)
        let cameraUpdate = NMFCameraUpdate(fit: bounds, padding: padding)
        mapView.moveCamera(cameraUpdate)
    }
}

extension CourseQuestMapView: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        mapView.locationOverlay.heading = newHeading.trueHeading
        let cameraUpdate = NMFCameraUpdate(heading: newHeading.trueHeading)
        cameraUpdate.reason = 10
        cameraUpdate.animation = .easeOut
        mapView.moveCamera(cameraUpdate)
    }
}
