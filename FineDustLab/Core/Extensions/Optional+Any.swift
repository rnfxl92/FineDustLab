//
//  Optional+Any.swift
//  FineDustLab
//
//  Created by 박성민 on 3/30/24.
//

import Foundation

public protocol AnyOptional {
    var isNil: Bool { get }
}

extension Optional: AnyOptional {
    public var isNil: Bool { self == nil }
}

extension Optional where Wrapped: Collection {
    public var isNilOrEmpty: Bool {
        guard let self = self else { return true }
        
        return self.isEmpty
    }
}

extension Optional where Wrapped: NSAttributedString {
    public var isNilOrEmpty: Bool {
        guard let self = self else { return true }

        return self.string.isEmpty
    }
}
