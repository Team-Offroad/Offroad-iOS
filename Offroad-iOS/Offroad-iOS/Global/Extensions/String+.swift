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
    
}
