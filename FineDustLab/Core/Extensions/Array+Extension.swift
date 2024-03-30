//
//  Array+Extension.swift
//  FineDustLab
//
//  Created by 박성민 on 3/30/24.
//

import UIKit

public extension Array {
    subscript (safe index: Int) -> Element? { indices ~= index ? self[index] : nil }

    /**
     Usage:
     let array = [1, 2, 3, 4, 5, 6, 7, 8]

     array[safe: [1, 4, 7]] -> [2, 5, 8]
     array[safe: [4, 10, 6]] -> [5, nil, 7]
     */
    subscript (safe indexes: [Int]) -> [Element?] { indexes.map { self[safe: $0] } }

    /**
     Usage:
     let array = [[1, 2, [3, 4]], [4, 5, 6, 7], [8, 9]]

     array[deepSafe: [0, 2, 0]] -> 3
     array[deepSafe: [2, 1]] -> 9
     array[deepSafe: [2, 1, 2]] -> nil
     */
    subscript(deepSafe indexes: [Int]) -> Any? {
        var paths = indexes
        let index = paths.removeFirst()
        guard let value = self[safe: index] else {
            return nil
        }

        if let value = value as? [Any], paths.count > 0 {
            return value[deepSafe: paths]
        }

        return value
    }
    
    func appended(_ element: Element) -> Array {
        var result = self
        result.append(element)
        return result
    }
    
    var jsonSerialization: Data? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            return jsonData
        } catch {
            return nil
        }
    }
}

public extension Collection {
    var isNotEmpty: Bool { isEmpty == false }
}

public extension Sequence {
    func group<U: Hashable>(
        by key: (Iterator.Element) -> U
    ) -> [U: [Iterator.Element]] {
        Dictionary(grouping: self, by: key)
    }
}

public extension Sequence where Iterator.Element == NSAttributedString {
    func joined(with separator: NSAttributedString) -> NSAttributedString {
        reduce(NSMutableAttributedString()) { result, element in
            if result.length > 0 {
                result.append(separator)
            }
            result.append(element)
            return result
        }
    }
    
    func joined(with separator: String = "") -> NSAttributedString {
        joined(with: NSAttributedString(string: separator))
    }
}

public extension SetAlgebra {
    var isNotEmpty: Bool { isEmpty.not }
}

public extension Array where Element == String {
    func getDotPrefixAttributedString(font: UIFont, foregroundColor: UIColor) -> NSAttributedString? {
        let paragraphStyleList = NSMutableParagraphStyle()
        paragraphStyleList.lineBreakMode = .byWordWrapping
        paragraphStyleList.paragraphSpacing = 12
        paragraphStyleList.headIndent = 8.0
        
        let listAttributes: [NSAttributedString.Key: Any] = [.font: font,
                                                             .foregroundColor: foregroundColor,
                                                             .paragraphStyle: paragraphStyleList]
        let dotAttributes: [NSAttributedString.Key: Any] = [.font: font,
                                                            .foregroundColor: foregroundColor,
                                                            .paragraphStyle: paragraphStyleList]
        
        let attributedString: NSMutableAttributedString = NSMutableAttributedString()
        
        for string in self {
            attributedString.append(NSAttributedString(string: "• ", attributes: dotAttributes))
            attributedString.append(NSAttributedString(string: string, attributes: listAttributes))
            if string != self.last {
                attributedString.append(NSAttributedString(string: "\n"))
            }
        }
        
        return attributedString
    }
}
