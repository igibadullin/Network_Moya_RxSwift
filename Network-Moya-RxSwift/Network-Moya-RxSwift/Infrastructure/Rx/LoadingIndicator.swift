//
//  LoadingAlertViewController.swift
//  Network-Moya-RxSwift
//
//  Created by igibadullin on 29/10/2019.
//  Copyright © 2020 Ilya Gibadullin. All rights reserved.
//

import UIKit
import RxSwift

extension Observable {
    func loadingIndicator(_ loadingView: UIView?, key: String) -> Observable {

        let startIndicator = {
            let currentCount = BusyCache.shared.getBusyCount(for: key)
            BusyCache.shared.setBusyCount(currentCount + 1, key: key)
            checkIfBusy()
        }

        let stopIndicator = {
            let currentCount = BusyCache.shared.getBusyCount(for: key)
            BusyCache.shared.setBusyCount(currentCount - 1, key: key)
            checkIfBusy()
        }

        let startIndicatorAsync = {
            if (Thread.current.isMainThread) {
                startIndicator()
            } else {
                DispatchQueue.main.async {
                    startIndicator()
                }
            }
        }

        let stopIndicatorAsync = {
            if (Thread.current.isMainThread) {
                stopIndicator()
            } else {
                DispatchQueue.main.async {
                    stopIndicator()
                }
            }
        }
        
        func checkIfBusy() {
            if BusyCache.shared.getBusyCount(for: key) > 0 {
                //loadingView?.makeToastActivity(.center)
            } else {
                BusyCache.shared.setBusyCount(0, key: key)
                //loadingView?.hideToastActivity()
            }
        }

        return self.do(
            onError: { _ in
                stopIndicatorAsync()
            },
            onCompleted: stopIndicatorAsync,
            onSubscribe: startIndicatorAsync
        )
    }
}
