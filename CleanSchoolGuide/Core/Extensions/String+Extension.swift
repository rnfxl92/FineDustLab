//
//  String+Extension.swift
//  FineDustLab
//
//  Created by 박성민 on 3/30/24.
//

import UIKit
import Foundation

public extension String {
    
    func validateRegex(with regex: String) -> Bool {
        let regex = NSRegularExpression(regex)
        return regex.matches(self)
    }
    
    func convertDate(
        beforeFormatter: DateFormatter,
        afterFormatter: DateFormatter
    ) -> Self {
        guard let convertDate = beforeFormatter.date(from: self) else { fatalError("Unsupported format") }
        return afterFormatter.string(from: convertDate)
    }
    
    var isBlank: Bool {
        self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    func urlEncode() -> String? {
        self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
    }

    // Encode `self` with URL escaping considered.
    var base64URLEncoded: String {
        self.replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
    }

    var base64URLDecoded: String? {
        guard let data = self.base64URLDecodedData else {
            return nil
        }

        return String(data: data, encoding: .utf8)
    }

    // Returns the data of `self` (which is a base64 string), with URL related characters decoded.
    var base64URLDecodedData: Data? {
        let paddingLength = 4 - count % 4
        // Filling = for %4 padding.
        let padding = (paddingLength < 4) ? String(repeating: "=", count: paddingLength) : ""
        let base64EncodedString = self
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
            + padding
        return Data(base64Encoded: base64EncodedString)
    }

    // Returns the data of `self` (which is a base64 string), with URL related characters decoded.
    var restoreBase64URLDecoded: String {
        let paddingLength = 4 - count % 4
        // Filling = for %4 padding.
        let padding = (paddingLength < 4) ? String(repeating: "=", count: paddingLength) : ""
        let base64EncodedString = self
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
            + padding
        return base64EncodedString
    }
    
    func toDate() -> Date? {
        let dateFormatter = ISO8601DateFormatter()
        
        return dateFormatter.date(from: self)
    }

    func toDateWithSeconds() -> Date? {
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return dateFormatter.date(from: self)
    }
    
    func toDate(format: Date.Format) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.value
        
        return dateFormatter.date(from: self)
    }

    func index(from: Int) -> Index {
        self.index(startIndex, offsetBy: from)
    }
    
    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return String(self[fromIndex...])
    }
    
    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return String(self[..<toIndex])
    }
    
    func substring(with range: Range<Int>) -> String {
        let startIndex = index(from: range.lowerBound)
        let endIndex = index(from: range.upperBound)
        return String(self[startIndex..<endIndex])
    }

    func substring(from: Int, to: Int) -> String {
        guard from < count, to >= 0, to - from >= 0 else { return "" }
        let startIndex = index(startIndex, offsetBy: from)
        let endIndex = index(startIndex, offsetBy: to + 1)
        return String(self[startIndex ..< endIndex])
    }

    func inserting(_ string: String, at index: Int) -> String {
        var originalString = self
        originalString.insert(contentsOf: string, at: self.index(self.startIndex, offsetBy: index))
        return originalString
    }

    func isKoreanOrEnglishOnly() -> Bool {
        let pattern = "^[가-힣a-zA-Z]+$"
        guard let regex = try? NSRegularExpression(pattern: pattern) else { return false }
        return regex.firstMatch(in: self, range: NSRange(self.startIndex..., in: self)) != nil
    }

    func isValidDate(format: Date.Format) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.value
        dateFormatter.timeZone = .autoupdatingCurrent
        dateFormatter.locale = Locale.current
        return dateFormatter.date(from: self) != nil
    }

    func convertDateStringToDateComponents(format: Date.Format) -> (year: Int, month: Int, day: Int)? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.value

        if let date = dateFormatter.date(from: self) {
            let calendar = Calendar.current
            let year = calendar.component(.year, from: date)
            let month = calendar.component(.month, from: date)
            let day = calendar.component(.day, from: date)
            return (year, month, day)
        }

        return nil
    }

    func calculateAge(format: Date.Format) -> Int? {
        if let dateComponents = convertDateStringToDateComponents(format: format) {
            let calendar = Calendar.current
            let currentYear = calendar.component(.year, from: Date())
            let currentMonth = calendar.component(.month, from: Date())
            let currentDay = calendar.component(.day, from: Date())

            var age = currentYear - dateComponents.year

            if (dateComponents.month, dateComponents.day) > (currentMonth, currentDay) {
                age -= 1
            }

            return age
        }
        return nil
    }
    
    public func foregroundColor(_ color: UIColor) -> NSAttributedString {
        NSAttributedString(string: self, attributes: [.foregroundColor: color])
    }
    
    public func highlighted(_ color: UIColor, string: String) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        
        let regex = try? NSRegularExpression(pattern: "\(string)")
        regex?.matches(in: self, range: NSRange(startIndex..., in: self)).forEach {
            attributedString.addAttribute(.foregroundColor, value: color, range: $0.range)
        }
        
        return attributedString
    }
    
    public func highlighted(_ color: UIColor, strings: [String]) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        
        for string in strings {
            let regex = try? NSRegularExpression(pattern: "\(string)")
            regex?.matches(in: self, range: NSRange(startIndex..., in: self)).forEach {
                attributedString.addAttribute(.foregroundColor, value: color, range: $0.range)
            }
        }
        
        return attributedString
    }
    
    public func emphasized(_ font: UIFont, string: String) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        
        let regex = try? NSRegularExpression(pattern: "\(string)")
        regex?.matches(in: self, range: NSRange(startIndex..., in: self)).forEach {
            attributedString.addAttribute(.font, value: font, range: $0.range)
        }
        
        return attributedString
    }
    
    public func underlined(string: String) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        
        let regex = try? NSRegularExpression(pattern: "\(string)")
        regex?.matches(in: self, range: NSRange(startIndex..., in: self)).forEach {
            attributedString.addAttribute(.underlineStyle,
                                          value: NSUnderlineStyle.single.rawValue,
                                          range: $0.range)
        }
        
        return attributedString
    }
    
    func attributedString(string: String, attributes: [NSAttributedString.Key: Any]) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        
        let range = (self as NSString).range(of: string)
        attributedString.addAttributes(attributes, range: range)
        
        return attributedString
    }
    
    func ranges(of searchString: String) -> [Range<String.Index>] {
        var ranges: [Range<String.Index>] = []
        var startIndex = self.startIndex
        while startIndex < self.endIndex, let range = self[startIndex...].range(of: searchString) {
            ranges.append(range)
            startIndex = range.lowerBound < range.upperBound ? range.upperBound : self.index(range.lowerBound, offsetBy: 1)
        }
        return ranges
    }
    
    func nsRanges(from ranges: [Range<String.Index>]) -> [NSRange] {
           return ranges.map { NSRange($0, in: self) }
       }
}

public extension Optional where Wrapped == String {
    var isNilOrEmpty: Bool {
        guard let text = self else {
            return true
        }
        
        return text.isBlank
    }
    
    var isNotNilOrEmpty: Bool { !isNilOrEmpty }
}

public extension NSRegularExpression {
    convenience init(_ pattern: String) {
        do {
            try self.init(pattern: pattern)
        } catch {
            preconditionFailure("Illegal regular expression: \(pattern).")
        }
    }
    
    func matches(_ string: String) -> Bool {
        let range = NSRange(location: 0, length: string.utf16.count)
        return firstMatch(in: string, options: [], range: range) != nil
    }
}
