//
//  UIViewControllerExtension.swift
//  Network-Moya-RxSwift
//
//  Created by Ilya Gibadullin on 17/09/2018.
//  Copyright © 2020 Ilya Gibadullin. All rights reserved.
//

import UIKit

public extension UIViewController {
    func show(alert: UIAlertController, for duration: TimeInterval, animated: Bool = true, completion: ((() -> ())?)) {
        present(alert, animated: animated) {
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                alert.dismiss(animated: animated, completion: nil)
                if completion != nil {
                    completion?()
                }
            }
        }
    }
    
    func goBlur() {
        self.view.backgroundColor = .clear
        
        let effect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurView = UIVisualEffectView(effect: effect)
        
        blurView.frame = self.view.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.view.insertSubview(blurView, at: 0)
    }
    
}
