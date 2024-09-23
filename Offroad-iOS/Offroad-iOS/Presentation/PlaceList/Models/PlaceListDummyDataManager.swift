//
//  PlaceListDummyDataManager.swift
//  Offroad-iOS
//
//  Created by 김민성 on 8/4/24.
//

import Foundation

class PlaceListDummyDataManager {
    
    static func makeDummyData(count: Int) -> [RegisteredPlaceInfo] {
        
        let brickRouge = RegisteredPlaceInfo(
            id: 0,
            name: "브릭루즈",
            address: "경기도 파주시 지목로 143",
            shortIntroduction: "파주 브런치 맛집 대형 카페",
            placeCategory: "CAFFE",
            placeArea: "시간이 머무는 마을",
            latitude: 0,
            longitude: 0,
            visitCount: 332,
            categoryImageUrl: "https://offroad.s3.ap-northeast-2.amazonaws.com/images/place/caffe.svg?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20240919T144138Z&X-Amz-SignedHeaders=host&X-Amz-Expires=300&X-Amz-Credential=AKIA2UC3FF46A2F5JIHY%2F20240919%2Fap-northeast-2%2Fs3%2Faws4_request&X-Amz-Signature=5a80937ea9f197d6757f6de12c7d5841e9753a08acebcde754d1b093b000ec9a"
        )
        
        let cameloYeonNam = RegisteredPlaceInfo(
            id: 0,
            name: "카멜로연남",
            address: "서울 마포구 연희로1길 57 1.5층",
            shortIntroduction: "다양한 파스타와 리조또가 있는 연남동 양식 맛집",
            placeCategory: "RESTAURANT",
            placeArea: "트렌트의 시작점",
            latitude: 0,
            longitude: 0,
            visitCount: 332,
            categoryImageUrl: "https://offroad.s3.ap-northeast-2.amazonaws.com/images/place/restaurant.svg?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20240919T144138Z&X-Amz-SignedHeaders=host&X-Amz-Expires=300&X-Amz-Credential=AKIA2UC3FF46A2F5JIHY%2F20240919%2Fap-northeast-2%2Fs3%2Faws4_request&X-Amz-Signature=b086c4f00111420465ac09ecc942eede74a7f32a46994349e258a503983b01c7"
        )
        
        let cafeDelcamino = RegisteredPlaceInfo(
            id: 0,
            name: "카페 델카미노",
            address: "서울 마포구 독막로15길 3-14 2층",
            shortIntroduction: "시원한 커피와 디저트, 그리고 편안한 빈티지 스타일을 즐길 수 있는 카페",
            placeCategory: "CAFFE",
            placeArea: "시간이 머무는 마을",
            latitude: 0,
            longitude: 0,
            visitCount: 332,
            categoryImageUrl: "https://offroad.s3.ap-northeast-2.amazonaws.com/images/place/caffe.svg?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20240919T144138Z&X-Amz-SignedHeaders=host&X-Amz-Expires=300&X-Amz-Credential=AKIA2UC3FF46A2F5JIHY%2F20240919%2Fap-northeast-2%2Fs3%2Faws4_request&X-Amz-Signature=5a80937ea9f197d6757f6de12c7d5841e9753a08acebcde754d1b093b000ec9a"
        )
        
        let YanghwajinPark = RegisteredPlaceInfo(
            id: 0,
            name: "양화진 역사공원",
            address: "서울 마포구 토정로 2 양화진공영주차장",
            shortIntroduction: "조선시대 당시 한강을 보호하기 위해 지어진 양화진이 위치한 역사공원",
            placeCategory: "PARK",
            placeArea: "시간이 머무는 마을",
            latitude: 0,
            longitude: 0,
            visitCount: 332,
            categoryImageUrl: "https://offroad.s3.ap-northeast-2.amazonaws.com/images/place/park.svg?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20240919T144138Z&X-Amz-SignedHeaders=host&X-Amz-Expires=300&X-Amz-Credential=AKIA2UC3FF46A2F5JIHY%2F20240919%2Fap-northeast-2%2Fs3%2Faws4_request&X-Amz-Signature=c36d2725725134b3b40d6a16131863e3158ed17ea9a322ddf9a56763e35a8bc7"
        )
        
        let hanyangDoseongMuseum = RegisteredPlaceInfo(
            id: 0,
            name: "한양도성박물관",
            address: "서울 종로구 율곡로 283 1~3층",
            shortIntroduction: "조선시대부터 현재에 이르기까지 한양도성의 역사와 문화를 담은 박물관",
            placeCategory: "CULTURE",
            placeArea: "시간이 머무는 마을",
            latitude: 0,
            longitude: 0,
            visitCount: 332,
            categoryImageUrl: "https://offroad.s3.ap-northeast-2.amazonaws.com/images/place/culture.svg?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20240919T144138Z&X-Amz-SignedHeaders=host&X-Amz-Expires=300&X-Amz-Credential=AKIA2UC3FF46A2F5JIHY%2F20240919%2Fap-northeast-2%2Fs3%2Faws4_request&X-Amz-Signature=f6497ed2205d6306643e72b7dc525df80e9fe5ceb5883c2e6297201905a1cd25"
        )
        
        let jamsilSportsComplex = RegisteredPlaceInfo(
            id: 0,
            name: "잠실 종합운동장",
            address: "서울 송파구 올림픽로 25 서울종합운동장",
            shortIntroduction: "서울 올림픽대회의 개·폐회식과 육상, 축구 등을 치룬 바 있는 역사적 의미를 갖는 경기장",
            placeCategory: "SPORTS",
            placeArea: "시간이 머무는 마을",
            latitude: 0,
            longitude: 0,
            visitCount: 2024,
            categoryImageUrl: "https://offroad.s3.ap-northeast-2.amazonaws.com/images/place/sports.svg?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20240919T144138Z&X-Amz-SignedHeaders=host&X-Amz-Expires=300&X-Amz-Credential=AKIA2UC3FF46A2F5JIHY%2F20240919%2Fap-northeast-2%2Fs3%2Faws4_request&X-Amz-Signature=e866ab43a815a43c886c43eceeffb2446d57c6cbc62ae6e8df5cacac727190b1"
        )
        
        let array = [brickRouge, cameloYeonNam, cafeDelcamino, YanghwajinPark, hanyangDoseongMuseum, jamsilSportsComplex]
        var returnValue: [RegisteredPlaceInfo] = []
        for _ in 0..<count {
            returnValue.append(array.randomElement()!)
        }
        return returnValue
    }
    
}
