//
//  AlertControllerService.swift
//  Network-Moya-RxSwift
//
//  Created by IlyaGibadullin on 27/05/2019.
//  Copyright © 2020 Ilya Gibadullin. All rights reserved.
//

import UIKit

class AlertControllerService {
    
    static func getAlertController(_ view: UIView?, title: String? = nil, message: String? = nil, preferredStyle: UIAlertController.Style = .alert, actions: [UIAlertAction] = []) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        
        for action in actions {
            alertController.addAction(action)
        }

        let sourceView : UIView? = view ?? UIApplication.shared.keyWindow

        if let sourceView = sourceView {
            // for present on iPad
            if let popoverController = alertController.popoverPresentationController {
                popoverController.sourceView = sourceView
                popoverController.sourceRect = CGRect(x: sourceView.bounds.midX, y: sourceView.bounds.maxY, width: 0, height: 0)
                popoverController.permittedArrowDirections = []
            }
        }
        
        return alertController
    }
    
}
