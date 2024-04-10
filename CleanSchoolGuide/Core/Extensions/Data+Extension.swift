//
//  Data+Extension.swift
//  FineDustLab
//
//  Created by 박성민 on 3/30/24.
//

import Foundation

public extension Data {
    var base64URLEncodedString: String {
        let base64Encoded = base64EncodedString()
        return base64Encoded
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
    }
    
    var asDictionary: [String: AnyHashable]? {
        (try? JSONSerialization.jsonObject(
            with: self,
            options: []
        )) as? [String: AnyHashable]
    }
}
