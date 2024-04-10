//
//  CALayer+Attributes.swift
//  FineDustLab
//
//  Created by 박성민 on 3/30/24.
//

import UIKit

public extension CALayer {
    static func gradientLayer(top: UIColor, bottom: UIColor, start: NSNumber = 0.0, end: NSNumber = 1.0) -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [top.cgColor, bottom.cgColor]
        gradientLayer.locations = [start, end]
        return gradientLayer
    }
}
