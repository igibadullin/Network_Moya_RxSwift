//
//  UIStoryboardExtensions.swift
//  Network-Moya-RxSwift
//
//  Created by Ilya Gibadullin on 22/05/2019.
//  Copyright © 2020 Ilya Gibadullin. All rights reserved.
//

import UIKit

extension UIStoryboard {
    static private(set) var main: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    static private(set) var auth: UIStoryboard = UIStoryboard(name: "Auth", bundle: nil)
}
