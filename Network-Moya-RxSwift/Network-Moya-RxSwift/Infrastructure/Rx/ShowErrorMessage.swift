//
//  ShowErrorMessage.swift
//  Network-Moya-RxSwift
//
//  Created by Ilya Gibadullin on 15.08.2019.
//  Copyright © 2020 Ilya Gibadullin. All rights reserved.
//

import UIKit
import RxSwift

extension Observable {
    func showErrorMessage(_ message: String = "", suppress: ((Error) -> Bool)? = nil) -> Observable {
        return self.do(onError: { (e) in
            if !(suppress?(e) ?? false) {
                // show alert code
            }
        })
    }
}
