//
//  Bundle+Extension.swift
//  FineDustLab
//
//  Created by 박성민 on 3/30/24.
//

import Foundation

public extension Bundle {
    static let externalURLSchemes: [String] = {
        guard let urlTypes = main.infoDictionary?["CFBundleURLTypes"] as? [[String: Any]] else {
            return []
        }
        
        var result: [String] = []
        for urlTypeDictionary in urlTypes {
            guard let urlSchemes = urlTypeDictionary["CFBundleURLSchemes"] as? [String] else { continue }

            result.append(contentsOf: urlSchemes)
        }
        
        return result
    }()
}
