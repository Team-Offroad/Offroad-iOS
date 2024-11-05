//
//  String+.swift
//  Offroad-iOS
//
//  Created by 김민성 on 2024/07/06.
//

import Foundation

extension String {
    
    func isValidHexSixDigits() -> Bool {
        guard let regex = try? NSRegularExpression(pattern: "^[0-9a-fA-F]{6}$") else { return false }
        let range = NSRange(location: 0, length: self.count)
        let resultLength = regex.rangeOfFirstMatch(in: self, range: range).length
        return resultLength == 6 ? true : false
    }
    
    func getValidHexDigits() -> Int? {
        guard let regex = try? NSRegularExpression(pattern: "^([0-9a-fA-F]{6}|[0-9a-fA-F]{8})$") else { return nil }
        let range = NSRange(location: 0, length: self.count)
        let resultLength = regex.rangeOfFirstMatch(in: self, range: range).length
        if resultLength == 6 {
            return 6
        } else if resultLength == 8 {
            return 8
        } else {
            return nil
        }
    }
    
    //한글 2byte, 영어 1byte인 EUC-KR 계산
    var eucKrByteLength: Int {
        var count = 0
        for scalar in self.unicodeScalars {
            if scalar.isASCII {
                count += 1
            } else if scalar.value >= 0xAC00 && scalar.value <= 0xD7A3 {
                count += 2
            } else {
                count += 2
            }
        }
        return count
    }
    
    /// 문자열에서 특정 범위를 지정하여 슬라이싱한 문자열을 반환하는 함수
    /// - Parameter string: 함수를 적용할 String 값
    /// - Parameter start: 추출할 문자열의 시작 글자 위치 - 1 (ex: 1번째 문자부터 시작이라면 0)
    /// - Parameter end: 추출할 문자열의 끝 글자 위치
    /// > 사용 예시 : `string.sliceByRange(string: titleString, start: 0, end: 8)`
    func sliceByRange(string: String, start: Int, end: Int) -> String {
        let startIndex = string.index(string.startIndex, offsetBy: start)
        let endIndex = string.index(string.startIndex, offsetBy: end)
        
        return String(string[startIndex..<endIndex])
    }
}
