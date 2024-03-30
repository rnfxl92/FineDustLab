//
//  UIImage+Extension.swift
//  FineDustLab
//
//  Created by 박성민 on 2023/03/02.
//  
//

import UIKit

extension UIImage {
    public func crop(with rect: CGRect) -> UIImage? {
        guard let cgImage = cgImage else { return nil }
        let width = CGFloat(cgImage.width)
        let height = CGFloat(cgImage.height)
        let cropRect = CGRect(x: rect.minX * width, y: rect.minY * height, width: rect.width * width, height: rect.height * height)
        if let croppedCGImage = cgImage.cropping(to: cropRect) {
            return UIImage(cgImage: croppedCGImage, scale: 1.0, orientation: imageOrientation)
        }
        return nil
    }

    // swiftlint:disable identifier_name
    public func cropCenter() -> UIImage? {
        guard let cgImage = cgImage else { return nil }
        let width = min(cgImage.width, cgImage.height)
        let height = width
        let x = (cgImage.width - width) / 2
        let y = (cgImage.height - height) / 2
        let cropRect = CGRect(x: x, y: y, width: width, height: height)
        if let croppedCGImage = cgImage.cropping(to: cropRect) {
            return UIImage(cgImage: croppedCGImage, scale: 1.0, orientation: imageOrientation)
        }
        return nil
    }
}
