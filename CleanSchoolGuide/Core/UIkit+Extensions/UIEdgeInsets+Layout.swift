//
//  UIEdgeInsets+Layout.swift
//  FineDustLab
//
//  Created by 박성민 on 2022/09/22.
//

import UIKit

extension UIEdgeInsets {

    public init(all: CGFloat) {
        self.init(top: all, left: all, bottom: all, right: all)
    }

    public init(horizontal: CGFloat = .zero, vertical: CGFloat = .zero) {
        self.init(top: vertical, left: horizontal, bottom: vertical, right: horizontal)
    }

    public static func + (lhs: UIEdgeInsets, rhs: UIEdgeInsets) -> UIEdgeInsets {
        UIEdgeInsets(top: lhs.top + rhs.top, left: lhs.left + rhs.left, bottom: lhs.bottom + rhs.bottom, right: lhs.right + rhs.right)
    }

    public static func - (lhs: UIEdgeInsets, rhs: UIEdgeInsets) -> UIEdgeInsets {
        UIEdgeInsets(top: lhs.top - rhs.top, left: lhs.left - rhs.left, bottom: lhs.bottom - rhs.bottom, right: lhs.right - rhs.right)
    }

}

extension NSDirectionalEdgeInsets {
    public init(horizontal: CGFloat) {
        self.init(top: .zero, leading: horizontal, bottom: .zero, trailing: horizontal)
    }

    public init(vertical: CGFloat) {
        self.init(top: vertical, leading: .zero, bottom: vertical, trailing: .zero)
    }

    public init(horizontal: CGFloat, vertical: CGFloat) {
        self.init(top: vertical, leading: horizontal, bottom: vertical, trailing: horizontal)
    }

    public init(all: CGFloat) {
        self.init(top: all, leading: all, bottom: all, trailing: all)
    }
}
