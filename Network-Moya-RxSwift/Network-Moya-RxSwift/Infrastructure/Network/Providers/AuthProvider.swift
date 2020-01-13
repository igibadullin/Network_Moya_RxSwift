//
//  AuthProvider.swift
//  Network-Moya-RxSwift
//
//  Created by Ilya Gibadullin on 03/10/2019.
//  Copyright © 2020 Ilya Gibadullin. All rights reserved.
//

import Foundation
import Moya
import RxSwift

protocol IAuthProvider {
    func signIn(email: String, password: String) -> Observable<Response>
}

class AuthProvider: BaseProvider, IAuthProvider {
    private let _provider: MoyaProvider<AuthApi>

    override init() {
        _provider = BaseProjectProvider<AuthApi>()
        super.init()
    }

    func signIn(email: String, password: String) -> Observable<Response> {
        return _provider.request(.postSingIn(email: email, password: password))
            .validateResponse()
    }
}
