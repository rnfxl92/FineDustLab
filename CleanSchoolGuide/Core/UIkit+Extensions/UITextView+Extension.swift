//
//  UITextView+Extension.swift
//  FineDustLab
//
//  Created by 박성민 on 2023/09/14.
//  
//

import UIKit

extension UITextView {
    public func addHideKeyboardButton(title: String, barTintColor: UIColor? = nil, tintColor: UIColor? = nil) {
        let doneToolbar: UIToolbar = UIToolbar(frame:
                                                CGRect.init(
                                                    x: 0,
                                                    y: 0,
                                                    width: UIScreen.main.bounds.width,
                                                    height: 50))
        doneToolbar.barStyle = .default
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: title, style: .done, target: self, action: #selector(hideKeyboard))
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()

        // 툴바 add 함수에 컬러 파라미터 옵셔널로 추가
        if let barTintColor {
            doneToolbar.barTintColor = barTintColor
        }
        if let tintColor {
            doneToolbar.tintColor = tintColor
        }

        inputAccessoryView = doneToolbar
    }

    @objc private func hideKeyboard() {
        resignFirstResponder()
    }
}

extension UITextView {
    public func checkMaxCount(_ maxTextCount: Int, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let lastText = self.text as NSString
        let allText = lastText.replacingCharacters(in: range, with: text)
        let totalCount = (allText as NSString).length
        return totalCount <= maxTextCount
    }
}
