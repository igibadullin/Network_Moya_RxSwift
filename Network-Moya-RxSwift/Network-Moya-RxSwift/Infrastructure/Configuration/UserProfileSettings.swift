//
//  UserProfileSettings.swift
//  Network-Moya-RxSwift
//
//  Created by Ilya Gibadullin on 03/10/2018.
//  Copyright © 2020 Ilya Gibadullin. All rights reserved.
//

import Foundation

enum UserProfileSettings : String {
    case fullName = "fullName"
}

extension UserProfileSettings {
    func set(value: Any) {
        UserDefaults.standard.set(value, forKey: self.rawValue)
    }
    
    func drop() {
        UserDefaults.standard.removeObject(forKey: self.rawValue)
    }
    
    func get<T: Any>() -> T? {
        let result = UserDefaults.standard.object(forKey: self.rawValue) as? T
        
        return result
    }
}
