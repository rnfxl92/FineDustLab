//
//  Encodable+Extension.swift
//  FineDustLab
//
//  Created by 박성민 on 3/30/24.
//

import Foundation

public extension Encodable {
    var asDictionary: [String: Any]? { asJsonObject() }
    
    var asQueryItems: [String: AnyHashable]? { asJsonObject() }
    var asArrayQueryItems: [AnyHashable]? { asJsonObject() }
    
    func asJsonObject<T>(
        options: JSONSerialization.ReadingOptions = []
    ) -> T? {
        guard let data = try? JSONEncoder().encode(self) else {
            return nil
        }

        return (try? JSONSerialization.jsonObject(with: data, options: options))
            .flatMap { $0 as? T }
    }

    var asJsonEncodedData: Data? {
        guard let data = try? JSONEncoder().encode(self) else {
            return nil
        }
        return data
    }
}
