//
//  UIDevice+Extensions.swift
//  CleanSchoolGuide
//
//  Created by 박성민 on 4/23/24.
//

import UIKit

public extension UIDevice {
    public var hasNotch: Bool {
        let bottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
        return bottom > 0
    }
}
