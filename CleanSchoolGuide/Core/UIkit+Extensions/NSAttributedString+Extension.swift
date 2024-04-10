//
//  NSAttributedString+Extension.swift
//  FineDustLab
//
//  Created by 박성민 on 3/30/24.
//

import UIKit

extension NSAttributedString {
    static public func dividerAttributed(_ dividerImage: UIImage?) -> NSAttributedString {
        let imageString = imageAttributed(dividerImage)
        let paddingString = paddingAttributed(8)
        
        let result = NSMutableAttributedString().addAttributedStrings([paddingString, imageString, paddingString])
        return result
    }
    
    static public func imageAttributed(_ image: UIImage?, topInset: CGFloat = 0) -> NSAttributedString {
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = image
        let imageSize = image?.size ?? .zero
        imageAttachment.bounds = CGRect(x: 0, y: topInset, width: imageSize.width, height: imageSize.height)
        return NSAttributedString(attachment: imageAttachment)
    }
    
    static public func paddingAttributed(_ inset: Int) -> NSAttributedString {
        let paddingAttachment = NSTextAttachment()
        paddingAttachment.bounds = CGRect(x: 0, y: 0, width: inset, height: 0)
        return NSAttributedString(attachment: paddingAttachment)
    }
    
    public func addAttributedStrings(_ strings: [NSAttributedString]) -> NSAttributedString {
        let result = NSMutableAttributedString(attributedString: self)
        strings.forEach { string in
            result.append(string)
        }
        return result
    }
    
    public func addAttributes(_ targetString: String, attributes: [NSAttributedString.Key: Any]) -> NSAttributedString {
        let mutableAttributedString = NSMutableAttributedString(attributedString: self)
        if let range = string.range(of: targetString) {
            mutableAttributedString.addAttributes(attributes, range: NSRange(range, in: string))
        }
        return mutableAttributedString
    }
}
