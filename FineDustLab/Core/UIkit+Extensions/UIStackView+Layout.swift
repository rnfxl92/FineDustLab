//
//  UIStackView+Layout.swift
//  FineDustLab
//
//  Created by 박성민 on 2022/09/22.
//

import UIKit

public extension UIStackView {
    convenience init(axis: NSLayoutConstraint.Axis) {
        self.init()
        self.axis = axis
    }

    @discardableResult
    func addArrangedSubViews<T: UIView>(_ subviews: [T], then closure: (([T]) -> Void)? = nil) -> [T] {
        subviews.forEach { addArrangedSubview($0) }
        closure?(subviews)
        return subviews
    }

    func removeAllArrangedSubviews() {
        let removedSubviews = arrangedSubviews.reduce([]) { allSubviews, subview -> [UIView] in
            self.removeArrangedSubview(subview)
            return allSubviews + [subview]
        }
        NSLayoutConstraint.deactivate(removedSubviews.flatMap({ $0.constraints }))
        removedSubviews.forEach({ $0.removeFromSuperview() })
    }
    
    func insertArrangedSubview(_ view: UIView, belowArrangedSubview subview: UIView) {
        arrangedSubviews.enumerated().forEach {
            if $0.1 == subview {
                insertArrangedSubview(view, at: $0.0 + 1)
            }
        }
    }
    
    func insertArrangedSubview(_ view: UIView, aboveArrangedSubview subview: UIView) {
        arrangedSubviews.enumerated().forEach {
            if $0.1 == subview {
                insertArrangedSubview(view, at: $0.0)
            }
        }
    }
}
