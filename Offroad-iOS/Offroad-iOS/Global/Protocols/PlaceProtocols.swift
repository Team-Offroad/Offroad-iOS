//
//  PlaceProtocols.swift
//  Offroad-iOS
//
//  Created by 김민성 on 6/17/25.
//
//  장소를 나타내는 데이터 모델의 인터페이스.

import CoreLocation

/// '장소'를 나타내는 데이터가 필수로 가져야 하는 속성들을 포함하는 타입.
protocol BasePlaceType {
    
    /// 장소 이름
    var name: String { get }
    
    /// 장소의 주소
    var address: String { get }
    
    /// 장소의 카테고리. `ORBPlaceCategory` 타입
    var placeCategory: ORBPlaceCategory { get }
    
    /// 장소의 위•경도 좌표
    var coordinate: CLLocationCoordinate2D { get }
    
}

/// 장소에 대해 설명하기 위한 추가적인 정보를 갖는 타입.
///
/// 장소 목록 셀, 툴팁 등에서 장소에 대한 정보를 표시할 때 사용
protocol PlaceDescribable: BasePlaceType {
    
    /// 장소 한 줄 소개
    var shortIntroduction: String { get }
    
    /// 장소 구역(시간이 머무는 마을 등)
    var placeArea: String { get }
    
    /// 방문 횟수
    var visitCount: Int { get }
    
    /// 카테고리 이미지의 URL
    /// - Note: 현재는 사용하지 않음. (이미지 리소스를 바로 사용)
    var categoryImageUrl: URL { get }
    
}
