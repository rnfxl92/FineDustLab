//
//  UserDefaultsWrapper.swift
//  Mimun
//
//  Created by 박성민 on 3/16/24.
//

import Foundation

public protocol UserDefaultsKeyType {
    var value: String { get }
}

@propertyWrapper
public struct UserDefaultsWrapper<T: Codable> {
    private let key: UserDefaultsKeyType
    private let defaultValue: T
    
    private let userDefaults = UserDefaults.standard
    
    public init(key: UserDefaultsKeyType, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }

    public var wrappedValue: T {
        get {
            let object = userDefaults.object(forKey: key.value)
            switch object {
            case let value as T:
                return value
            case let value as Data:
                let decoder = JSONDecoder()
                guard let decoded = try? decoder.decode(T.self, from: value) else {
                    return defaultValue
                }

                return decoded
            default:
                return defaultValue

            }
        }
        
        set {
            let encoder = JSONEncoder()
            guard let encoded = try? encoder.encode(newValue) else {
                userDefaults.removeObject(forKey: key.value)
                return
            }

            switch newValue {
            case let optional as AnyOptional where optional.isNil:
                userDefaults.removeObject(forKey: key.value)
            default:
                userDefaults.set(encoded, forKey: key.value)
            }
        }
    }
}

