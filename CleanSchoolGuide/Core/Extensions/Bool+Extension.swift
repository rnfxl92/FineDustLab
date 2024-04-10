//
//  Bool+Extension.swift
//  FineDustLab
//
//  Created by 박성민 on 3/30/24.
//

import Foundation

public extension Bool {
    var toYNString: String {
        self ? "Y" : "N"
    }

    var toTrueFalseString: String {
        self ? "true" : "false"
    }

    var not: Bool {
        !self
    }
}
