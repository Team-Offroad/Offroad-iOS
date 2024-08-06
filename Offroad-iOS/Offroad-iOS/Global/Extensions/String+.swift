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
}
