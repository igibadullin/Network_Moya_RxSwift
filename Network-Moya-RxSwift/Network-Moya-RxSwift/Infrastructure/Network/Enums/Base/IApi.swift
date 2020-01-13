//
//  IApi.swift
//  Network-Moya-RxSwift
//
//  Created by Ilya Gibadullin on 21/08/2018.
//  Copyright © 2020 Ilya Gibadullin. All rights reserved.
//

import Foundation

protocol IApi {}

extension IApi {
    var authToken: String {
        return "bearer " + (Cache.shared.authToken ?? "")
    }
}
