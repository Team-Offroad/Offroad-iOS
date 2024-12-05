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
                    // 완성된 한글 음절 (가 ~ 힣)
                    count += 2
                } else if scalar.value >= 0x3131 && scalar.value <= 0x318E {
                    // 중간 상태 자음/모음 (ㄱ ~ ㆎ)
                    count += 1
                } else {
                    // 기타 한글 또는 기타 문자
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
    
    /// 문자열이 한글로만 이루어져있는지 여부
    private var isHangul: Bool {
        for scalar in self.unicodeScalars {
            if !(scalar.value >= 0xAC00 && scalar.value <= 0xD7A3) { return false }
        }
        return true
    }
    
    /// 문자열이 영어 알파벳으로만 이루어졌는지 여부
    private var isEnglishAlphabet: Bool {
        for scalar in self.unicodeScalars {
            // 대문자도 아니고, 소문자도 아니면 false 반환
            if !(scalar.value >= 0x41 && scalar.value <= 0x5A) &&
                !(scalar.value >= 0x61 && scalar.value <= 0x7A) { return false }
        }
        return true
    }
    
    /// 문자열이 한글 혹은 영어 알파벳으로만 이루어졌는지 여부
    private var containsOnlyKoreanOrEnglish: Bool {
        for char in self {
            let charString = String(char)
            if !charString.isHangul && !charString.isEnglishAlphabet { return false }
        }
        return true
    }
    
    /// 문자열이 EUC-KR 기준으로 몇 byte인지 계산 (한글, 영어 알파벳만 있다고 가정)
    private var totalEUCKRByteCount: Int {
        var hangulCount = 0
        var englishAlphabetCount = 0
        for char in self {
            let char = String(char)
            if char.isHangul {
                hangulCount += 1
            } else if char.isEnglishAlphabet {
                englishAlphabetCount += 1
            }
        }
        return englishAlphabetCount + hangulCount * 2
    }
    
    /// (온보딩 시) 입력된 문자열이 닉네임 형식에 맞는지 여부
    var isValidNicknameFormat: Bool {
        guard !self.isEmpty else { return false }
        guard self.containsOnlyKoreanOrEnglish else { return false }
        guard self.totalEUCKRByteCount <= 16 else { return false }
        if self.isHangul {
            guard self.totalEUCKRByteCount >= 4 else { return false }
        } else if self.isEnglishAlphabet {
            guard self.totalEUCKRByteCount >= 2 else { return false }
        }
        return true
    }
    
}
