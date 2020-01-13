//
//  String+Localizable.swift
//  Network-Moya-RxSwift
//
//  Created by Ilya Gibadullin on 05/06/2019.
//  Copyright © 2020 Ilya Gibadullin. All rights reserved.
//

import Foundation

extension String {
    func localized() -> String {
        return NSLocalizedString(self, comment: self)
    }
}
