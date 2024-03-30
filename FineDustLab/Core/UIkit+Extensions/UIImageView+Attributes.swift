//
//  UIImageView+Attributes.swift
//  FineDustLab
//
//  Created by 박성민 on 2022/09/22.
//

import UIKit

extension UIImageView {
    public func convertPosition(_ position: CGPoint) -> CGPoint {
        guard let imageWidth = image?.cgImage?.width else { return .zero }
        let scale = width / CGFloat(imageWidth)
        let convertedX = position.x * scale
        let convertedY = position.y * scale
        return CGPoint(x: convertedX, y: convertedY)
    }
}
