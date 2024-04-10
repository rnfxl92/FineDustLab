//
//  Set+Extension.swift
//  FineDustLab
//
//  Created by 박성민 on 3/30/24.
//

import Foundation

extension Set {
    public func compactMap<T>(_ transform: (Element) throws -> T?) rethrows -> Set<T> {
        var result = Set<T>()
        
        forEach { value in
            if let transformed = try? transform(value) {
                result.insert(transformed)
            }
        }
        
        return result
    }
}
