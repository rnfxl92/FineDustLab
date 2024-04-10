//
//  UITextField+Extension.swift
//  FineDustLab
//
//  Created by 박성민 on 2023/07/19.
//  
//

import UIKit

extension UITextField {
    public func addHideKeyboardButton(title: String,
                                      barTintColor: UIColor? = nil,
                                      tintColor: UIColor? = nil,
                                      completion: (() -> Void)? = nil) {
        let doneToolbar: UIToolbar = UIToolbar(frame:
                                                CGRect.init(
                                                    x: 0,
                                                    y: 0,
                                                    width: UIScreen.main.bounds.width,
                                                    height: 50))
        doneToolbar.barStyle = .default
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: title, style: .done, target: self, action: #selector(hideKeyboard))

        if let completion {
            objc_setAssociatedObject(self, &AssociatedKeys.hideKeyboardCompletionKey, completion, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }

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
        if let completion = objc_getAssociatedObject(self, &AssociatedKeys.hideKeyboardCompletionKey) as? () -> Void {
            completion()
        }
        resignFirstResponder()
    }

    public func addLeftInset(_ inset: CGFloat) {
        leftView = UIView(frame: CGRect(x: 0, y: 0, width: inset, height: height))
        leftViewMode = .always
    }
}

private struct AssociatedKeys {
    static var hideKeyboardCompletionKey = "hideKeyboardCompletionKey"
}
