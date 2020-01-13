//
//  Moya+Promises.swift
//  Network-Moya-RxSwift
//
//  Created by Ilya Gibadullin on 16/08/2018.
//  Copyright © 2020 Ilya Gibadullin. All rights reserved.
//

import Moya
import RxSwift

#if TARGET_OS_SIMULATOR

fileprivate var pathDateFormatter = ObjectsCache.ThreadCache(key: "pathDateFormatter") { () -> DateFormatter in
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd_HH-mm-ss.SSS"
    return formatter
}

#endif

public extension MoyaProvider {

    #if TARGET_OS_SIMULATOR


    fileprivate static func CreateTempDirs() {
        try? FileManager.default.createDirectory(atPath: responseLogsPath, withIntermediateDirectories: true, attributes: nil)
    }

    fileprivate static func DumpResponse(_ data: Moya.Response) {
        CreateTempDirs()

        let path =
            "\(responseLogsPath)/" +
                ((data.response?.url?.pathComponents.filter { x in x != "/" }.joined(separator: "_") ?? "") as String) +
                "_" +
                (pathDateFormatter.instance().string(from: Date()) as String) +
        ".txt"
        try? data.data.write(to: URL(fileURLWithPath: path))
    }
    #endif


    func request(_ target: Target,
                        callbackQueue: DispatchQueue? = nil,
                        progress: ProgressBlock? = nil) -> Observable<Moya.Response> {

        return Observable<Moya.Response>.create({ observer in
            let request = self.request(target, callbackQueue: callbackQueue, progress: progress, completion: { result in
                #if TARGET_OS_SIMULATOR
                if let value = result.value {
                    MoyaProvider.DumpResponse(value)
                }
                #endif
                
                if let error = result.error {
                    observer.onError(error)
                } else {
                    if let value = result.value {
                        observer.onNext(value)
                    }
                    observer.onCompleted()
                }
            })

            return Disposables.create {
                request.cancel()
            }
        })
    }
}
