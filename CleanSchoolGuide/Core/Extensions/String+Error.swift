//
//  String+Error.swift
//  FineDustLab
//
//  Created by 박성민 on 3/30/24.
//

import Foundation

extension String: Error, LocalizedError {
    public var errorDescription: String? { self }
}
