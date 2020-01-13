//
//  DebugHelpers.swift
//  Ilya Gibadullin
//
//  Created by Ilya Gibadullin on 17.10.2018.
//  Copyright © 2020 Ilya Gibadullin. All rights reserved.
//

import Foundation

// MARK: - dmsg

public func dmsg(file: String = #file, function: String = #function, line: Int = #line ) {
    print( "dmsg: \(function) at \(NSString(string: file).lastPathComponent):\(line)" )
}

public func dmsg(_ message: String, file: String = #file, function: String = #function, line: Int = #line ) {
    print( "dmsg: \(message) in \(function) at \(NSString(string: file).lastPathComponent):\(line)" )
}

@discardableResult
public func dmsg<T>(_ object: T, file: String = #file, function: String = #function, line: Int = #line ) -> T where T : Any {
    dmsg(String(describing: object), file: file, function: function, line: line )
    return object
}

@discardableResult
public func dmsg<T>(_ object: T?, file: String = #file, function: String = #function, line: Int = #line ) -> T? where T : Any {
    dmsg(object as Any, file: file, function: function, line: line )
    return object
}

public func dmsg(sender: Any?, file: String = #file, function: String = #function, line: Int = #line ) {
    let addr = address(of: sender) as UnsafeMutableRawPointer
    let visual = visualCode(for: addr)

    dmsg("sender: \(visual)-\(addr)", file: file, function: function, line: line)
}

public func dmsg(_ object: Any, sender: Any?, file: String = #file, function: String = #function, line: Int = #line ) {
    let addr = address(of: sender) as UnsafeMutableRawPointer
    let visual = visualCode(for: addr)

    dmsg("\(String(describing: object)); sender: \(visual)-\(address(of: sender))", file: file, function: function, line: line )
}

// MARK: - utils


fileprivate func generateChar() -> Unicode.Scalar {
    return Unicode.Scalar(Unicode.Scalar("A").value + UInt32(drand48() * Double(Unicode.Scalar("Z").value-Unicode.Scalar("A").value)))!
}

fileprivate func visualCode(for pointer: UnsafeMutableRawPointer) -> String {
    srand48(Int(bitPattern: pointer))

    return "\(generateChar())\(generateChar())\(generateChar())";
}

public func address(of object: Any?) -> UnsafeMutableRawPointer{
    return Unmanaged.passUnretained(object as AnyObject).toOpaque() // FixMe: does not work for nil - returns address of NSNull()
}

public func abstract(function: String = #function) -> Never {
    fatalError("abstract method \"\(function)\"is not implemented")
}

public func notImplemented(function: String = #function) -> Never {
    fatalError("\(function) has not been implemented")
}

/* file: String = #file, function: String = #function, line: Int = #line */
public func measureElapsedTime(file: String = #file, function: String = #function, line: Int = #line, work: @escaping () -> ()) {
    let start = CFAbsoluteTimeGetCurrent()
    work()
    let diff = CFAbsoluteTimeGetCurrent() - start
    print("Took \(diff) seconds  in \(function) at \(NSString(string: file).lastPathComponent):\(line)")
}
