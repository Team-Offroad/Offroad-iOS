//
//  OffroadPlace.swift
//  Offroad-iOS
//
//  Created by 김민성 on 2024/07/16.
//

import Foundation

import NMapsMap

enum OffroadPlaceCategory {
    case cafe
    case park
    case restaurant
    case culture
    case sport
    case none
}

struct OffroadPlace {
    
    let id: Int // 1,
    let name: String //"Place1",
    let address: String //"서울시 강남구~~",
    let shortIntroduction: String //"파주 브런치 대형~",
    let placeCategory: OffroadPlaceCategory //"caffe",
    let latLng: NMGLatLng
//    let latitude: Double //37.12345,
//    let longitude: Double //-122.6789,
    let visitCount: Int //10
    
}



let dummyPlaces: [OffroadPlace] = [
    OffroadPlace(
        id: 1,
        name: "Place1",
        address: "서울시 강남구 테헤란로 123",
        shortIntroduction: "테헤란로의 멋진 카페",
        placeCategory: OffroadPlaceCategory.cafe,
        latLng: NMGLatLng(lat: 37.566900, lng: 126.923500),
        visitCount: 5
    ),
    OffroadPlace(
        id: 2,
        name: "Place2",
        address: "서울시 서초구 서초대로 456",
        shortIntroduction: "서초대로의 유명 레스토랑",
        placeCategory: OffroadPlaceCategory.cafe,
        latLng: NMGLatLng(lat: 37.567000, lng: 126.923600),
        visitCount: 5
    ),
    OffroadPlace(
        id: 3,
        name: "Place3",
        address: "서울시 마포구 홍익로 789",
        shortIntroduction: "홍익로의 아름다운 공원",
        placeCategory: OffroadPlaceCategory.cafe,
        latLng: NMGLatLng(lat: 37.566800, lng: 126.923400),
        visitCount: 5
    ),
    OffroadPlace(
        id: 4,
        name: "Place4",
        address: "서울시 종로구 세종대로 101",
        shortIntroduction: "세종대로의 문화 명소",
        placeCategory: OffroadPlaceCategory.cafe,
        latLng: NMGLatLng(lat: 37.566700, lng: 126.923200),
        visitCount: 5
    ),
    OffroadPlace(
        id: 5,
        name: "Place5",
        address: "서울시 송파구 올림픽로 222",
        shortIntroduction: "올림픽로의 스포츠 센터",
        placeCategory: OffroadPlaceCategory.cafe,
        latLng: NMGLatLng(lat: 37.566600, lng: 126.923100),
        visitCount: 5
    ),
    OffroadPlace(
        id: 6,
        name: "Place6",
        address: "서울시 중구 을지로 333",
        shortIntroduction: "을지로의 무명 장소",
        placeCategory: OffroadPlaceCategory.cafe,
        latLng: NMGLatLng(lat: 37.566500, lng: 126.923000),
        visitCount: 5
    )
]
