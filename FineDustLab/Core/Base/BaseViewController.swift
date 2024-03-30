//
//  BaseViewController.swift
//  FineDustLab
//
//  Created by 박성민 on 3/30/24.
//

import UIKit

open class BaseViewController: UIViewController {
    deinit {
        Logger.trace("\(Self.self)")
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        setUserInterface()
        bind()
    }

    open func setUserInterface() {}
    open func bind() {}

    public func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

