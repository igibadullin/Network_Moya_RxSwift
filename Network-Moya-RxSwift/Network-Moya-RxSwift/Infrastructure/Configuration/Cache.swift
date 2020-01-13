//
//  Cache.swift
//  Network-Moya-RxSwift
//
//  Created by Ilya Gibadullin on 24/09/2018.
//  Copyright © 2020 Ilya Gibadullin. All rights reserved.
//

import Foundation
import UIKit

public final class Cache {
    public static let shared: Cache = .init()

    private init() {}
    
    private let _store: UserDefaults = UserDefaults.standard
    
    public var animateAuth = false
    
    public var isAuthorized: Bool {
        return authToken != nil
    }
    
    public var authToken: String? {
        get {
            return _store.string(forKey: #function)
        }
        set {
            _store.set(newValue, forKey: #function)
        }
    }
    
    func saveProfileToCache(_ value: String) {
        UserProfileSettings.fullName.set(value: value)
    }

    func loadProfileFromCache() -> String {
        return UserProfileSettings.fullName.get() ?? ""
    }
    
    func clearProfileSettingsCache() {
        UserProfileSettings.fullName.drop()
    }
    
    func clearCache() {
        authToken = nil
        clearProfileSettingsCache()
        BusyCache.shared.dropAll()
    }
    
    func saveSpecificItem(_ item: UserProfileSettings, value: String) -> Void {
        item.set(value: value)
    }
    
    func loadSpecificItem(_ item: UserProfileSettings) -> String {
        let str: String = item.get() ?? ""
        return str
    }
    
}
