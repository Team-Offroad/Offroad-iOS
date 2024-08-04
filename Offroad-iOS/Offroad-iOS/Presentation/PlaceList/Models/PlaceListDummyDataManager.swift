//
//  PlaceListDummyDataManager.swift
//  Offroad-iOS
//
//  Created by 김민성 on 8/4/24.
//

import Foundation

class PlaceListDummyDataManager {
    
    static func makeDummyData() -> [RegisteredPlaceInfo] {
        
        let brickRouge = RegisteredPlaceInfo(
            id: 0,
            name: "브릭루즈",
            address: "경기도 파주시 지목로 143",
            shortIntroduction: "파주 브런치 맛집 대형 카페",
            placeCategory: "CAFFE",
            latitude: 0,
            longitude: 0,
            visitCount: 332
        )
        
        let cameloYeonNam = RegisteredPlaceInfo(
            id: 0,
            name: "카멜로연남",
            address: "서울 마포구 연희로1길 57 1.5층",
            shortIntroduction: "다양한 파스타와 리조또가 있는 연남동 양식 맛집",
            placeCategory: "RESTAURANT",
            latitude: 0,
            longitude: 0,
            visitCount: 332
        )
        
        let cafeDelcamino = RegisteredPlaceInfo(
            id: 0,
            name: "카페 델카미노",
            address: "서울 마포구 독막로15길 3-14 2층",
            shortIntroduction: "시원한 커피와 디저트, 그리고 편안한 빈티지 스타일을 즐길 수 있는 카페",
            placeCategory: "CAFFE",
            latitude: 0,
            longitude: 0,
            visitCount: 332
        )
        
        let YanghwajinPark = RegisteredPlaceInfo(
            id: 0,
            name: "양화진 역사공원",
            address: "서울 마포구 토정로 2 양화진공영주차장",
            shortIntroduction: "조선시대 당시 한강을 보호하기 위해 지어진 양화진이 위치한 역사공원",
            placeCategory: "PARK",
            latitude: 0,
            longitude: 0,
            visitCount: 332
        )
        
        let hanyangDoseongMuseum = RegisteredPlaceInfo(
            id: 0,
            name: "한양도성박물관",
            address: "서울 종로구 율곡로 283 1~3층",
            shortIntroduction: "조선시대부터 현재에 이르기까지 한양도성의 역사와 문화를 담은 박물관",
            placeCategory: "CULTURE",
            latitude: 0,
            longitude: 0,
            visitCount: 332
        )
        
        let jamsilSportsComplex = RegisteredPlaceInfo(
            id: 0,
            name: "잠실 종합운동장",
            address: "서울 송파구 올림픽로 25 서울종합운동장",
            shortIntroduction: "서울 올림픽대회의 개·폐회식과 육상, 축구 등을 치룬 바 있는 역사적 의미를 갖는 경기장으로서 외국의 많은 관광객이 방문하고 있는 관광명소",
            placeCategory: "SPORTS",
            latitude: 0,
            longitude: 0,
            visitCount: 2024
        )
        
        let array = [brickRouge, cameloYeonNam, cafeDelcamino, YanghwajinPark, hanyangDoseongMuseum, jamsilSportsComplex]
        var returnValue: [RegisteredPlaceInfo] = []
        for i in 0..<60 {
            returnValue.append(array.randomElement()!)
        }
        return returnValue
    }
    
}
