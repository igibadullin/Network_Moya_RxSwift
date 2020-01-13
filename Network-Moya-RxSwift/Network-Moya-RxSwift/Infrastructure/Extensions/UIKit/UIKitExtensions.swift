//
//  UIKitExtensions.swift
//  Network-Moya-RxSwift
//
//  Created by Ilya Gibadullin on 23/08/2018.
//  Copyright © 2020 Ilya Gibadullin. All rights reserved.
//

import UIKit

extension UIScrollView {
    func scrollToBottom(animated: Bool) {
        let bottomOffset = CGPoint(x: 0, y: contentSize.height - bounds.size.height)
        setContentOffset(bottomOffset, animated: true)
    }
}

extension UIView {
    var currentFirstResponder: UIView? { // todo: performance. first responder можно найти спустив вызов по цепочке респондеров, не перебирая все вьюхи
        guard !isFirstResponder else { return self }
        for view in subviews {
            if let responder = view.currentFirstResponder {
                return responder
            }
        }
        return nil
    }

    func findSuperview(by predicate: (UIView) -> Bool) -> UIView? {
        return predicate(self) ? self : superview?.findSuperview(by: predicate)
    }

    func findSuperview<T: UIView>(by type: T.Type) -> T? {
        return findSuperview(by: { $0 is T }) as? T
    }
}
