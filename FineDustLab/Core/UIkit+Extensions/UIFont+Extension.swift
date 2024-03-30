//
//  UIFont+Extension.swift
//  FineDustLab
//
//  Created by 박성민 on 2023/02/08.
//

import UIKit

public extension UIFont {
    static let largeTitle = TextStyle.largeTitle
    static let title1 = TextStyle.title1
    static let title3 = TextStyle.title3
    static let body = TextStyle.body
    static let subheadline = TextStyle.subheadline
    static let footnote = TextStyle.footnote
    static let caption1 = TextStyle.caption1
    static let caption2 = TextStyle.caption2
}

public extension UIFont.TextStyle {
    var regular: UIFont { font() }
    var bold: UIFont { font(.bold) }
    
    var fixedRegular: UIFont { fixedFont() }
    var fixedBold: UIFont { fixedFont(.bold) }
}

extension UIFont.TextStyle {
    func fixedFont(_ weight: UIFont.Weight = .regular) -> UIFont {
        .systemFont(ofSize: defaultPointSize, weight: weight)
    }
    
    func font(_ weight: UIFont.Weight = .regular) -> UIFont {
        fixedFont(weight)
    }
    
    var defaultPointSize: CGFloat {
        switch self {
        case .largeTitle:
            return 34
        case .title1:
            return 28
        case .title2:
            return 22
        case .title3:
            return 20
        case .headline:
            return 17
        case .body:
            return 17
        case .callout:
            return 16
        case .subheadline:
            return 15
        case .footnote:
            return 13
        case .caption1:
            return 12
        case .caption2:
            return 11
        default:
            return 17
        }
    }
}
