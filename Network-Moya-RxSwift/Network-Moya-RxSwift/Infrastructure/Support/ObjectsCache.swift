//
//  ObjectsCache.swift
//  Network-Moya-RxSwift
//
//  Created by Ilya Gibadullin on 13/08/2019.
//  Copyright © 2020 Ilya Gibadullin. All rights reserved.
//

import Foundation

class ObjectsCache {
    
    class ThreadCache<T> {
        var key : String
        var generator: () -> T

        init(key: String, generator: @escaping () -> T) {
            self.key = "ThreadCache_\(key)"
            self.generator = generator
        }

        func instance() -> T {
            var instance = Thread.current.threadDictionary[key] as? T

            if (instance == nil) {
                instance = generator()
                Thread.current.threadDictionary[key] = instance
            }

            return instance!
        }
    }

    static let iso8601Formatter = ThreadCache(key: "iso8601Formatter") { () -> DateFormatter in
        let baseFormat =  "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = baseFormat

        return formatter
    }

    static let jsonDecoder = ThreadCache(key: "Network-Moya-RxSwift-jsonDecoder") { () -> JSONDecoder in
        let decoder = JSONDecoder()
        
        decoder.dateDecodingStrategy = .custom { (decoder) -> Date in
            let container = try decoder.singleValueContainer()
            let dateStr = try container.decode(String.self)
            
            if let date = ObjectsCache.iso8601Formatter.instance().date(from: dateStr) {
                return date
            } else {
                return Date()
            }
        }
        return decoder
    }
}
