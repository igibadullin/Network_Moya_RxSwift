//
//  FeatureFutureProvider.swift
//  Network-Moya-RxSwift
//
//  Created by Ilya Gibadullin on 07/08/2019.
//  Copyright © 2020 Ilya Gibadullin. All rights reserved.
//

import Foundation
import Moya

class BaseProjectProvider<Target> : MoyaProvider<Target> where Target : TargetType {

    init() {
        super.init(endpointClosure: { (target) -> Endpoint in
            return Endpoint(
                url: URL(target: target).absoluteString,
                sampleResponseClosure: { .networkResponse(200, target.sampleData) },
                method: target.method,
                task: target.task,
                httpHeaderFields: {
                    var headers = target.headers ?? [:]

                    headers["platform"] = "ios"
                    headers["version"] = Bundle.main.bundleVersion()

                    return headers
                }()
            )
        })
    }
}
