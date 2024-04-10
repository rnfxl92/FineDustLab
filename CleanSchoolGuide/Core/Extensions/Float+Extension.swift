//
//  Float+Extension.swift
//  FineDustLab
//
//  Created by 박성민 on 3/30/24.
//

import Foundation

public extension Float {
    var toRoundInt: Int {
        Int(self.rounded())
    }
}
