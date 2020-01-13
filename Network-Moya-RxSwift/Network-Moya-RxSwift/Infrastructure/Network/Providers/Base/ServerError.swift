//
//  ServerError
//  Network-Moya-RxSwift
//
//  Created by Ilya Gibadullin on 17/05/2019.
//  Copyright © 2020 Ilya Gibadullin. All rights reserved.
//

import Foundation



class ServerError: LocalizedError, Decodable, CustomStringConvertible {

    // https://stackoverflow.com/questions/44594652/swift-4-json-decodable-simplest-way-to-decode-type-change

    enum CodingKeys: String, CodingKey {
        case code = "status"
        case errorDescription = "title"
        case debugDescription = "debug"
    }

    private(set) var code: String? = nil
    private(set) var errorDescription: String? = nil // это значение используется для localizedDescription
    private(set) var debugDescription: String? = nil

    private(set) var httpCode: Int? = nil


    required public init(from decoder: Decoder) throws {
        if let values = try? decoder.container(keyedBy: CodingKeys.self) {
            code =             try? values.decode(String.self, forKey: .code)
            errorDescription = try? values.decode(String.self, forKey: .errorDescription)
            debugDescription = try? values.decode(String.self, forKey: .debugDescription)
        }
    }

    func setHttpCode(code: Int?) {
        httpCode = code;
    }

    init(code: String?, description: String, fullDescription: String) {
        self.code = code
        self.errorDescription = description
        self.debugDescription = fullDescription
    }

    var description: String {
        get {
            return "\(type(of: self)): code: \(code ?? "-1"); message: \(localizedDescription); debug: \(debugDescription ?? "<null>");"
        }
    }


}
