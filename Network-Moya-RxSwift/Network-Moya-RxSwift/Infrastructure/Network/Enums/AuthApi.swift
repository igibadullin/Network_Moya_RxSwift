//
//  AuthApi.swift
//  Network-Moya-RxSwift
//
//  Created by Ilya Gibadullin on 03/10/2019.
//  Copyright © 2020 Ilya Gibadullin. All rights reserved.
//

import Foundation
import Moya

enum AuthApi {
    case postSingIn(email: String, password: String)
}

extension AuthApi: IApi, TargetType {
    var baseURL: URL {
        return URL(string: EndpointConstants.apiEndpoint + "/auth")!
    }

    var path: String {
        switch self {
        case .postSingIn:
            return "/Account/Login"
        default:
            return ""
        }
    }

    var method: Moya.Method {
        return .post
    }

    var sampleData: Data {
        return Data()
    }

    var task: Task {
        switch self {
        case let .postSingIn(email, password):
            return .requestParameters(parameters: ["Email": email, "Password": password], encoding: JSONEncoding.default)
        default:
            return .requestPlain
        }
        
    }

    var headers: [String: String]? {
        return nil
    }
}

