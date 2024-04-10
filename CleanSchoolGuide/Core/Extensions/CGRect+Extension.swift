//
//  CGRect+Extension.swift
//  FineDustLab
//
//  Created by 박성민 on 3/30/24.
//

import Foundation

extension CGRect {
    public var center: CGPoint {
        CGPoint(x: midX, y: midY)
    }
}
