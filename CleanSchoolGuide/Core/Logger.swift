//
//  Logger.swift
//  FineDustLab
//
//  Created by 박성민 on 3/30/24.
//

import Foundation

/// log for console
public final class Logger {
    public init() {}
}

public extension Logger {
    static func debug(
        _ msg: Any,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
#if DEBUG
        let fileName = file.split(separator: "/").last ?? ""
        let funcName = function.split(separator: "(").first ?? ""
        print("⚬ 🟢 [\(Date())] [\(fileName)] \(funcName)(\(line)) : \(msg)")
#endif
    }
    
    static func info(
        _ msg: Any,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
#if DEBUG
        let fileName = file.split(separator: "/").last ?? ""
        let funcName = function.split(separator: "(").first ?? ""
        print("⚬ 🔵 [\(Date())] [\(fileName)] \(funcName)(\(line)) : \(msg)")
#endif
    }
    
    static func error(
        _ msg: Any,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
#if DEBUG
        let fileName = file.split(separator: "/").last ?? ""
        let funcName = function.split(separator: "(").first ?? ""
        print("⚬ 🔴 [\(Date())] [\(fileName)] \(funcName)(\(line)) : \(msg)")
#endif
    }
    
    static func trace(
        _ message: String,
        function: String = #function,
        line: Int = #line
    ) {
#if DEBUG
        let funcName = function.split(separator: "(").first ?? ""
        print("✨ [\(message)] \(funcName):\(line)")
#endif
    }
    
    static func log(
        _ msg: [String: Any],
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        let fileName = file.split(separator: "/").last ?? ""
        let funcName = function.split(separator: "(").first ?? ""
        print("😎 [\(Date())] [\(fileName)] \(funcName)(\(line))")
        msg.forEach { key, value in
            print("\(key): \(value)")
        }
    }
}
