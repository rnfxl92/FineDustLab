//
//  UIView+Attributes.swift
//  FineDustLab
//
//  Created by 박성민 on 2022/09/22.
//

import SnapKit
import UIKit

public extension UIView {

    @discardableResult
    func withConstraints(_ closure: (_ make: ConstraintMaker) -> Void) -> Self {
        self.snp.makeConstraints(closure)
        return self
    }

    @discardableResult
    func withFixedHeight(_ height: CGFloat) -> Self {
        withConstraints({ $0.height.equalTo(height) })
    }

    @discardableResult
    func withBackgroundColor(_ color: UIColor) -> Self {
        self.backgroundColor = color
        return self
    }
}
