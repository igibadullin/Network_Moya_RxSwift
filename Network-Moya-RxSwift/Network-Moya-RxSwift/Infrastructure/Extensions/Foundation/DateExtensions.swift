//
//  DateExtensions.swift
//  Network-Moya-RxSwift
//
//  Created by Ilya Gibadullin on 03/09/2018.
//  Copyright © 2020 Ilya Gibadullin. All rights reserved.
//

import Foundation

enum DateError: Error {
    case invalidDate
}

extension Date {
    func getStringWithFormat(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier: "ru-RU")
        
        return dateFormatter.string(from: self)
    }
    
    func toISO8601() -> String {
        return ObjectsCache.iso8601Formatter.instance().string(from: self)
    }
    
    func dayBefore() -> Date? {
        return Calendar.current.date(byAdding: .day, value: -1, to: self)
    }
}
