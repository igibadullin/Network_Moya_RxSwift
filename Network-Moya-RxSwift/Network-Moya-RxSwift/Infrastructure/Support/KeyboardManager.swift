//
//  KeyboardManager.swift
//  Network-Moya-RxSwift
//
//  Created by Ilya Gibadullin on 23/08/2018.
//  Copyright © 2020 Ilya Gibadullin. All rights reserved.
//

import UIKit

open class KeyboardManager: NSObject {
    public enum KeyboardEvent {
        case willShow
        case didShow
        case willHide
        case didHide
        case willChangeFrame
        case didChangeFrame
    }

    public struct KeyboardOptions {
        public let belongsToCurrentApp: Bool
        public let startFrame: CGRect
        public let endFrame: CGRect
        public let animationCurve: UIView.AnimationCurve
        public let animationDuration: Double

        fileprivate init(belongsToCurrentApp: Bool, startFrame: CGRect, endFrame: CGRect, animationCurve: UIView.AnimationCurve, animationDuration: Double) {
            self.belongsToCurrentApp = belongsToCurrentApp
            self.startFrame = startFrame
            self.endFrame = endFrame
            self.animationCurve = animationCurve
            self.animationDuration = animationDuration
        }
    }

    public typealias KeyboardCallback = (KeyboardOptions) -> Void

    private var callbacks: [KeyboardEvent: [KeyboardCallback]] = [:]

    public func start() {
        let center = NotificationCenter.default
        for key in callbacks.keys {
            center.addObserver(self, selector: key.selector, name: key.notification, object: nil)
        }
    }

    public func stop() {
        let center = NotificationCenter.default
        center.removeObserver(self)
    }

    @discardableResult
    public func on(_ event: KeyboardEvent, do callback: @escaping KeyboardCallback) -> Self {
        if callbacks[event] == nil {
            callbacks[event] = [callback]
        } else {
            callbacks[event]!.append(callback)
        }
        return self
    }

    @discardableResult
    public func on(_ events: [KeyboardEvent], do callback: @escaping KeyboardCallback) -> Self {
        for event in events {
            if callbacks[event] == nil {
                callbacks[event] = [callback]
            } else {
                callbacks[event]!.append(callback)
            }
        }
        return self
    }

    private func options(from userInfo: [AnyHashable: Any]?) -> KeyboardOptions {
        let currentApp = (userInfo?[UIResponder.keyboardIsLocalUserInfoKey] as? NSNumber)?.boolValue ?? true
        let endFrame = (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue ?? .zero
        let startFrame = (userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue ?? .zero
        let animationCurve = UIView.AnimationCurve(rawValue: (userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber)?.intValue ?? 3) ?? .linear
        let animationDuration = (userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0

        return KeyboardOptions(
            belongsToCurrentApp: currentApp,
            startFrame: startFrame,
            endFrame: endFrame,
            animationCurve: animationCurve,
            animationDuration: animationDuration
        )
    }

    @objc func keyboardWillShow(notification: Notification) {
        let options = self.options(from: notification.userInfo)
        for callback in callbacks[.willShow] ?? [] {
            DispatchQueue.main.async {
                callback(options)
            }
        }
    }

    @objc func keyboardDidShow(notification: Notification) {
        let options = self.options(from: notification.userInfo)
        for callback in callbacks[.didShow] ?? [] {
            DispatchQueue.main.async {
                callback(options)
            }
        }
    }

    @objc func keyboardWillHide(notification: Notification) {
        let options = self.options(from: notification.userInfo)
        for callback in callbacks[.willHide] ?? [] {
            DispatchQueue.main.async {
                callback(options)
            }
        }
    }

    @objc func keyboardDidHide(notification: Notification) {
        let options = self.options(from: notification.userInfo)
        for callback in callbacks[.didHide] ?? [] {
            DispatchQueue.main.async {
                callback(options)
            }
        }
    }

    @objc func keyboardWillChangeFrame(notification: Notification) {
        let options = self.options(from: notification.userInfo)
        for callback in callbacks[.willChangeFrame] ?? [] {
            DispatchQueue.main.async {
                callback(options)
            }
        }
    }

    @objc func keyboardDidChangeFrame(notification: Notification) {
        let options = self.options(from: notification.userInfo)
        for callback in callbacks[.didChangeFrame] ?? [] {
            DispatchQueue.main.async {
                callback(options)
            }
        }
    }
}

fileprivate extension KeyboardManager.KeyboardEvent {
    var notification: NSNotification.Name {
        switch self {
        case .willShow: return UIResponder.keyboardWillShowNotification
        case .didShow: return UIResponder.keyboardDidShowNotification
        case .willHide: return UIResponder.keyboardWillHideNotification
        case .didHide: return UIResponder.keyboardDidHideNotification
        case .willChangeFrame: return UIResponder.keyboardWillChangeFrameNotification
        case .didChangeFrame: return UIResponder.keyboardDidChangeFrameNotification
        }
    }

    var selector: Selector {
        switch self {
        case .willShow:
            return #selector(KeyboardManager.keyboardWillShow(notification:))
        case .didShow:
            return #selector(KeyboardManager.keyboardDidShow(notification:))
        case .willHide:
            return #selector(KeyboardManager.keyboardWillHide(notification:))
        case .didHide:
            return #selector(KeyboardManager.keyboardDidHide(notification:))
        case .willChangeFrame:
            return #selector(KeyboardManager.keyboardWillChangeFrame(notification:))
        case .didChangeFrame:
            return #selector(KeyboardManager.keyboardDidChangeFrame(notification:))
        }
    }
}
