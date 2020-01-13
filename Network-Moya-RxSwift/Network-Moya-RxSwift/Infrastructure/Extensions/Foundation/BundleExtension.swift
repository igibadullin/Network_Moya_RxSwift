//
//  BundleExtension.swift
//  Network-Moya-RxSwift
//
//  Created by Ilya Gibadullin on 21.03.2019.
//  Copyright © 2020 Ilya Gibadullin. All rights reserved.
//

import Foundation

extension Bundle {
    func bundleVersion() -> String {
       return "\(Bundle.main.infoDictionary?["CFBundleShortVersionString"] ?? "").\(Bundle.main.infoDictionary?["CFBundleVersion"] ?? "")"
    }
}
