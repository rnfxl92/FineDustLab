//
//  Environment.swift
//  FineDustLab
//
//  Created by 박성민 on 4/6/24.
//

import Foundation
 
struct Environment {
    public static let neisKey: String = {
        value(for: PlistKey.neisKey)
    }()
}

private extension Environment {
    
    struct PlistKey {
        static let neisKey = "NEIS_KEY"
    }
    
    static func value<T>(for key: String) -> T where T: LosslessStringConvertible {
        guard let object = Bundle.main.object(forInfoDictionaryKey: key) else {
            fatalError("Missing key `\(key)` from Info.plist")
        }
        switch object {
        case let value as T:
            return value
        case let string as String:
            guard let value = T(string) else {
                fatalError("Invalid value `\(object)` for key `\(key)` in Info.plist")
            }
            return value
        default:
            fatalError("Invalid value `\(object)` for key `\(key)` in Info.plist")
        }
    }
}
