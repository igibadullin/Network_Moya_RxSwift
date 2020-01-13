//
//  BusyCache.swift
//  Network-Moya-RxSwift
//
//  Created by igibadullin on 19/12/2019.
//  Copyright © 2020 Ilya Gibadullin. All rights reserved.
//

import Foundation

public final class BusyCache {
    public static let shared: BusyCache = .init()

    private init() {}
    
    private let _store: UserDefaults = UserDefaults.standard
    
    func setBusyCount(_ value: Int, key: String) {
        let newValue = max(0, value)
        _store.set(newValue, forKey: key)
    }
    
    func dropBusyCount(for key: String) {
        _store.removeObject(forKey: key)
    }
    
    func getBusyCount(for key: String) -> Int {
        return _store.object(forKey: key) as? Int ?? 0
    }
    
    func dropAll() {
//        for viewController in ValuesConstants.viewControllersNames {
//            dropBusyCount(for: viewController)
//        }
    }
    
}
