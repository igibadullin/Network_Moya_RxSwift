//
//  Moya+Promises+Decodable.swift
//  Network-Moya-RxSwift
//
//  Created by Ilya Gibadullin on 16/08/2018.
//  Copyright © 2020 Ilya Gibadullin. All rights reserved.
//

import Moya
import RxSwift

public extension Observable where Element: Moya.Response {

    func validateResponse() -> Observable<Element> {
        return self.do(onNext: { r in
            if !(200..<300 ~= r.statusCode) {
                var serverError = try? ObjectsCache.jsonDecoder.instance().decode(ServerError.self, from: r.data)
                if serverError == nil {
                    let msg = String(data: r.data, encoding: String.Encoding.utf8) ?? "Неизвестная ошибка";
                    serverError = ServerError(code: nil, description: msg, fullDescription: msg)
                }
                serverError!.setHttpCode(code: r.response?.statusCode)
                
                debugPrint("\(r.request!) failed with error: \(r.statusCode)")
                
                throw serverError!
            }
        })
    }

    func mapResponse<T: Decodable>(to: T.Type) -> Observable<T> {
        return self.map { response -> T in
            return try ObjectsCache.jsonDecoder.instance().decode(T.self, from: response.data)
        }
    }
}
