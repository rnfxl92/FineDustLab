//
//  UILabel+Attributes.swift
//  FineDustLab
//
//  Created by 박성민 on 2022/09/22.
//

import UIKit

extension UILabel {

    @discardableResult
    public func withText(_ text: String?) -> Self {
        self.text = text
        return self
    }

    @discardableResult
    public func withTextColor(_ color: UIColor?) -> Self {
        self.textColor = color
        return self
    }

    @discardableResult
    public func withFont(_ font: UIFont) -> Self {
        self.font = font
        return self
    }

    @discardableResult
    public func withAlignment(_ alignment: NSTextAlignment?) -> Self {
        self.textAlignment = alignment ?? .natural
        return self
    }

    @discardableResult
    public func withNumberOfLines(_ number: Int) -> Self {
        self.numberOfLines = number
        return self
    }

    @discardableResult
    public func withLineBreakMode(_ mode: NSLineBreakMode) -> Self {
        self.lineBreakMode = mode
        return self
    }

    @discardableResult
    public func withSizeToFit() -> Self {
        self.sizeToFit()
        return self
    }

    @discardableResult
    public func withTransform(scaleX: CGFloat, scaleY: CGFloat) -> Self {
        self.transform = CGAffineTransform(scaleX: scaleX, y: scaleY)
        return self
    }

    @discardableResult
    public func withPartialFontColor(targetString: String, font: UIFont, color: UIColor) -> Self {
        let originText = text ?? ""
        let attributeString = NSMutableAttributedString(string: originText)
        let range = (originText as NSString).range(of: targetString)
        attributeString.addAttributes([.font: font as Any, .foregroundColor: color as Any], range: range)
        attributedText = attributeString
        return self
    }

    @discardableResult
    public func withPartialsFontColor(targetStrings: [String], font: UIFont, color: UIColor) -> Self {
        let originText = text ?? ""
        let attributeString = NSMutableAttributedString(string: originText)

        targetStrings.forEach {
            let range = (originText as NSString).range(of: $0)
            attributeString.addAttributes([.font: font as Any, .foregroundColor: color as Any], range: range)
        }
        attributedText = attributeString
        return self
    }
    
    @discardableResult
    public func withUnderlineText(_ text: String) -> Self {
        let textRange = NSRange(location: 0, length: text.count)
        let attributedText = NSMutableAttributedString(string: text)
        attributedText.addAttribute(
            .underlineStyle,
            value: NSUnderlineStyle.single.rawValue,
            range: textRange
        )
        self.attributedText = attributedText
        return self
    }
}
