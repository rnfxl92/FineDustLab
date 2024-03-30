//
//  Double+Extension.swift
//  FineDustLab
//
//  Created by 박성민 on 3/30/24.
//

import Foundation

public extension Double {
    // banker's rounding
    var rounded: Int {
        Int(self.rounded(.toNearestOrEven))
    }
}
