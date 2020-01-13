//
//  StringExtension.swift
//  Network-Moya-RxSwift
//
//  Created by Ilya Gibadullin on 20/08/2018.
//  Copyright © 2020 Ilya Gibadullin. All rights reserved.
//

import Foundation
import UIKit

extension CharacterSet {
    static let dots = CharacterSet(charactersIn: ". ,…")
}

extension String {
    public var isValidEmail: Bool {
        let regex = "^(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])$"
        return range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }
    
    var numeralsOnly: String {
        let pattern = UnicodeScalar("0")..."9"
        return String(unicodeScalars.compactMap { pattern ~= $0 ? Character($0) : nil })
    }
    
    var phoneFormat: String {
        guard self.numeralsOnly.count > 10 else { return self }
        
        let digits = self.numeralsOnly.prefix(11)
        return digits.replacingOccurrences(of: "(\\d{1})(\\d{3})(\\d{3})(\\d{2})(\\d{2})", with: "+$1 ($2) $3-$4-$5", options: .regularExpression, range: nil)
    }
    
    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let size = self.size(withAttributes: [.font: font])
        return size.width
    }
    
    func getDate(format: String = "dd.MM.yyyy") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
        
        return dateFormatter.date(from: self)
    }
    
    func getDateString(format: String = "dd.MM.yyyy") -> String? {
        guard let date = getDate(format: format) else { return nil }
        return ISO8601DateFormatter().string(from: date)
    }
}

extension Optional where Wrapped == String {
    func isNullOrEmpty() -> Bool {
        return self == nil || self == ""
    }
}
